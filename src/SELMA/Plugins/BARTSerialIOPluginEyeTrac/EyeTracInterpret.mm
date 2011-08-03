//
//  EyeTracInterpret.m
//  BARTSerialIOPluginEyeTrac
//
//  Created by Lydia Hellrung on 11/19/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "EyeTracInterpret.h"
#include <sys/time.h>
#import "math.h"
#include <vector>


@interface EyeTracInterpret (PrivateMethods)

enum PARAMS {
    PDIAM = 0,
	PREC,
    HGAZE,
    VGAZE,
    CDIAM,
	CREC,
    STATUS
};

typedef struct EyeTracParams{
    unsigned int pupilDiam;
	unsigned int pupilRec;
    float horGaze;
    float verGaze;
    unsigned int corneaDiam;
	unsigned int corneaRec;
	int status;
}TEyeTracParams;

std::vector<TEyeTracParams> eyeTracParamsVector;

size_t mWindowSize;

size_t dispersionThreshold;
size_t validMissingsInFixation;
float distanceFromMidpointToBeValid;
size_t halfScenePOGResolutionHeight;
size_t halfScenePOGResolutionWidth;
dispatch_queue_t serialQueue;

//for timing log
struct timeval timeval;
time_t actualtime;
struct tm *actualtm;
char actualtmbuf[64], usecbuf[64];


-(BOOL)isFixation;

-(size_t)calcDispersionThresholdForVisualAngle:(size_t)angle andDistanceEyeToScreen:(size_t)dist andHeightScreen:(size_t)heightScr andResolutionHeight:(size_t)res;
//-(BOOL)getMin:(int*)minValue andMax:(int*)maxValue andMean:(float_t*)meanValue ofParam:(PARAMS)par fromVector:(std::vector<TEyeTracParams>)eyeTracParams;
-(BOOL)getMin:(float_t*)minValue andMax:(float_t*)maxValue andMean:(float_t*)meanValue ofParam:(PARAMS)par fromVector:(std::vector<TEyeTracParams>)eyeTracParams;

-(std::vector<TEyeTracParams>)getLastData;


@end

@implementation EyeTracInterpret

@synthesize relevantBytes;
@synthesize byteMeanings;
@synthesize logfilePath;


-(id)init
{
	if (self = [super init])
	{//load the plugin own config file to read all the EyeTrac special configuration stuff
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
		NSDictionary *temp = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML
																			   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																						 format:&format 
																			   errorDescription:&errDescr];
		if (!temp)
		{
			NSLog(@"Error reading plist from BARTSerialIOPluginEyeTrac: %@, format: %d", errDescr, format);
		}
		self.logfilePath = [temp objectForKey:@"LogfilePath"];
		self.relevantBytes = [temp objectForKey:@"RelevantBytes"];
		NSMutableArray *tempByteMeanings = [NSMutableArray arrayWithArray:[temp objectForKey:@"ByteMeaning"]];
		
		self.byteMeanings = [NSArray arrayWithArray:tempByteMeanings];
        
		
		
		valueBuffer = (char*) malloc(sizeof(char) * [self.relevantBytes intValue]);
		indexBuffer = 0;
		isStarted = NO;
		// create an output file
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
        
        
        
        //Dispatch stuff
        serialQueue = dispatch_queue_create("de.mpg.cbs.BART.EyeTrackerSerialQueue", NULL);

		
	}
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
    
    //TODO: read from config
    size_t sampleRate = 120;
    size_t durationThreshold = 100;    
    mWindowSize = (int) ((durationThreshold/1000.0) * sampleRate);
	size_t visualAngle = 1; //# the visual angle in °
    size_t distEyeScreen = 102.5;// # in cm
    size_t heightScreen = 24;// #in cm
    size_t scenePOGResolutionHeight = 240; //# in points
    size_t scenePOGResolutionWidth = 260; //# in points
    halfScenePOGResolutionWidth = scenePOGResolutionWidth/2;
    halfScenePOGResolutionHeight = scenePOGResolutionHeight/2;
    dispersionThreshold = [self calcDispersionThresholdForVisualAngle:visualAngle andDistanceEyeToScreen:distEyeScreen andHeightScreen:heightScreen andResolutionHeight:scenePOGResolutionHeight];
    validMissingsInFixation = 3;
    distanceFromMidpointToBeValid = 50;
	
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
        
        
                    // just for TEST PURPOSE
                           // printf("status: %d \n", (unsigned char)valueBuffer[posStatus] & 0x7f);
//                    		printf("diam: %d \n", pupilDiam);
//                            printf("corneadiam: %d \n", corneaDiam);
//                    		printf("horizGaze: %.1f \n", 0.1*(float)horizGaze);
//                    		printf("vertGaze: %.1f \n", 0.1*(float)vertGaze);
//                            if ( 0 != (int)valueBuffer[posOverflow1]){
//                    			printf("overflow1: %d\n", (int)valueBuffer[posOverflow1]);
//                    		}
//                    		if ( 0 != (int)valueBuffer[posOverflow2]){
//                    			printf("overflow2: %d\n", (int)valueBuffer[posOverflow2]);
//                    		}
                    //		
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
        params.horGaze = 0.1*(float)horizGaze;
        params.verGaze = 0.1*(float)vertGaze;
        params.corneaRec = corneaDiam  == 0 ? 1 : 0; //INVERSE THE LOGIC FOR EASILY COUNTING LATER THE ONES NOT RECOGNIZED
		params.corneaDiam = corneaDiam;
        params.status = (unsigned char)(valueBuffer[posStatus] & 0x7f);
        
        //clean the vetor if it's gettng long than the size of the window 
        
        dispatch_sync(serialQueue, ^{
            if (mWindowSize < eyeTracParamsVector.size()){
                eyeTracParamsVector.erase(eyeTracParamsVector.begin());
                eyeTracParamsVector.push_back(params);
            }
            else {
                eyeTracParamsVector.push_back(params);
            }
            
        });
        
        fprintf(fileAllBytes, "\n");
        
        //clean up the buffer 
		for (unsigned int i = 0; i < [self.relevantBytes intValue] - 1; i++){
			valueBuffer[i] = 0;}
		indexBuffer = 0;
		isStarted = YES;		
	}
    if ((YES == isStarted) && ([relevantBytes intValue] > indexBuffer)){
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

-(size_t)calcDispersionThresholdForVisualAngle:(size_t)angle andDistanceEyeToScreen:(size_t)dist andHeightScreen:(size_t)heightScr andResolutionHeight:(size_t)res
{
    size_t ret = 0;
	ret =  (size_t)(((tan((float)angle * M_PI / 180.0) * (float)dist)*(float)res)/(float)heightScr + 0.5);
	NSLog(@"dispThresh: %d", ret);
	return ret;
    
}

-(BOOL)isConditionFullfilled
{
    return [self isFixation];
}

-(BOOL)isFixation
{
    std::vector<TEyeTracParams> actualData = [self getLastData];
	float_t minValueHG = 0;
    float_t maxValueHG = 0;
    float_t meanValueHG = 0;
    float_t minValueVG = 0;
    float_t maxValueVG = 0;
    float_t meanValueVG = 0;
	
	[self getMin:&minValueHG andMax:&maxValueHG andMean:&meanValueHG ofParam:HGAZE  fromVector:actualData];
	[self getMin:&minValueVG andMax:&maxValueVG andMean:&meanValueVG ofParam:VGAZE  fromVector:actualData];
	NSLog(@"min: %.2f max: %.2f mean: %.2f min: %.2f max: %.2f mean: %.2f", minValueHG, maxValueHG, meanValueHG,
		  minValueVG, maxValueVG, meanValueVG);
	//for (size_t i = 0; i < actualData.size(); i++)
//	{
//		printf("%.2f %.2f\n", actualData[i].horGaze, actualData[i].verGaze);
//	}
    
    
    if ((YES == [self getMin:&minValueHG andMax:&maxValueHG andMean:&meanValueHG ofParam:HGAZE  fromVector:actualData])
        && (YES == [self getMin:&minValueVG andMax:&maxValueVG andMean:&meanValueVG ofParam:VGAZE  fromVector:actualData]))
    {
        if (dispersionThreshold > (maxValueHG-minValueHG)+(maxValueVG-minValueVG)){
            if ( (abs(meanValueHG - halfScenePOGResolutionWidth) < distanceFromMidpointToBeValid)
                && (abs(meanValueVG- halfScenePOGResolutionHeight) < distanceFromMidpointToBeValid) )
            {
				NSLog(@"ganz drin");
                fprintf(fileFixationsOK, "%.2f\t\t%.2f\n", meanValueHG, meanValueVG);
                return YES;
            }
			NSLog(@"bissi drin");
            fprintf(fileFixationsOut, "%.2f\t\t%.2f\n", meanValueHG, meanValueVG);
            return NO;
        }
		NSLog(@"bissi draußen");
        return NO;
        
    }
    else {
		NSLog(@"ganz draußen");
        return NO;
    }
	NSLog(@"mich gibts gar nicht");
    return NO;
    
}


//min
-(BOOL)getMin:(float_t*)minValue andMax:(float_t*)maxValue andMean:(float_t*)meanValue ofParam:(PARAMS)par fromVector:(std::vector<TEyeTracParams>)eyeTracParams{
    
    *minValue = MAXFLOAT;
    *maxValue = 0;
    float_t sum = 0;
    size_t nrOfValues = 0;
    size_t nrOfUnrecognized = 0;
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
    NSLog(@"NRUnrocgnized: %d", nrOfUnrecognized);
    if (nrOfUnrecognized > validMissingsInFixation){
        return NO;
    }
    return YES;
    
}




-(NSString*) pluginTitle
{
	return [[NSBundle mainBundle] bundleIdentifier]; 
}

-(NSString*) pluginDescription{
	return @"ASLEyeTrac";
}

-(NSImage*) pluginIcon{
	return nil;
}

-(void)dealloc
{
	fclose(file);
    fclose(fileFixationsOK);
    fclose(fileFixationsOut);
    fclose(fileAllBytes);
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
