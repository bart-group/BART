//
//  BARTApplicationAppDelegate.h
//  BARTApplication
//
//  Created by First Last on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BAGUIProtoCGLayer.h"

@interface BARTApplicationAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet BAGUIProtoCGLayer* guiController;
    
}

@end
