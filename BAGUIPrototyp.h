//
//  MyOpenGLView.h
//  LearningCocoa
//
//  Created by First Last on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <OpenGL/OpenGL.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "BADataElement.h"

#include "BlockIO.h"

static const int NUMBER_OF_CHANNELS = 4;
static const int DISPLAY_IMAGE_WIDTH = 320;
static const int DISPLAY_IMAGE_HEIGHT = 256;
static const int SLICES_PER_ROW = 5;
static const int SLICES_PER_COL = 4;
static const int SLICE_DIMENSION = 64;

@interface BAGUIPrototyp : NSOpenGLView {

    // OpenGL related
	NSOpenGLPixelFormat     *pixelFormat;  // Need to save it for the CIContext creation.
	GLuint					FBOid;
	GLuint					FBOTextureId;
	GLfloat					functionalAspectRatio;
    GLfloat					activationAspectRatio;
	
	// Core Image Filters and values
	CIContext				*myCIcontext;
	CIImage					*functionalCIImage;
    CIImage                 *activationCIImage;
	CGRect					functionalRect;
    
    CIFilter                *sourceOverFilter;
    float                   activationOverlayAlpha;
    
    // Image data 
    NSUInteger              short_bytes_length;
    NSUInteger              float_bytes_length;
    short                   functionalImageRaw[4 * 320 * 256];
    float                   activationImageRaw[4 * 320 * 256];
    void                    *bytes;
	NSData                  *myData;
    size_t                  short_bytesPerRow;
    size_t                  float_bytesPerRow;
    CGSize                  mySize;
    CIFormat                shortFormat;
    CIFormat                floatFormat;
    CGColorSpaceRef         colorSpace;
    
    // Functional image
    BADataElement           *functionalImage;

}

- (void)setFunctionalImage:(BADataElement*)newFunctionalImage;
- (void)convertFunctionalImage;
- (void)updateImage:(BADataElement*)newActivationImage;

+ (BAGUIPrototyp*)getGUI;

@end
