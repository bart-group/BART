//
//  BAContext.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/26/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BASessionTreeNode.h"

#import "BASession2.h"
#import "BAExperiment2.h"
#import "BAStep2.h"


@interface BAContext : NSObject


@property (readonly,getter = sharedBAContext) BAContext *instance;


@property (readwrite,retain) BASession2        *currentSession;
@property (readonly)         NSArray           *sessionTreeContent;
@property (readonly)         NSArray           *registeredExperimentTypes;


+ (BAContext*)sharedBAContext;

- (IBAction)addExperiment:(id)sender;



- (void)createExampleSession;


@end
