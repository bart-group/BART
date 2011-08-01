//
//  BAGUIProtoCGLayer.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 12/4/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../EDNA/EDDataElement.h"


@interface BAGUIProtoCGLayer : NSObject {
    
    IBOutlet NSWindow* applicationWindow;
	
	CGLayerRef backgroundLayer;
    CGLayerRef foregroundLayer;
    
    CIFilter* colorMappingFilter;
    CIImage* colorTable;
    
    IBOutlet NSSlider* minimumSlider;
    IBOutlet NSSlider* maximumSlider;
    IBOutlet NSTextField* minimumValueLabel;
    IBOutlet NSTextField* maximumValueLabel;
	IBOutlet NSTextField* timestepValueLabel;
    IBOutlet NSTextField* slidWinSizeValueLabel;
    
    CIContext               *myCIContext;
    CIImage                 *backgroundCIImage;
    CIImage                 *foregroundCIImage;
    CIImage                 *foregroundCIImageFiltered;
    
    EDDataElement           *backgroundImage;
    EDDataElement           *foregroundImage;
    
    CGRect                  boundaries;
    NSUInteger              short_bytes_length;
    NSUInteger              float_bytes_length;
    short                   *backgroundImageRaw;
    float                   *foregroundImageRaw;
    void                    *chunkOfMemory;
    NSData                  *imageData;
    size_t                  short_bytesPerRow;
    size_t                  float_bytesPerRow;
    CGSize                  imageSize;
    CIFormat                shortFormat;
    CIFormat                floatFormat;
    CGColorSpaceRef         colorSpace;
    
    int                     slicesPerRow;
    int                     slicesPerCol;
    int                     sliceDimension;
    
    float                   minThreshold;
    float                   maxThreshold;
    
    CGFloat                 scaleFactor;
    
    CGRect                  windowRect;
    
    CGContextRef layerOneContext;
    CGContextRef layerTwoContext;
    
    float* colorTableData;
}



/*
 * init the gui with colortable etc
 */
-(id)initWithDefault;

/**
 * Displays all layers and image objects (already converted EDDataElement objects).
 */
- (void)doPaint;

/**
 * Converts, retains and displays a EDDataElement in the background layer 
 * (usually used for anatomy data).
 */
- (IBAction)setBackgroundImage:(EDDataElement*)newBackgroundImage;

/**
 * Converts, retains and displays a EDDataElement in the background layer 
 * (usually used for functional/activation data).
 */
- (IBAction)setForegroundImage:(EDDataElement*)newForegroundImage;

- (IBAction)updateSlider:(id)sender;

@end
