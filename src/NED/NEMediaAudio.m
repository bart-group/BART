//
//  NEMediaAudio.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEMediaAudio.h"
#import "COExperimentContext.h"


@implementation NEMediaAudio

-(id)initWithID:(NSString*)objID 
        andFile:(NSString*)path 
  constrainedBy:(NSString*)constraintID
andRegAssignment:(NERegressorAssignment*)regAssign
{
    if ((self = [super init])) {
        mID    = [objID retain];
        mConstraintID = [[constraintID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] retain];
        if ( 0 != [mConstraintID length]){
            hasConstraint = YES;}
        else{
            hasConstraint = NO;}
        
        if ( nil != regAssign){
            mRegAssignment = [regAssign retain];
            hasRegAssignment = YES;
        }
        else{
            hasRegAssignment = NO;
        }

        
        NSString* resolvedPath  = [[[COExperimentContext getInstance] systemConfig] getEDLFilePath];
        resolvedPath = [resolvedPath stringByDeletingLastPathComponent];
        NSArray* pathComponents = [[resolvedPath pathComponents] arrayByAddingObjectsFromArray:[path pathComponents]];
        resolvedPath = [NSString pathWithComponents:pathComponents];
        //TODO: error handling if file not found!
        mTrack = [[QTMovie movieWithURL:[NSURL fileURLWithPath:resolvedPath] error:nil] retain];
        mEventTypeDescription = @"Audio";
    }
    
    return self;
}

-(void)dealloc
{    
    [mID release];
    [mTrack release];
    [mConstraintID release];
    [mRegAssignment release];
    [super dealloc];
}

-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
    #pragma unused(rect)
    #pragma unused(context)
    [mTrack play];
}

-(void)pausePresentation;
{
    [mTrack stop];
}

-(void)continuePresentation
{
    [mTrack play];
}

-(void)stopPresentation
{
    [mTrack stop];
    [mTrack gotoBeginning];
}

@end
