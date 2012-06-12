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

    if([[tableColumn identifier] compare:@"HierarchyElementDescription"] == NSOrderedSame) {
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
    }

    if([[tableColumn identifier] compare:@"HierarchyElementState"] == NSOrderedSame) {
        result.textField.stringValue = @"";
        
        NSInteger state = [(BAHierarchyElement*)[item representedObject] state];
        
        if(state == BA_ELEMENT_STATE_RUNNING) {
            result.imageView.image = [NSImage imageNamed:NSImageNameStatusAvailable];
            result.imageView.toolTip = @"State: Running";
        } else if(state == BA_ELEMENT_STATE_READY) {
            result.imageView.image = [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
            result.imageView.toolTip = @"State: Ready";
        } else if(state == BA_ELEMENT_STATE_FINISHED) {
            result.imageView.image = [NSImage imageNamed:NSImageNameMenuOnStateTemplate];
            result.imageView.toolTip = @"State: Finished";
        } else if(state == BA_ELEMENT_STATE_UNKNOWN) {
            result.imageView.image = [NSImage imageNamed:NSImageNameStatusNone];
            result.imageView.toolTip = @"State: Unknown";
        } else {
            result.imageView.image = [NSImage imageNamed:NSImageNameStatusUnavailable];
            result.imageView.toolTip = @"State: Error";
        }
        result.backgroundStyle = NSBackgroundStyleLight;
        
        // [(BAHierarchyElement*)[item representedObject] addObserver:
    }
    
    return result;
}


- (IBAction)selectTreeElement:(id)sender
{
    NSLog(@"Tree Element Selection changed: %@", [[self selectedObjects] objectAtIndex:0]);
    NSLog(@"index path [0]: %@", [[self selectionIndexPath] indexAtPosition:0]);
}


- (IBAction)openTreeWithEDL:(id)sender
{
    NSLog(@"Open Tree With EDL called by: %@", sender);

    NSURL *treeDescriptionURL = nil;
    NSURL *edlURL             = nil;
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];

    [openPanel setCanChooseFiles:TRUE];
    [openPanel setCanCreateDirectories:FALSE];
    [openPanel setAllowsMultipleSelection:FALSE];
    [openPanel setCanSelectHiddenExtension:FALSE];
    
    [openPanel setTitle:@"Select Session Tree"];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"xml", nil]];
    
    if([openPanel runModal] == NSFileHandlingPanelOKButton) {
        treeDescriptionURL = [[openPanel URLs] objectAtIndex:0];
    }


    openPanel = [NSOpenPanel openPanel];
    
    [openPanel setCanChooseFiles:TRUE];
    [openPanel setCanCreateDirectories:FALSE];
    [openPanel setAllowsMultipleSelection:FALSE];
    [openPanel setCanSelectHiddenExtension:FALSE];
    
    [openPanel setTitle:@"Select EDL"];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"edl", nil]];

    if([openPanel runModal] == NSFileHandlingPanelOKButton) {
        edlURL = [[openPanel URLs] objectAtIndex:0];
    }
    

    NSLog(@"selected tree description: %@", treeDescriptionURL);
    NSLog(@"selected edl file:         %@", edlURL);
    
    if(treeDescriptionURL != nil && edlURL != nil) {
        [[BAHierarchyTreeContext instance] loadSessionTree:[treeDescriptionURL path] withEDL:[edlURL path]];
    }
    
    [self addObject:[[BAHierarchyTreeContext instance] rootElement]];
    
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
