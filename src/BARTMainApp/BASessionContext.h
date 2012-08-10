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


@interface BASessionContext : NSObject


@property (readonly,getter = sharedBAContext) BASessionContext *instance;


@property (readwrite,retain) BASession2        *currentSession;
@property (readonly)         NSArray           *sessionTreeContent;
@property (readonly)         NSArray           *registeredExperimentTypes;


+ (BASessionContext*)sharedBASessionContext;

- (IBAction)addExperiment:(id)sender;



- (void)createExampleSession;


@end
