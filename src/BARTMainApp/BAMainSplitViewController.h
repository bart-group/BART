//
//  BAMainSplitViewController.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BAMainSplitViewController : NSViewController <NSSplitViewDelegate> {

    
    IBOutlet NSView *currentElementConfigView;
    IBOutlet NSView *CurrentElementRunView;

}


- (void)treeSelectionChanged:(NSNotification*)notification;


@end

