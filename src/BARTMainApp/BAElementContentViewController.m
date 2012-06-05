//
//  BAElementContentViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAElementContentViewController.h"

#import "BARTNotifications.h"

#import "BASession.h"
#import "BAExperiment.h"
#import "BAStep.h"
#import "BAHierarchyTreeContext.h"
#import "BAHierarchyElementViewController.h"



@interface BAElementContentViewController ()

@end

@implementation BAElementContentViewController

- (void)setView:(NSView *)view
{
    [super setView:view];
    
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
        NSLog(@"BAElementContentViewController received notification: %@", notification);
        NSLog(@"new selected element: %@", [[[BAHierarchyTreeContext instance] selectedElement] description]);

        // view handling/selection/activation etc. based on hierarchy tree selection starts right here !!!
        BAHierarchyElement *selectedElement = [[BAHierarchyTreeContext instance] selectedElement];

        NSString *elementConfigUI = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_CONFIGURATION_UI];
        NSString *elementExecUI   = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_EXECUTION_UI];
        
        if(elementConfigUI != nil) {
            BAHierarchyElementViewController *configViewController = [(BAHierarchyElementViewController*)[[[NSBundle mainBundle] classNamed:[elementConfigUI stringByAppendingString:@"Controller"]] alloc] initWithNibName:elementConfigUI bundle:nil];
            NSLog(@"Created View Controller Instance: %@", configViewController);
            
            // [configViewController initWithNibName:elementConfigUI bundle:nil];
            
            NSLog(@"configViewController.view: %@", [configViewController view]);
            // NSLog(@"splitViewController.view: %@", [self view]);
            
            // [self.view addSubview:configViewController.view];

            [[(NSTabView*)[self view] tabViewItemAtIndex:0] setView:[configViewController view]];
            [(NSTabView*)[self view] selectTabViewItemAtIndex:0];
            
        }
        
        
    }
    
}


//- (void)splitViewDidResizeSubviews:(NSNotification *)notification
//{
//    NSLog(@"%@", notification);
//}

@end
