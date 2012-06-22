//
//  BASession2.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BAConstants.h"


@interface BASession2 : NSObject


@property (readonly,copy)    NSString* name;
@property (readonly,copy)    NSString* description;
@property (readwrite,assign) NSInteger state;

@end
