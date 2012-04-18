//
//  NEMediaImage.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NEMediaImage.h"
#import "COExperimentContext.h"


@implementation NEMediaImage

float mImageWidthHalf;
float mImageHeightHalf;

-(id)initWithID:(NSString*)objID
           file:(NSString*)path
      displayAt:(NSPoint)position
  constrainedBy:(NSString *)constraintID
{
    if ((self = [super init])) {
        mID       = [objID retain];
        mConstraintID = [[constraintID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] retain];
        if ( 0 != [mConstraintID length]){
            hasConstraint = YES;}
        else{
            hasConstraint = NO;}
        
        NSString* resolvedPath  = [[[COExperimentContext getInstance] systemConfig] getEDLFilePath];
        resolvedPath = [resolvedPath stringByDeletingLastPathComponent];
        NSArray* pathComponents = [[resolvedPath pathComponents] arrayByAddingObjectsFromArray:[path pathComponents]];
        resolvedPath = [NSString pathWithComponents:pathComponents];
        //TODO: error handling if file not found!
        //mImage    = [[CIImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resolvedPath]];
        
        /*********/
        // Scale Factor !!
        // temp formatter to convert from string to number
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        float screenResolutionX = (float) [[f numberFromString:[[[COExperimentContext getInstance] systemConfig] getProp:@"$screenResolutionX"]] unsignedLongValue];
        [f release];
        
        CIImage *im    = [[CIImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resolvedPath]];
        float scale = screenResolutionX / (float)[im extent].size.width;
        // Resize the image
        CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [scaleFilter setValue:im forKey:@"inputImage"];
        [scaleFilter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
        [scaleFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputAspectRatio"];
        mImage = [[scaleFilter valueForKey:@"outputImage"] retain];
        
        mImageWidthHalf = [mImage extent].size.width/2;
        mImageHeightHalf = [mImage extent].size.height/2;
        
        /******/
        mPosition = position;
        [im release];
    }
    mEventTypeDescription = @"Image";
    return self;
}

-(void)dealloc
{
    [mID release];
    [mImage release];
    [mConstraintID release];
    
    [super dealloc];
}

-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
    //center the image to the position that is given
	//NSPoint pos;
	//pos.x = mPosition.x - mImageWidthHalf;
	//pos.y = mPosition.y - mImageHeightHalf;
    
    CIContext* ciContext = [CIContext contextWithCGContext:context options:nil];
    [ciContext  drawImage:mImage
                  atPoint:mPosition
                 fromRect:rect];
}

@end
