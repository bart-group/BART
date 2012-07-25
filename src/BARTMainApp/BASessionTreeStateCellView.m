//
//  BASessionTreeStateCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/25/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeStateCellView.h"
#import "BASessionTreeNode.h"


@implementation BASessionTreeStateCellView


- (BOOL)acceptsFirstResponder
{
    return YES;
}



- (void)mouseDown:(NSEvent*)theEvent
{
    NSLog(@"[BASessionTreeStateCellView performClick]: %@", theEvent);
}

@end
