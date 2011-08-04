//
//  NEMediaImage.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NEMediaImage.h"
#import "COSystemConfig.h"


@implementation NEMediaImage

-(id)initWithID:(NSString*)objID
           file:(NSString*)path
      displayAt:(NSPoint)position
{
    if (self = [super init]) {
        mID       = [objID retain];
        
        NSString* resolvedPath  = [[COSystemConfig getInstance] getEDLFilePath];
        resolvedPath = [resolvedPath stringByDeletingLastPathComponent];
        NSArray* pathComponents = [[resolvedPath pathComponents] arrayByAddingObjectsFromArray:[path pathComponents]];
        resolvedPath = [NSString pathWithComponents:pathComponents];
        //TODO: error handling if file not found!
        mImage    = [[CIImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resolvedPath]];
        mPosition = position;
    }
    
    return self;
}

-(void)dealloc
{
    [mID release];
    [mImage release];
    
    [super dealloc];
}

-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
    CIContext* ciContext = [CIContext contextWithCGContext:context options:nil];
    [ciContext  drawImage:mImage
                  atPoint:mPosition
                 fromRect:rect];
}

@end
