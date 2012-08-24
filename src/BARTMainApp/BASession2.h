//
//  BASession2.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BAConstants.h"
#import "BASessionTreeNode.h"


@interface BASession2 : BASessionTreeNode <NSCopying>


@property (readwrite,retain) NSArray   *experiments;


- (id) initWithName:(NSString*)name description:(NSString*)description;
- (id) initWithName:(NSString*)name description:(NSString*)description experiments:(NSArray*)experiments;

+ (NSString*)displayTypeName;

@end
