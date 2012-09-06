//
//  BAHierarchyTreeDescriptionCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/16/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyTreeDescriptionCellView.h"

#import "BAHierarchyElement.h"
#import "BASession.h"
#import "BAExperiment.h"
#import "BAStep.h"


@implementation BAHierarchyTreeDescriptionCellView


@synthesize icon;

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (NSImage*)icon
{
    NSLog(@"getting icon for object: %@", self.objectValue);
    Class elementClass = [[self objectValue] class];
    if([elementClass isSubclassOfClass:[BASession class]]) {
        return [NSImage imageNamed:@"Hierarchy Element Icon Session.png"];
    } else if([elementClass isSubclassOfClass:[BAExperiment class]]) {
        return [NSImage imageNamed:@"Hierarchy Element Icon Experiment.png"];
    } else if([elementClass isSubclassOfClass:[BAStep class]]) {
        return [NSImage imageNamed:@"Hierarchy Element Icon Step.png"];
    } else {
        return [NSImage imageNamed:@"Hierarchy Element Icon Unknown.png"];
    }
    
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
