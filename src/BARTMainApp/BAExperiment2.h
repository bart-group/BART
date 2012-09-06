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
#import "BASessionTreeNode.h"
#import "COSystemConfig.h"


@interface BAExperiment2 : BASessionTreeNode <NSCopying>

@property (readonly,assign)  COSystemConfig *edl;

@property (readonly,retain)  NSArray        *steps;
@property (readwrite,assign) BASession2     *session;

// this is the method to overwrite in the specific experiment implementation to
// kick-off all the necessary creation/configuration etc. of steps and other stuff
// But remember: always call super ;-)
//
// Example:
//
// + (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description
// {
//     self = [super experimentWithEDL:edl name:name description:description];
//     
//     if(self) {
//         NSLog(@"Doing initialization ...");
//     }
//     
//     return self;
// }
//
+ (id)experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description;

- (id)initWithEDL:(COSystemConfig*)edl name:(NSString*)name;
- (id)initWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description;
- (id)initWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description steps:(NSArray*)steps;

- (void)appendStep:(id)step;

- (void)addObjectToGlobalTable:(id)object name:(NSString*)name;
- (id)objectFromGlobalTable:(NSString*)name;



+ (NSString*)typeDisplayName;
+ (NSString*)typeDescription;

+ (NSArray*)subclasses;

@end
