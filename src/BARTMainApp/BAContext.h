//
//  BAContext.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/26/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BASession2.h"
#import "BAExperiment2.h"
#import "BAStep2.h"


@interface BAContext : NSObject


+ (id)sharedBAContext;


@property (readwrite,retain) BASession2 *currentSession;






@end
