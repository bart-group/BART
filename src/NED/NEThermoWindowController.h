//
//  NEThermoWindowController.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/17/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class NEFeedbackObject;


/**
 * Window controller managing the ThermoControl window which
 * provides dummy input for the thermometer feedback system.
 */
@interface NEThermoWindowController : NSWindowController {
    
    NEFeedbackObject* feedbackObject;
    
    IBOutlet NSSlider* temperatureSlider;
    
}

@property (assign) NEFeedbackObject* feedbackObject;

-(IBAction)sliderChanged:(id)sender;

@end
