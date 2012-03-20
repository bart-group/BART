//
//  EyeTracInterpret.m
//  BARTSerialIOPluginEyeTrac
//
//  Created by Lydia Hellrung on 11/19/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "EyeTracInterpret.h"


@interface EyeTracInterpret (PrivateMethods)

-(BOOL)isFixationForMidpoint:(NSPoint)midPoint andXYDistance:(NSPoint)dist atCurrentPos:(NSPoint)currentEyePos;

-(NSUInteger)calcDispersionThresholdForVisualAngle:(float)angle andDistanceEyeToScreen:(float)dist andHeightScreen:(float)heightScr andResolutionHeight:(float)res;
-(BOOL)getMin:(float*)minValue andMax:(float*)maxValue andMean:(float*)meanValue ofParam:(PARAMS)par fromVector:(std::vector<TEyeTracParams>)eyeTracParams;

-(std::vector<TEyeTracParams>)getLastData;

@end



@implementation EyeTracInterpret


-(id)init
{
	if ((self = [super init]))
	{
        //(1) load the plugin own config file to read all the EyeTrac special configuration stuff
		NSString *errDescr = nil;
		NSPropertyListFormat format;
		NSString *plistPath;
		NSString *rootPath = 
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
         objectAtIndex:0];
		plistPath = [rootPath stringByAppendingPathComponent:@"ConfigSerialIOEyeTrac.plist"];
        NSBundle *thisBundle;
		if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
		{
            thisBundle = [NSBundle bundleForClass:[self class]]; 
            plistPath = [thisBundle pathForResource:@"ConfigSerialIOEyeTrac" ofType:@"plist"];
		}
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
		NSDictionary *arrayFromPlist = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML
                                                                                         mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                                   format:&format 
                                                                                         errorDescription:&errDescr];
		if (!arrayFromPlist)
		{
			NSLog(@"Error reading plist from BARTSerialIOPluginEyeTrac: %@, format: %lu", errDescr, format);
            return nil;
		}
        
        // have a valid plist file read
        //(2) all about the bytes that will be read
		relevantBytes = [[arrayFromPlist objectForKey:@"RelevantBytes"] unsignedIntegerValue];
        valueBuffer = (char*) malloc(sizeof(char) * relevantBytes);
		indexBuffer = 0;
        isStarted = NO; //TODO: check if really neccessary
        
		NSArray *byteMeanings = [NSArray arrayWithArray:[arrayFromPlist objectForKey:@"ByteMeaning"]];
        // find out positions of the parameters
        posStatus = [byteMeanings indexOfObject:@"Status"];
        posHSBDiam = [byteMeanings indexOfObject:@"PupilDiameterHSB"];
        posLSBDiam = [byteMeanings indexOfObject:@"PupilDiameterLSB"];
        posHSBHgaz = [byteMeanings indexOfObject:@"HorizontalGazeHSB"];
        posLSBHgaz = [byteMeanings indexOfObject:@"HorizontalGazeLSB"];
        posHSBVgaz = [byteMeanings indexOfObject:@"VerticalGazeHSB"];
        posLSBVgaz = [byteMeanings indexOfObject:@"VerticalGazeLSB"];
        posOverflow1 = [byteMeanings indexOfObject:@"Overflow1"];
        posOverflow2 = [byteMeanings indexOfObject:@"Overflow2"];
        posHSBCRDiam = [byteMeanings indexOfObject:@"CorneaDiameterHSB"];
        posLSBCRDiam = [byteMeanings indexOfObject:@"CorneaDiameterLSB"];
        if ( (NSNotFound == posHSBCRDiam) || (NSNotFound == posLSBCRDiam)){
            posHSBCRDiam = 0;
            posLSBCRDiam =0;
        }
		
        //(3) read all relevant eye tracker parameters from plist 
        NSUInteger sampleRate = [[arrayFromPlist objectForKey:@"sampleRate"] unsignedIntegerValue];
        NSUInteger durationThreshold = [[arrayFromPlist objectForKey:@"durationThresholdForFixation"] unsignedIntegerValue];   
        analyseWindowSize = static_cast<NSUInteger>((durationThreshold/1000.0) * sampleRate);
        
        float visualAngle = [[arrayFromPlist objectForKey:@"visualAngleValidForFixation"] floatValue]; //# the visual angle in °
        float distEyeScreen = [[arrayFromPlist objectForKey:@"distEyeFromScreen"] floatValue];// # in cm
        float heightScreen = [[arrayFromPlist objectForKey:@"heightScreen"] floatValue];// #in cm
        scenePOGResolutionHeight = [[arrayFromPlist objectForKey:@"scenePOGResolutionHeightInPoints"] floatValue];//# in points
        scenePOGResolutionWidth = [[arrayFromPlist objectForKey:@"scenePOGResolutionWidthInPoints"] floatValue];//# in points
        dispersionThreshold = [self calcDispersionThresholdForVisualAngle:visualAngle andDistanceEyeToScreen:distEyeScreen andHeightScreen:heightScreen andResolutionHeight:scenePOGResolutionHeight];
        
        //(4) read all the fixation algorithm relevant parameters
        CGFloat maxDistanceForFixationX = [[arrayFromPlist objectForKey:@"validDistanceX"] floatValue];
        CGFloat maxDistanceForFixationY = [[arrayFromPlist objectForKey:@"validDistanceY"] floatValue];
        maxDistanceForFixation = NSMakePoint(maxDistanceForFixationX, maxDistanceForFixationY);
        
        fixationDependsOnPoint = NSMakePoint(0.0, 0.0);
        if (YES == [[arrayFromPlist objectForKey:@"FixationDependsOnScreenCenter"] boolValue]){
            isFixationDependingOnScreenCenter = YES;
        }
        else{
            isFixationDependingOnScreenCenter = NO;
            CGFloat fixPosX = [[arrayFromPlist objectForKey:@"FixationDependsOnPointX"] floatValue];
            CGFloat fixPosY = [[arrayFromPlist objectForKey:@"FixationDependsOnPointY"] floatValue];
            fixationDependsOnPoint.x = fixPosX;
            fixationDependsOnPoint.y = fixPosY;
        }
        validMissingsInFixation = [[arrayFromPlist objectForKey:@"maxNumberOfMissingValuesForFixation"] unsignedIntegerValue];
      	
        
        // (5) Miscelleanous stuff have to be initialized
		//Dispatch stuff
        serialQueue = dispatch_queue_create("de.mpg.cbs.BART.EyeTrackerSerialQueue", NULL);
        // the path for the own logfile
        logfilePath = [arrayFromPlist objectForKey:@"LogfilePath"];
        		
                
        /*****************************/
        // (6) temporary stuff to create an output file
		struct tm* ptr;
		time_t lt;
		char fname[80];
		lt = time(NULL);
		ptr = localtime(&lt);
		strftime(fname, 80, "EyeTracLog_%H_%M_%S.txt", ptr);
		file = fopen(fname, "w");
        strftime(fname, 80, "EyeTracFixationsOK_%H_%M_%S.txt", ptr);
		fileFixationsOK = fopen(fname, "w");
        strftime(fname, 80, "EyeTracFixationsOUT_%H_%M_%S.txt", ptr);
		fileFixationsOut = fopen(fname, "w");
        strftime(fname, 80, "EyeTracAllBytes_%H_%M_%S.txt", ptr);
		fileAllBytes = fopen(fname, "w");
        
		//print a header to the file
		fprintf(file, "Status\t\tTime\t\tPupilDiam\t\tCorneaDiam\t\tHorGaze\t\tVerGaze\n\n");
        fprintf(fileFixationsOK, "CentroidH\t\tCentroidV\n\n");
        fprintf(fileFixationsOut, "CentroidH\t\tCentroidV\n\n");
         
         /******************************/
        
    }
	
	return self;
	
}

-(void) valueArrived:(char)value{
    
    if ((value & (unsigned char)0x80) != 0 ) {
		//Ausgabe
		// see Eye Tracker Manual (Model 504) for further explanation
		// the story is to sum up the LSB and HSB with the missing first bit from the overflow byte
		
		unsigned int pupilDiam = (((valueBuffer[posOverflow1] & BITMASKOVERFLOWHSBDIAM) != 0 ? (valueBuffer[posHSBDiam] | 0x80) : valueBuffer[posHSBDiam]) << 8) | 
        ((valueBuffer[posOverflow1] & BITMASKOVERFLOWLSBDIAM) != 0 ? (valueBuffer[posLSBDiam] | 0x80) : valueBuffer[posLSBDiam]);
		
        int horizGaze = (((valueBuffer[posOverflow1] & BITMASKOVERFLOWHSBHGAZ) != 0 ? (valueBuffer[posHSBHgaz] | 0x80) : valueBuffer[posHSBHgaz]) << 8) | 
        ((valueBuffer[posOverflow2] & BITMASKOVERFLOWLSBHGAZ) != 0 ? (valueBuffer[posLSBHgaz] | 0x80) : valueBuffer[posLSBHgaz]);
		
		// Attention: first bit for LSB for vertical in overflow2
        int vertGaze = (((valueBuffer[posOverflow2] & BITMASKOVERFLOWHSBVGAZ) != 0 ? (valueBuffer[posHSBVgaz] | 0x80) : valueBuffer[posHSBVgaz]) << 8) | 
        ((valueBuffer[posOverflow2] & BITMASKOVERFLOWLSBVGAZ) != 0 ? (valueBuffer[posLSBVgaz] | 0x80) : valueBuffer[posLSBVgaz]);
        
		
        unsigned int corneaDiam = 0;
        
        if (0 != posHSBCRDiam && 0 != posLSBCRDiam){
            corneaDiam = (((valueBuffer[posOverflow1] & BITMASKOVERFLOWHSBCDIA) != 0 ? (valueBuffer[posHSBCRDiam] | 0x80) : valueBuffer[posHSBCRDiam]) << 8) | 
            ((valueBuffer[posOverflow1] & BITMASKOVERFLOWLSBCDIA) != 0 ? (valueBuffer[posLSBCRDiam] | 0x80) : valueBuffer[posLSBCRDiam]);
            //corneaDiam = (valueBuffer[posHSBCRDiam] << 8) | (valueBuffer[posLSBCRDiam]);
        }
        
        
        //calculate actual time for logfile
        gettimeofday(&timeval, NULL);
        actualtime = timeval.tv_sec;
        actualtm = localtime(&actualtime);
        strftime(actualtmbuf, sizeof(actualtmbuf), "%H:%M:%S", actualtm);
        snprintf(usecbuf, sizeof(usecbuf), "%s.%06d", actualtmbuf, timeval.tv_usec);
        
        // for the Logfile
        if (YES == isStarted){
            fprintf(file, "%d\t\t%s\t\t%d\t\t%d\t\t%.1f\t\t%.1f\n", (unsigned char)(valueBuffer[posStatus] & 0x7f), usecbuf, pupilDiam, corneaDiam ,0.1*(float)horizGaze, 0.1*(float)vertGaze);
        }
        
		
        //put alle the data in the mEyeTracDataMap
        
        TEyeTracParams params;
        params.pupilRec = pupilDiam == 0 ? 1 : 0; //INVERSE THE LOGIC FOR EASILY COUNTING LATER THE ONES NOT RECOGNIZED 
		params.pupilDiam = pupilDiam;
        params.horGaze = 0.1*static_cast<float>(horizGaze);
        params.verGaze = 0.1*static_cast<float>(vertGaze);
        params.corneaRec = corneaDiam  == 0 ? 1 : 0; //INVERSE THE LOGIC FOR EASILY COUNTING LATER THE ONES NOT RECOGNIZED
		params.corneaDiam = corneaDiam;
        params.status = static_cast<unsigned char>((valueBuffer[posStatus] & 0x7f));
        
        //clean the vetor if it's gettng long than the size of the window 
        
        dispatch_sync(serialQueue, ^{
            if (analyseWindowSize < eyeTracParamsVector.size()){
                eyeTracParamsVector.erase(eyeTracParamsVector.begin());
                eyeTracParamsVector.push_back(params);
            }
            else {
                eyeTracParamsVector.push_back(params);
            }
            
        });
        
        fprintf(fileAllBytes, "\n");
        
        //clean up the buffer 
		for (unsigned int i = 0; i < relevantBytes - 1; i++){
			valueBuffer[i] = 0;}
		indexBuffer = 0;
		isStarted = YES;		
	}
    if ((YES == isStarted) && (relevantBytes > indexBuffer)){
        valueBuffer[indexBuffer] = value;
        indexBuffer++;
        //for the allBytesFile
        fprintf(fileAllBytes, "%d ", value);
        
        
    }
    
}

-(std::vector<TEyeTracParams>)getLastData
{
    __block std::vector<TEyeTracParams> vectorForCalc;
    dispatch_sync(serialQueue, ^{
        vectorForCalc = eyeTracParamsVector;
    });
    return vectorForCalc;
    
}

-(NSUInteger)calcDispersionThresholdForVisualAngle:(float)angle andDistanceEyeToScreen:(float)dist andHeightScreen:(float)heightScr andResolutionHeight:(float)res
{
    NSUInteger ret = 0;
	ret =  (NSUInteger)(((tan(angle * M_PI / 180.0) * dist)*res)/heightScr + 0.5);
	NSLog(@"dispThresh: %lu", ret);
	return ret;
    
}

-(NSDictionary*)evaluateConstraintForParams:(NSDictionary*)params
{
    [params retain];
    //ATTENTION!!!!! TEST VERSION
    return nil;
    
    // evaluate target param from params dictionary
    NSArray *paramsArray = [params objectForKey:@"paramsArray"];
    if (NSNotFound == [paramsArray indexOfObject:@"eyePosIsFixated"])
    {
        NSLog(@"Eyetracker Plugin doesn't know which function to call to evaluate the constraint");
        return nil;
    }
    
    // get stimuli environment resolution to convert between eye tracker corrdinates and screen
    float resoX = 1.0;
    float resoY = 1.0;
    if (   (nil != [params objectForKey:@"screenResolutionX"]) 
        && (nil != [params objectForKey:@"screenResolutionY"]) )
    {
        resoX = [[params objectForKey:@"screenResolutionX"] floatValue];
        resoY = [[params objectForKey:@"screenResolutionY"] floatValue];
    }
    
    NSPoint midPoint = NSMakePoint(0.0, 0.0);
    if (YES == isFixationDependingOnScreenCenter)
    {
        // midpoint of the screen but in eye tracker coordinates
        midPoint.x = 0.5 * scenePOGResolutionWidth;
        midPoint.y = 0.5 * scenePOGResolutionHeight;
    }
    else 
    {
        midPoint.x = fixationDependsOnPoint.x;
        midPoint.y = fixationDependsOnPoint.y;
    }
    
    // now, ask the fixation algorithm for its answer
    NSPoint currentEyePos = NSMakePoint(0.0, 0.0);
    NSPoint convertedEyePos = NSMakePoint(0.0, 0.0);
    BOOL isFixated = [self isFixationForMidpoint:midPoint andXYDistance:maxDistanceForFixation atCurrentPos:currentEyePos];
    
    // reconvert eye tracker position data to screen position 
    convertedEyePos.x = (currentEyePos.x * resoX) / scenePOGResolutionWidth;
    convertedEyePos.y = (currentEyePos.y * resoY) / scenePOGResolutionWidth;
    
    //create dictionary to return
    //todo: just give back like that or sort in params and conditions???
    NSDictionary *dictReturn = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:convertedEyePos.x], @"eyePosX", [NSNumber numberWithFloat:convertedEyePos.y], @"eyePosY", isFixated, @"eyePosIsFixated", nil];
   
    [params release];
    return dictReturn;
}

-(BOOL)isFixationForMidpoint:(NSPoint)midPoint andXYDistance:(NSPoint)dist atCurrentPos:(NSPoint)currentEyePos
{
    std::vector<TEyeTracParams> actualData = [self getLastData];
	float minValueHG = 0;
    float maxValueHG = 0;
    float meanValueHG = 0;
    float minValueVG = 0;
    float maxValueVG = 0;
    float meanValueVG = 0;
    
    currentEyePos.x = 0.0;
    currentEyePos.y = 0.0;
	
	[self getMin:&minValueHG andMax:&maxValueHG andMean:&meanValueHG ofParam:HGAZE  fromVector:actualData];
	[self getMin:&minValueVG andMax:&maxValueVG andMean:&meanValueVG ofParam:VGAZE  fromVector:actualData];
	NSLog(@"min: %.2f max: %.2f mean: %.2f min: %.2f max: %.2f mean: %.2f", minValueHG, maxValueHG, meanValueHG,
		  minValueVG, maxValueVG, meanValueVG);
	
    
    if ((YES == [self getMin:&minValueHG andMax:&maxValueHG andMean:&meanValueHG ofParam:HGAZE  fromVector:actualData])
        && (YES == [self getMin:&minValueVG andMax:&maxValueVG andMean:&meanValueVG ofParam:VGAZE  fromVector:actualData]))
    {
        if (dispersionThreshold > (maxValueHG-minValueHG)+(maxValueVG-minValueVG)){
            if ( (abs(meanValueHG - midPoint.x) < dist.x)
                && (abs(meanValueVG- midPoint.y) < dist.y) )
            {
                // everything is fine - fixated in the correct area
				//todo: redirect output to logfile
                NSLog(@"ganz drin");
                fprintf(fileFixationsOK, "%.2f\t\t%.2f\n", meanValueHG, meanValueVG);
                currentEyePos.x = meanValueHG;
                currentEyePos.y = meanValueVG;
                return YES;
            }
            // fixated but not in valid area
			NSLog(@"bissi drin");
            fprintf(fileFixationsOut, "%.2f\t\t%.2f\n", meanValueHG, meanValueVG);
            return  NO;
        }
        // subject did not fixate
		NSLog(@"bissi draußen");
        return NO;
        
    }
    // more invalid/noisy data than allowed
    else {
		NSLog(@"ganz draußen");
        return  NO;
    }
	NSLog(@"mich gibts gar nicht");
    return  NO;
    
}


//min
-(BOOL)getMin:(float*)minValue andMax:(float*)maxValue andMean:(float*)meanValue ofParam:(PARAMS)par fromVector:(std::vector<TEyeTracParams>)eyeTracParams{
    
    *minValue = MAXFLOAT;
    *maxValue = 0;
    float_t sum = 0;
    NSUInteger nrOfValues = 0;
    NSUInteger nrOfUnrecognized = 0;
    std::vector<TEyeTracParams>::iterator it;
    switch (par) {
        case HGAZE:
            for (it = eyeTracParams.begin(); it != eyeTracParams.end(); it++){
                if ( 0 == (*it).pupilRec && 0 == (*it).corneaRec ){
                    
                    
                    float_t val = (*it).horGaze;
                    if (*minValue > val){
                        *minValue = val;
                    }
                    if (*maxValue < val){
                        *maxValue = val;
                    }
                    sum += val;
                    nrOfValues++;
                }
                else {
                    nrOfUnrecognized++;
                }
                
            }
            
            break;
        case VGAZE:
            for (it = eyeTracParams.begin(); it != eyeTracParams.end(); it++){
                if ( 0 == (*it).pupilRec && 0 == (*it).corneaRec ){
                    
                    float_t val = (*it).verGaze;
                    if (*minValue > val){
                        *minValue = val;
                    }
                    if (*maxValue < val){
                        *maxValue = val;
                    }
                    sum += val;
                    nrOfValues++;
                }
                else {
                    nrOfUnrecognized++;
                }
                
            }
            
            break;
        default:
            break;
    }
    if (nrOfValues > 0){
        *meanValue = sum/(float_t)nrOfValues;
    }
    NSLog(@"NRUnrocgnized: %lu", nrOfUnrecognized);
    if (nrOfUnrecognized > validMissingsInFixation){
        return NO;
    }
    return YES;
    
}


-(void)connectionIsOpen
{}

-(void)connectionIsClosed
{}


-(NSString*) pluginTitle
{
	return [[NSBundle mainBundle] bundleIdentifier]; 
}

-(NSString*) pluginDescription{
	return @"de.mpg.cbs.BARTSerialIOPlugin.ASLEyeTrac";
}

-(NSImage*) pluginIcon{
	return nil;
}

-(void)dealloc
{
	free(valueBuffer);
	[super dealloc];
}

-(void)closeLogFiles
{
	fclose(file);
    fclose(fileFixationsOK);
    fclose(fileFixationsOut);
    fclose(fileAllBytes);
}

@end
