//
//  MyOpenGLView.h
//  LearningCocoa
//
//  Created by Lydia Hellrung on 10/9/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <OpenGL/OpenGL.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "../EDNA/EDDataElement.h"

#include "BlockIO.h"

static const size_t NUMBER_OF_CHANNELS = 4;
static const size_t DISPLAY_IMAGE_WIDTH = 320;
static const size_t DISPLAY_IMAGE_HEIGHT = 256;
static const size_t SLICES_PER_ROW = 5;
static const size_t SLICES_PER_COL = 4;
static const size_t SLICE_DIMENSION = 64;

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
    EDDataElement           *functionalImage;

}

- (void)setFunctionalImage:(EDDataElement*)newFunctionalImage;
- (void)convertFunctionalImage;
- (void)updateImage:(EDDataElement*)newActivationImage;

+ (BAGUIPrototyp*)getGUI;

@end
