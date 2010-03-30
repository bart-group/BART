//
//  BARTApplicationAppDelegate.h
//  BARTApplication
//
//  Created by First Last on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADataElement.h"
#import "BADesignElement.h"
#import "BAAnalyzerElement.h"
#import "BAGUIProtoCGLayer.h"

@interface BARTApplicationAppDelegate : NSObject <NSApplicationDelegate> {
    
    BADataElement*   mRawDataElement;
    BADesignElement* mDesignElement;
    unsigned int     mCurrentTimestep;
    
    /** GUI Boilerplate **/
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
    
    BADataElement           *backgroundImage;
    BADataElement           *foregroundImage;
    
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
    /** GUI Boilerplate END **/
    
}

/** GUI methods **/
- (void)initLayers;
- (void)doPaint;
- (IBAction)setBackgroundImage:(BADataElement*)newBackgroundImage;
- (IBAction)setForegroundImage:(BADataElement*)newForegroundImage;
- (IBAction)updateSlider:(id)sender;
/** GUI methods END **/

@end
