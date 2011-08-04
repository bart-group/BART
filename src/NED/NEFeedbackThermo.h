//
//  NEFeedbackThermometer.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/17/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEFeedbackObject.h"


@class NEThermoWindowController;


/**
 * A simple feedback system showing a temperature color gradient
 * based on a "temperature" input.
 * The parameters minTemperature and maxTemperature should be non-negative.
 */
@interface NEFeedbackThermo : NEFeedbackObject {
    
    NEThermoWindowController* thermoWindowController;
    
    CGFloat temperature;
    CGFloat minTemperature;
    CGFloat maxTemperature;

}

@end
