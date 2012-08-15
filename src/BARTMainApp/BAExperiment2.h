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
#import "COSystemConfig.h"


@interface BAExperiment2 : NSObject <NSCopying>

@property (readonly,copy)    NSString       *name;
@property (readonly,copy)    NSString       *description;
@property (readonly,assign)  COSystemConfig *edl;
@property (readwrite,assign) NSInteger       state;

@property (readwrite,retain) NSArray    *steps;
@property (readwrite,assign) BASession2 *session;

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
+ (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description;

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString*)name;
- (id) initWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description;
- (id) initWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description steps:(NSArray*)steps;

+ (NSString*)typeDisplayName;
+ (NSString*)typeDescription;

+ (NSArray*)subclasses;

@end
