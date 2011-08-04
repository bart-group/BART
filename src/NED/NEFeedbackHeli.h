//
//  NEFeedbackHeli.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEFeedbackObject.h"


@class NEHeliWindowController;


/**
 * A simple feedback system showing a "helicopter" at a certain height.
 * Also the helicopter is able to shoot at different rates.
 */
@interface NEFeedbackHeli : NEFeedbackObject {
    
    NEHeliWindowController* heliWindowController;
    
    CGFloat height;
    CGFloat minHeight;
    CGFloat maxHeight;
    
    CGFloat firerate;
    CGFloat minFirerate;
    CGFloat maxFirerate;
    
    NSMutableArray* bullets;
    int bulletCooldown;

}

@end
