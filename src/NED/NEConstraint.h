//
//  NEConstraint.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 2/28/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NEConstraint : NSObject{
    
    NSString* constraintID;
    BOOL      isActive;
    NSArray* systemVariables;
    NSArray* constraintConditions;
    NSArray* constraintActionsThen;
    NSArray* constraintActionsElse;
    
}

//@property (readwrite, getter = position, setter = setPosition:) NSPoint mPosition;
@property (readonly, getter = isActive) BOOL isActive;
@property (readonly, getter = constraintID) NSString* constraintID;
@property (readonly, getter = variables) NSArray* systemVariables;
@property (readonly, getter = conditions) NSArray* constraintConditions;
@property (readonly, getter = actionsThen) NSArray* constraintActionsThen;
@property (readonly, getter = actionsElse) NSArray* constraintActionsElse;
    
-(id)init;
-(id)initWithConfigEntry:(NSString*)key;


@end
