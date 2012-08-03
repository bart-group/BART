//
//  BAExperiment2.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BAConstants.h"
#import "BASession2.h"


@interface BAExperiment2 : NSObject <NSCopying>

@property (readonly,copy)    NSString   *name;
@property (readonly,copy)    NSString   *description;
@property (readwrite,assign) NSInteger   state;

@property (readwrite,retain) NSArray    *steps;
@property (readwrite,assign) BASession2 *session;


- (id) initWithName:(NSString*)name description:(NSString*)description;
- (id) initWithName:(NSString*)name description:(NSString*)description steps:(NSArray*)steps;

+ (NSString*)displayTypeName;

@end
