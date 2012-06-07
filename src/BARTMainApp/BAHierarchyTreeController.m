//
//  BAHierarchyTreeController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyTreeController.h"

#import "BASession.h"
#import "BAExperiment.h"
#import "BAStep.h"
#import "BAHierarchyTreeContext.h"



@implementation BAHierarchyTreeController

- (NSView*)outlineView:(NSOutlineView *)outlineView
    viewForTableColumn:(NSTableColumn *)tableColumn
                  item:(id)item
{
    NSLog(@"outlineView:%@ viewForTableColumn:%@ item:%@", outlineView, tableColumn, item);
    
    
    NSTableCellView *result = nil;
    
    result = [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    result.textField.stringValue = [(BAHierarchyElement*)[item representedObject] name];

    Class elementClass = [(BAHierarchyElement*)[item representedObject] class];
    NSString *elementType;
    if([elementClass isSubclassOfClass:[BASession class]]) {
        elementType = NSStringFromClass([BASession class]);
    } else if([elementClass isSubclassOfClass:[BAExperiment class]]) {
        elementType = NSStringFromClass([BAExperiment class]);
    } else if([elementClass isSubclassOfClass:[BAStep class]]) {
        elementType = NSStringFromClass([BAStep class]);

    } else {
        elementType = @"Unknown";
    }
    
    result.imageView.image = [NSImage imageNamed:[elementIconNames valueForKey:elementType]];
    
    result.backgroundStyle = NSBackgroundStyleLight;
    
    return result;
}


- (IBAction)selectTreeElement:(id)sender
{
    NSLog(@"Tree Element Selection changed: %@", [[self selectedObjects] objectAtIndex:0]);
    NSLog(@"index path [0]: %@", [[self selectionIndexPath] indexAtPosition:0]);
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"outlineViewSelectionDidChange: %@", notification);
    NSLog(@"selected item: %@", [[[[notification object] itemAtRow:[[notification object] selectedRow]] representedObject] description]);
    
    [[BAHierarchyTreeContext instance] setSelectedElement:[[[notification object] itemAtRow:[[notification object] selectedRow]] representedObject]];
}



+ (void)initialize
{
    NSLog(@"+ (void)initialize");
    elementIconNames = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"Hierarchy Element Icon Session.png",    NSStringFromClass([BASession class]),
                        @"Hierarchy Element Icon Experiment.png", NSStringFromClass([BAExperiment class]),
                        @"Hierarchy Element Icon Step.png",       NSStringFromClass([BAStep class]),
                        @"Hierarchy Element Icon Unknown.png",    @"Unknown",
                        nil];
}

@end
