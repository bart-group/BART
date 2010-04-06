//
//  BADesignElementVI.m
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 11/11/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementVI.h"




@implementation NEDesignElementVI 


-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    if (self = [super init]) {
        [self LoadDesignFromFile:path];
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadDesignFromFile:(NSString*)path
{
    
    char* inputFilename = VMalloc(sizeof(char) *UINT16_MAX);
    [path getCString:inputFilename maxLength:UINT16_MAX  encoding:NSUTF8StringEncoding];
    printf("Name of design file %s \n", inputFilename);
    
            
    /*
     * read m_DesignImage matrix
     */
    //mDesign = (VImage *)VMalloc(sizeof(VImage)*1);
    FILE* fp = VOpenInputFile(inputFilename, TRUE);
    VAttrList list1 = VReadFile(fp, NULL);
    if (!list1) {
        VError("Error reading m_DesignImage file");
    }
    fclose(fp);
    
    int n = 0;
    VAttrListPosn posn;
    for (VFirstAttr(list1, &posn); VAttrExists(&posn); VNextAttr(&posn)) {
        if (VGetAttrRepn(&posn) == VImageRepn) {
            VGetAttrValue(&posn, NULL, VImageRepn, &mDesign);
            
            if (VPixelRepn(mDesign) == VFloatRepn) {
                n++;
                break;
            }
        }
    }
    if (n == 0) {
        VError(" m_DesignImage matrix not found ");
    }
    
    mNumberTimesteps = VImageNRows(mDesign);
    mNumberExplanatoryVariables = VImageNColumns(mDesign);
	NSLog(@"numberExplanatoryVariables %d", mNumberExplanatoryVariables);
    
    int itr;
    if (VGetAttr(VImageAttrList(mDesign), "repetition_time", NULL, VLongRepn, &itr) 
            != VAttrFound) {
        NSLog(@"TR info missing in header");
    }
    
    mRepetitionTimeInMs = itr;
    VFree(inputFilename);
}

-(NSNumber*)getValueFromExplanatoryVariable: (unsigned int)cov atTimestep:(unsigned int)t 
{
    NSNumber *ret;
    if (IMAGE_DATA_FLOAT == mImageDataType){
        ret = [NSNumber numberWithFloat:VGetPixel(mDesign, 0, t, cov)];
    } else {
        NSLog(@"Cannot identify type of design image - no float");
    }

    return ret;
}

@end
