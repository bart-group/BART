//
//  BASessionTreeController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeController.h"

#import "BAContext.h"



@implementation BASessionTreeController


@synthesize treeRoots;


- (NSArray*)treeRoots
{
    return [[BAContext sharedBAContext] sessionTreeContent];
}

- (void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    BASessionTreeNode *selectedNode = [[[notification object] itemAtRow:[[notification object] selectedRow]] representedObject];
    
    NSLog(@"[BASessionTreeController outlineViewSelectionDidChange]: %@", selectedNode);
    
    [[selectedNode object] setState:random() % 6];
    
}




// for debugging purposes
- (id)arrangedObjects
{
    NSLog(@"Tree Controller.arrangedObjects method: [arrangedObjects = %@]", [super arrangedObjects]);
    return [super arrangedObjects];
}

@end
