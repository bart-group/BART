//
//  BAExampleStepConfigViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/5/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAExampleStepConfigViewController.h"

#import "BAHierarchyTreeContext.h"



@interface BAExampleStepConfigViewController ()

@end

@implementation BAExampleStepConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"BAExampleStepConfigViewController: inside initWithNibName: %@", nibNameOrNil);
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}


-(IBAction)button1clicked:(id)sender
{
    NSLog(@"selected element: %@", [[BAHierarchyTreeContext instance] selectedElement]);
//    [[[BAHierarchyTreeContext instance] selectedElement] setState:BA_ELEMENT_STATE_RUNNING];
    [[[BAHierarchyTreeContext instance] selectedElement] setState:(random() % 6)];
}

@end
