//
//  BARTApplicationAppDelegate.h
//  BARTApplication
//
//  Created by First Last on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADataElement.h"
#import "BADesignElement.h"
#import "BAAnalyzerElement.h"
#import "BAGUIProtoCGLayer.h"
#import "BAProcedureController.h"

@interface BARTApplicationAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    
    BAGUIProtoCGLayer *gui;
    
    BAProcedureController* procedureController;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet BAGUIProtoCGLayer *gui;

@end
