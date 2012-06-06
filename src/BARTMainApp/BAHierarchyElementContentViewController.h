//
//  BAHierarchyElementContentViewController.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BAHierarchyElementContentViewController : NSViewController {

    IBOutlet NSView* emptyElementContentView;

}


- (void)treeSelectionChanged:(NSNotification*)notification;


@end

