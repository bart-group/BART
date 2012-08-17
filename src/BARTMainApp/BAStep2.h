//
//  BAStep2.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BAConstants.h"
#import "BAExperiment2.h"


@interface BAStep2 : NSObject <NSCopying>

@property (readonly,copy)    NSString  *name;
@property (readonly,copy)    NSString  *description;
@property (readwrite,assign) NSInteger  state;

@property (readwrite,assign) BAExperiment2 *experiment;

- (id) initWithName:(NSString*)name description:(NSString*)description;

+ (NSString*)typeDisplayName;
+ (NSString*)typeDescription;

@end
