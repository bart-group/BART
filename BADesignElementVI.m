//
//  BADesignElementVI.m
//  BARTCommandLine
//
//  Created by First Last on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADesignElementVI.h"




@implementation BADesignElementVI 


-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    self = [super init];
    [self LoadDesignFromFile:path];
    return self;
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
    
    numberTimesteps = VImageNRows(mDesign);
    numberCovariates = VImageNColumns(mDesign);
    
    int itr;
    if (VGetAttr(VImageAttrList(mDesign), "repetition_time", NULL, VLongRepn,
                 &itr) != VAttrFound) {
        NSLog(@"TR info missing in header");
    }
    
    repetitionTimeInMs = itr;
    VFree(inputFilename);
    
    
    
}

-(NSNumber*)getValueFromCovariate: (int)cov atTimestep:(int)t 
{
    NSNumber *ret;
    if (IMAGE_DATA_FLOAT == imageDataType){
        ret = [NSNumber numberWithFloat:VGetPixel(mDesign, 0, t, cov)];}
    else {
        NSLog(@"Cannot identify type of design image - no float");
    }

    return ret;
}

@end
