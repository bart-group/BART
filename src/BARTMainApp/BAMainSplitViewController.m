//
//  BAMainSplitViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAMainSplitViewController.h"

#import "BARTNotifications.h"

#import "BASession.h"
#import "BAExperiment.h"
#import "BAStep.h"
#import "BAHierarchyTreeContext.h"



@interface BAMainSplitViewController ()

@end

@implementation BAMainSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here
    }
    
    return self;
}

- (void)setView:(NSView *)view
{
    NSLog(@"setView: %@", view);
    
    // top level initialization stuff
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(treeSelectionChanged:)
                                                 name:BARTHierarchyTreeContextSelectedElementChangedNotification
                                               object:nil];
}



- (void)treeSelectionChanged:(NSNotification*)notification
{
    if([notification name] == BARTHierarchyTreeContextSelectedElementChangedNotification) {
        NSLog(@"BAMainSplitViewController received notification: %@", notification);
        NSLog(@"new selected element: %@", [[[BAHierarchyTreeContext instance] selectedElement] description]);

        // view handling/selection/activation etc. based on hierarchy tree selection starts right here !!!
        BAHierarchyElement *selectedElement = [[BAHierarchyTreeContext instance] selectedElement];

        NSString *elementConfigUINibName = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_CONFIGURATION_UI];
        NSString *elementExecUINibName   = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_EXECUTION_UI];
        

        if(elementConfigUINibName != nil) {
            [NSBundle loadNibNamed:elementConfigUINibName owner:self];
        }
    }
    
}


//- (void)splitViewDidResizeSubviews:(NSNotification *)notification
//{
//    NSLog(@"%@", notification);
//}

@end
