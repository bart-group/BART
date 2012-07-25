//
//  BASessionTreeDescriptionCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/23/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeDescriptionCellView.h"

#import "BASessionTreeNode.h"




@implementation BASessionTreeDescriptionCellView


- (NSImage*)icon
{
    NSLog(@"[BASessionTreeDescriptionCellView] getting icon for object: %@", self.objectValue);
    
    return [(BASessionTreeNode*)self.objectValue typeIcon];
}

@end
