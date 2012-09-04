//
//  NEHeliWindowController.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef BARTNEHELIWINDOWCONTROLLER_H
#define BARTNEHELIWINDOWCONTROLLER_H

#import <Cocoa/Cocoa.h>


@class NEFeedbackObject;


/**
 * Window controller managing the HeliControl window which
 * provides dummy input for the helicopter feedback system.
 */
@interface NEHeliWindowController : NSWindowController {
    
    NEFeedbackObject* feedbackObject;
    
    IBOutlet NSSlider* heightSlider;
    IBOutlet NSSlider* firerateSlider;

}

@property (assign) NEFeedbackObject* feedbackObject;

-(IBAction)sliderChanged:(id)sender;

@end

#endif //BARTNEHELIWINDOWCONTROLLER_H