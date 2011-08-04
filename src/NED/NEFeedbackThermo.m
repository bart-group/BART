//
//  NEFeedbackThermometer.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/17/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEFeedbackThermo.h"
#import "NEThermoWindowController.h"


@implementation NEFeedbackThermo

-(id)initWithFrame:(NSRect)frame
     andParameters:(NSDictionary*)params 
{
    if (self = [super initWithFrame:frame andParameters:params]) {
        
        if ([parameters valueForKey:@"temperature"]) {
            temperature = [[parameters valueForKey:@"temperature"] floatValue];
        } else {
            temperature = 10.0;
        }
        if ([parameters valueForKey:@"minTemperature"]) {
            minTemperature = [[parameters valueForKey:@"minTemperature"] floatValue];
        } else {
            minTemperature = 0.0;
        }
        if ([parameters valueForKey:@"maxTemperature"]) {
            maxTemperature = [[parameters valueForKey:@"maxTemperature"] floatValue];
        } else {
            maxTemperature = 50.0;
        }
        
        thermoWindowController = [[NEThermoWindowController alloc] initWithWindowNibName:@"ThermoControl"];
        [[thermoWindowController window] setStyleMask:(NSTitledWindowMask
                                                     | NSMiniaturizableWindowMask
                                                     | NSResizableWindowMask)];
        [[thermoWindowController window] setMovableByWindowBackground:YES];
        [thermoWindowController setFeedbackObject:self];
        [thermoWindowController showWindow:nil];

    }
    
    return self;
}

-(void)tick
{
    if ([parameters valueForKey:@"temperature"]) {
        temperature = [[parameters valueForKey:@"temperature"] floatValue];
    }
}

-(void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    // Temperature between 0.0 and 1.0 (where 0.0 is minTemperature and 1.0 is maxTemperature).
    CGFloat normalizedTemperature = (temperature - minTemperature) / (maxTemperature - minTemperature);
    
    // Construct an draw the temperature color gradient.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat gradientColors[] = {
        000.0, 000.0, 255.0, 1.0, // White.
        000.0, 255.0, 000.0, 1.0, // Green.
        255.0, 255.0, 000.0, 1.0, // Yellow.
        255.0, 000.0, 000.0, 1.0  // Red.
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, 
                                                                 gradientColors, 
                                                                 NULL, 
                                                                 sizeof(gradientColors) / (sizeof(gradientColors[0])*4));
    
    CGContextDrawLinearGradient(context, 
                                gradient, 
                                [self bounds].origin, 
                                NSMakePoint(0.0, [self bounds].size.height), 
                                kCGGradientDrawsBeforeStartLocation);    
    
    // Simulate temperature bar by blacking the gradient above the current temperature.
    [[NSColor blackColor] setStroke];
    [[NSColor blackColor] setFill];
    CGFloat barHeight = normalizedTemperature * [self bounds].size.height;
    NSRect temperatureRect = NSMakeRect(0.0, barHeight, [self bounds].size.width, ([self bounds].size.height - barHeight));
    CGContextFillRect(context, temperatureRect);
    
    // Draw the temperature number.
    NSString* temperatureString = [NSString stringWithFormat:@"%2.0f", temperature];
    [[NSColor whiteColor] setStroke];
    [[NSColor whiteColor] setFill];
    CGContextSelectFont(context, "Monaco" /*"Arial"*//* "Helvetica-Bold" */, 30.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextShowTextAtPoint(context, [self bounds].size.width / 2.0 - 15.0, [self bounds].size.height / 2.0, 
                             [temperatureString cStringUsingEncoding:NSUTF8StringEncoding], [temperatureString length]);
}

-(void)dealloc
{
    [NEThermoWindowController release];
    [super dealloc];
}

@end
