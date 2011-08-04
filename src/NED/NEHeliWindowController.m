//
//  NEHeliWindowController.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEHeliWindowController.h"
#import "NEFeedbackObject.h"


@implementation NEHeliWindowController

@synthesize feedbackObject;

-(IBAction)sliderChanged:(id)sender
{
    if (feedbackObject) {
        if (sender == heightSlider) {
            NSDictionary* parameters = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%.1f", [heightSlider floatValue]] 
                                                                   forKey:@"height"];
            [feedbackObject setParameters:parameters];
        } else if (sender == firerateSlider) {
            NSDictionary* parameters = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%.1f", [firerateSlider floatValue]] 
                                                                   forKey:@"firerate"];
            [feedbackObject setParameters:parameters];
        }
    }
}

@end
