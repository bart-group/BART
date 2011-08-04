//
//  NEThermoWindowController.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/17/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEThermoWindowController.h"
#import "NEFeedbackObject.h"


@implementation NEThermoWindowController

@synthesize feedbackObject;

-(IBAction)sliderChanged:(id)sender
{
    if (feedbackObject) {
        NSDictionary* parameters = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%.1f", [temperatureSlider floatValue]] 
                                                               forKey:@"temperature"];
        [feedbackObject setParameters:parameters];
    }
}

@end
