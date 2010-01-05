//
//  BADesignElement.m
//  BARTCommandLine
//
//  Created by First Last on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADesignElement.h"
#import "BADesignElementVI.h"


@implementation BADesignElement

@synthesize repetitionTimeInMs;
@synthesize numberCovariates;
@synthesize numberTimesteps;
@synthesize imageDataType;

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    self = [super init];
    //TODO!!!!!!!
    return [[BADesignElementVI alloc] initWithFile:path ofImageDataType:type];
}

@end





