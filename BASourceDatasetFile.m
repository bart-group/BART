//
//  BASourceDatasetFile.m
//  BARTCommandLine
//
//  Created by First Last on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BASource.h"
#import "BADataElement.h"
#import "BADesignElement.h"

#import "BASourceDatasetFile.h"

@implementation BASourceDatasetFile 


-(id) initWithDatasetFile:(NSString*) file ofImageType:(enum ImageType)type
{
    self = [super init];
    
    if (self) {
        
        if (IMAGE_DESIGN == type) {
            mElement = [[BADesignElement alloc] initWithDatasetFile:file ofImageDataType:IMAGE_DATA_FLOAT];
        }
        if (IMAGE_FCTDATA == type) {
            mElement = [[BADataElement alloc] initWithDatasetFile:file ofImageDataType:IMAGE_DATA_SHORT];
        }
    
    }
    
    return self;
}

-(void)loadFromSource
{
    
    // load the whole image data from File
}

/**
 * Has to be called by DataControl to inform about newly arrived data.
 */
-(void)newDataArrived
{
    // handle the data to put it into DataElement and send info to the necessary elements
}

@end