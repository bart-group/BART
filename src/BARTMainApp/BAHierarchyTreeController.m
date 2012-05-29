//
//  BAHierarchyTreeController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyTreeController.h"


@implementation BAHierarchyTreeController

- (NSView*)outlineView:(NSOutlineView *)outlineView
    viewForTableColumn:(NSTableColumn *)tableColumn
                  item:(id)item
{
    NSLog(@"outlineView:%@ viewForTableColumn:%@ item:%@", outlineView, tableColumn, item);
    
    
    NSTableCellView *result = nil;
    
    result = [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    result.textField.stringValue = [(BAHierarchyElement*)[item representedObject] name];
    result.imageView.image = nil;

    result.backgroundStyle = NSBackgroundStyleLight;
    
    return result;
}

@end
