//
//  BARTApplicationAppDelegate.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/12/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BAGUIProtoCGLayer.h"

@class BAProcedurePipeline;

@interface BARTApplicationAppDelegate : NSObject <NSApplicationDelegate> {
    
    IBOutlet BAGUIProtoCGLayer* guiController;
    BAProcedurePipeline *procedurePipe;
    
}

@end
