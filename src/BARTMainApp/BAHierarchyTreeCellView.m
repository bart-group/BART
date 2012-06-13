//
//  BAHierarchyTreeCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/16/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyTreeCellView.h"

#import "BAHierarchyElement.h"


@implementation BAHierarchyTreeCellView

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (NSImage*)imageForElementType
{
    
}


- (NSImage*)imageForElementState
{
    NSInteger state = [(BAHierarchyElement*)[self objectValue] state];
    
    if(state == BA_ELEMENT_STATE_RUNNING) {
        return [NSImage imageNamed:NSImageNameStatusAvailable];
    } else if(state == BA_ELEMENT_STATE_READY) {
        return [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
    } else if(state == BA_ELEMENT_STATE_FINISHED) {
        return [NSImage imageNamed:NSImageNameMenuOnStateTemplate];
    } else if(state == BA_ELEMENT_STATE_UNKNOWN) {
        return [NSImage imageNamed:NSImageNameStatusNone];
    } else {
        return [NSImage imageNamed:NSImageNameStatusUnavailable];
    }

}


@end
