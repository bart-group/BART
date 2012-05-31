//
//  BAHierarchyElement.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/14/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BAHierarchyElement : NSObject 


@property (readonly) NSString *uuid;
@property (readonly) NSString *name;
@property (readonly) NSString *comment;

@property (readonly) NSInteger state;

@property (readonly) NSMutableDictionary *properties;

@property (copy) BAHierarchyElement  *parent;
@property (readonly) NSMutableArray  *children;


extern NSString * const BA_ELEMENT_PROPERTY_NAME;
extern NSString * const BA_ELEMENT_PROPERTY_COMMENT;
extern NSString * const BA_ELEMENT_PROPERTY_STATE;
extern NSString * const BA_ELEMENT_PROPERTY_UUID;

extern NSInteger  const BA_ELEMENT_STATE_UNKNOWN;
extern NSInteger  const BA_ELEMENT_STATE_ERROR;
extern NSInteger  const BA_ELEMENT_STATE_NOT_CONFIGURED;
extern NSInteger  const BA_ELEMENT_STATE_READY;
extern NSInteger  const BA_ELEMENT_STATE_RUNNING;
extern NSInteger  const BA_ELEMENT_STATE_FINISHED;


-(id)init;
-(id)initWithName: (NSString*)name;
-(id)initWithNameAndComment: (NSString*)name comment: (NSString*)comment;

-(BOOL)isRoot;
-(BOOL)isLeaf;

-(NSString*)description;


@end

