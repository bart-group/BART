//
//  NERegressorAssignment.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/13/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef BARTNEREGRESSORASSIGNMENT_H
#define BARTNEREGRESSORASSIGNMENT_H

#import <Cocoa/Cocoa.h>
//#import "NEDesignElement.h"
#import "NEStimEvent.h"


@interface NERegressorAssignment : NSObject {
}


@property (readonly, getter = getID) NSString* mAssignmentDescription;
@property (readonly, getter = timeOffset) NSInteger mTimeOffset;
@property (readonly, getter = scaleDuration) float_t mScaleFactorDuration;
@property (readonly, getter = scaleParametric) float_t mScaleFactorParameter;
@property (readonly, getter = regID) NSString* mRegressorID;
@property (readonly, getter = trialID) NSUInteger mTrialID;

-(id)initWithFunctionID:(NSString*)funcID andRegID:(NSString*)regID;

//-(Trial)createTrialFromStimEvent:(NEStimEvent*)event;


@end

#endif //BARTNEREGRESSORASSIGNMENT_H
