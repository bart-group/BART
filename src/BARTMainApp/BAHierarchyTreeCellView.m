//
//  BAHierarchyTreeCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/16/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyTreeCellView.h"

@implementation BAHierarchyTreeCellView

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouseDown: %@", theEvent);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"mouseUp: %@", theEvent);
}


@end
