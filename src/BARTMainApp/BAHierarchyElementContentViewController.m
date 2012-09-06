//
//  BAHierarchyElementContentViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyElementContentViewController.h"

#import "BARTNotifications.h"

#import "BASession.h"
#import "BAExperiment.h"
#import "BAStep.h"
#import "BAHierarchyTreeContext.h"
#import "BAHierarchyElementViewController.h"



@interface BAHierarchyElementContentViewController ()

@end




@implementation BAHierarchyElementContentViewController

- (void)setView:(NSView *)view
{
    [super setView:view];
    
    NSLog(@"setView: %@", view);
    
    // top level initialization stuff
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(treeSelectionChanged:)
                                                 name:BARTHierarchyTreeContextSelectedElementChangedNotification
                                               object:nil];

    [NSBundle loadNibNamed:@"BAEmptyElementView" owner:self];
}



- (void)treeSelectionChanged:(NSNotification*)notification
{
    if([notification name] == BARTHierarchyTreeContextSelectedElementChangedNotification) {
        NSLog(@"BAElementContentViewController received notification: %@", notification);
        NSLog(@"new selected element: %@", [[[BAHierarchyTreeContext instance] selectedElement] description]);

        // view handling/selection/activation etc. based on hierarchy tree selection starts right here !!!
        BAHierarchyElement *selectedElement = [[BAHierarchyTreeContext instance] selectedElement];

        if(selectedElement == nil) {
            [[((NSTabView*)[self view]) tabViewItemAtIndex:0] setView:emptyElementContentView];
            return;
        }
        
        BAHierarchyElementViewController *configViewController = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_CONFIGURATION_UI_CONTROLLER];
            
        if(configViewController == nil) {
            NSString *elementConfigUI = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_CONFIGURATION_UI_NAME];
            
            if(elementConfigUI != nil) {
                configViewController = [(BAHierarchyElementViewController*)[[[NSBundle mainBundle] classNamed:[elementConfigUI stringByAppendingString:@"Controller"]] alloc] initWithNibName:elementConfigUI bundle:nil];
                NSLog(@"Created View Controller Instance: %@", configViewController);
                
                // [configViewController initWithNibName:elementConfigUI bundle:nil];
                
                NSLog(@"configViewController.view: %@", [configViewController view]);
                // NSLog(@"splitViewController.view: %@", [self view]);
                
                // [self.view addSubview:configViewController.view];
                
                [(NSTabView*)[self view] selectTabViewItemAtIndex:0];
                
            } else {
                configViewController = [[BAHierarchyElementViewController alloc] init];
                [configViewController setView:emptyElementContentView];
            }

            [[selectedElement properties] setValue:configViewController forKey:BA_ELEMENT_PROPERTY_CONFIGURATION_UI_CONTROLLER];
        }
 

        BAHierarchyElementViewController *execViewController = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_EXECUTION_UI_CONTROLLER];

        if(execViewController == nil) {
            NSString *elementExecUI   = [[selectedElement properties] valueForKey:BA_ELEMENT_PROPERTY_EXECUTION_UI_NAME];
            
            if(elementExecUI != nil) {
                execViewController = [[BAHierarchyElementViewController alloc] init];
                [execViewController setView:emptyElementContentView];
            } else {
                execViewController = [[BAHierarchyElementViewController alloc] init];
                [execViewController setView:emptyElementContentView];
            }

            [[selectedElement properties] setValue:execViewController forKey:BA_ELEMENT_PROPERTY_EXECUTION_UI_CONTROLLER];
        }

        [[(NSTabView*)[self view] tabViewItemAtIndex:0] setView:[configViewController view]];
        [[(NSTabView*)[self view] tabViewItemAtIndex:1] setView:[execViewController view]];
        
    }
    
}


//- (void)splitViewDidResizeSubviews:(NSNotification *)notification
//{
//    NSLog(@"%@", notification);
//}

@end
