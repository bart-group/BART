//
//  BAGUIProtoCGLayer.h
//  BARTApplication
//
//  Created by First Last on 12/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADataElement.h"


@interface BAGUIProtoCGLayer : NSObject {
    NSWindow* applicationWindow;
	
	CGLayerRef backgroundLayer;
    CGLayerRef foregroundLayer;
}

- (id)initWithWindow:(NSWindow*)window;

/**
 * Initializes the CGLayer objects and obtains their contexts.
 */
- (void)initLayers;

/**
 * Displays all layers and image objects (already converted BADataElement objects).
 */
- (void)doPaint;

/**
 * Converts, retains and displays a BADataElement in the background layer 
 * (usually used for anatomy data).
 */
- (void)setBackgroundImage:(BADataElement*)newBackgroundImage;

/**
 * Converts, retains and displays a BADataElement in the background layer 
 * (usually used for functional/activation data).
 */
- (void)setForegroundImage:(BADataElement*)newForegroundImage;

+ (BAGUIProtoCGLayer*)getGUI;

@property (readonly) IBOutlet NSWindow* applicationWindow;

@end
