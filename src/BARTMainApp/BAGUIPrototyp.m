
//
//  MyOpenGLView.m
//  LearningCocoa
//
//  Created by First Last on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BAGUIPrototyp.h"

#import <CoreGraphics/CGColorSpace.h>
#import <limits.h>

extern CIFormat kCIFormatARGB8;
extern CIFormat kCIFormatRGBA16;
extern CIFormat kCIFormatRGBAf;

extern VAttrList GetListInfo(VString, ListInfo *);

static BAGUIPrototyp *gui;

@implementation BAGUIPrototyp

- (id)initWithFrame:(NSRect)frameRect
{	
	// Nice antialised, hardware accelerated w/ no recovery by the software renderer.
	NSOpenGLPixelFormatAttribute   attribsAntialised[] =
	{
		NSOpenGLPFAAccelerated,
		NSOpenGLPFANoRecovery,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAColorSize, 24,
		NSOpenGLPFAAlphaSize,  8,
		// NOTE: for this particular case we don't need a depth buffer when drawing to the FBO, 
		// if you do need it, add the appropriate depth size,
		// but we don't want to waste VRAM here.
#if 0
		NSOpenGLPFADepthSize, 16,
#endif
		NSOpenGLPFAMultisample,
		NSOpenGLPFASampleBuffers, 1,
		NSOpenGLPFASamples, 4,
		nil
	};
	
	// A little less requirements if the above fails.
	NSOpenGLPixelFormatAttribute   attribsBasic[] =
	{
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAColorSize, 24,
		NSOpenGLPFAAlphaSize,  8,
		// NOTE: for this particular case we don't need a depth buffer when drawing to the FBO, 
		// if you do need it, add the appropriate depth size,
		// but we don't want to waste VRAM here.
#if 0		
		NSOpenGLPFADepthSize, 16,
#endif
		nil
	};
	
	pixelFormat = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attribsAntialised] autorelease];
	
	if (nil == pixelFormat) {
		NSLog(@"Couldn't find an FSAA pixel format, trying something more basic");
		pixelFormat = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attribsBasic] autorelease];
	}
	
	self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
	
	if (self) {
		NSOpenGLContext *ctx;
        ctx = [self openGLContext];
		
		// Turn on VBL syncing for swaps
		GLint VBL = 1;
		[ctx setValues:&VBL forParameter:NSOpenGLCPSwapInterval];
	}
	return self;
}

/**
 * Generate functional and activation CIImage. Also gets the bounding rectangle
 * as well as the aspect ratio.
 */
- (void)setupImages {
    
    // Common in both images.
    mySize.width = (float) DISPLAY_IMAGE_WIDTH;
    mySize.height = (float) DISPLAY_IMAGE_HEIGHT;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Attributes that vary from functional to activation image. 
    short_bytes_length = sizeof(short) * NUMBER_OF_CHANNELS * DISPLAY_IMAGE_WIDTH * DISPLAY_IMAGE_HEIGHT;
    short_bytesPerRow = sizeof(short) * NUMBER_OF_CHANNELS * DISPLAY_IMAGE_WIDTH;
    shortFormat = kCIFormatRGBA16;
    
    float_bytes_length = sizeof(float) * NUMBER_OF_CHANNELS * DISPLAY_IMAGE_WIDTH * DISPLAY_IMAGE_HEIGHT;
    float_bytesPerRow = sizeof(float) * NUMBER_OF_CHANNELS * DISPLAY_IMAGE_WIDTH;
    floatFormat = kCIFormatRGBAf;
    
    // Generate functional CIImage and retain it.
    bytes = functionalImageRaw;
	myData = [NSData dataWithBytes:bytes length:short_bytes_length];
	functionalCIImage =	[CIImage imageWithBitmapData:myData 
                                         bytesPerRow:short_bytesPerRow 
                                                size:mySize format:shortFormat 
                                          colorSpace:colorSpace];
    [functionalCIImage retain];
    
    // Generate activation CIImage and retain it.
    bytes = activationImageRaw;
	myData = [NSData dataWithBytes:bytes length:float_bytes_length];
	activationCIImage =	[CIImage imageWithBitmapData:myData 
                                         bytesPerRow:float_bytesPerRow 
                                                size:mySize 
                                              format:floatFormat 
                                          colorSpace:colorSpace];
    [activationCIImage retain];
    
    // Get boundaries and ratio.
    functionalRect = [functionalCIImage extent];
	functionalAspectRatio = functionalRect.size.width / functionalRect.size.height;
}

/**
 * Initializes the Sourceover-Filter (CISourceOverCompositing) and retains it.
 */
- (void)initSourceOverFilter {
    
    sourceOverFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceAtopCompositing
    [sourceOverFilter setDefaults];
    [sourceOverFilter retain];
}

// Create CIContext based on OpenGL context and pixel format
- (BOOL)createCIContext 
{
	// Create CIContext from the OpenGL context.
	myCIcontext = [CIContext contextWithCGLContext:[[self openGLContext] CGLContextObj] 
									   pixelFormat:[pixelFormat CGLPixelFormatObj]
										   options: nil];
    
	if (!myCIcontext) { 
		NSLog(@"CIContext creation failed");
		return NO;
	}
	
	[myCIcontext retain];
    
	// Created succesfully
	return YES;
}

// Create or update the hardware accelerated offscreen area
// Framebuffer object aka. FBO
- (void)setFBO
{	
	// If not previously setup
	// generate IDs for FBO and its associated texture
	if (!FBOid)
	{
		// Make sure the framebuffer extenstion is supported
		const GLubyte* strExt;
		GLboolean isFBO;
		// Get the extenstion name string.
		// It is a space-delimited list of the OpenGL extenstions 
		// that are supported by the current renderer
		strExt = glGetString(GL_EXTENSIONS);
		isFBO = gluCheckExtension((const GLubyte*)"GL_EXT_framebuffer_object", strExt);
		if (!isFBO)
		{
			NSLog(@"Your system does not support framebuffer extension");
		}
		
		// create FBO object
		glGenFramebuffersEXT(1, &FBOid);
		// the texture
		glGenTextures(1, &FBOTextureId);
	}
	
	// Bind to FBO
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FBOid);
	
	// Sanity check against maximum OpenGL texture size
	// If bigger adjust to maximum possible size
	// while maintain the aspect ratio
	GLint maxTexSize; 
	glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTexSize);
	if (functionalRect.size.width > maxTexSize || functionalRect.size.height > maxTexSize) 
	{
		if (functionalAspectRatio > 1)
		{
			functionalRect.size.width = maxTexSize; 
			functionalRect.size.height = maxTexSize / functionalAspectRatio;
		}
		else
		{
			functionalRect.size.width = maxTexSize * functionalAspectRatio ;
			functionalRect.size.height = maxTexSize; 
		}
	}
	
	// Initialize FBO Texture
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, FBOTextureId);
	// Using GL_LINEAR because we want a linear sampling for this particular case
	// if your intention is to simply get the bitmap data out of Core Image
	// you might want to use a 1:1 rendering and GL_NEAREST
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	// the GPUs like the GL_BGRA / GL_UNSIGNED_INT_8_8_8_8_REV combination
	// others are also valid, but might incur a costly software translation.
	glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA, functionalRect.size.width, functionalRect.size.height, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, NULL);
	
	// and attach texture to the FBO as its color destination
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_RECTANGLE_ARB, FBOTextureId, 0);
    
	// NOTE: for this particular case we don't need a depth buffer when drawing to the FBO, 
	// if you do need it, make sure you add the depth size in the pixel format, and
	// you might want to do something along the lines of:
#if 0
	// Initialize Depth Render Buffer
	GLuint depth_rb;
	glGenRenderbuffersEXT(1, &depth_rb);
	glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depth_rb);
	glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, imageRect.size.width, imageRect.size.height);
	// and attach it to the FBO
	glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depth_rb);
#endif	
	
	// Make sure the FBO was created succesfully.
	if (GL_FRAMEBUFFER_COMPLETE_EXT != glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT))
	{
		NSLog(@"Framebuffer Object creation or update failed!");
	}
    
	// unbind FBO 
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
}

- (void)prepareOpenGL
{
    gui = self;
    
	// Clear to black nothing fancy.
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	
	// Setup blending function 
	glBlendFunc(GL_SRC_COLOR, GL_SRC_COLOR);
	
	// Enable texturing 
	glEnable(GL_TEXTURE_RECTANGLE_ARB);
    glEnable(GL_BLEND);
    
  //  /*************/
//    glActiveTexture(GL_TEXTURE0);
//    // bind and set up image texture; does not need alpha channel in internal format
//    glActiveTexture(GL_TEXTURE1);
//    // bind and set up alpha texture; GL_ALPHA internal, GL_ALPHA format.
//    
//    /***********/
//    
}

- (void)dealloc
{
	// Delete the texture
	glDeleteTextures(1, &FBOTextureId);
	// and the FBO
	glDeleteFramebuffersEXT(1, &FBOid);
	
	[super dealloc];
}

// This method actually renders with Core Image to the 
// OpenGL managed, hardware accelerated offscreen area
- (void)renderCoreImageToFBO
{	   
	// Bind FBO 
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FBOid);
	
	// set GL state 
	GLint width = (GLint)ceil(functionalRect.size.width);
	GLint height = (GLint)ceil(functionalRect.size.height);
	
	// the next few calls simply map an orthographic
	// projection or screen aligned 2D area for Core Image to
	// draw into
	{
		glViewport(0, 0, width, height);
		
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrtho(0, width, 0, height, -1, 1);
		
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		
		glClear(GL_COLOR_BUFFER_BIT /*| GL_DEPTH_BUFFER_BIT no depth buffer */);
	}
    
    [sourceOverFilter setValue:activationCIImage forKey:@"inputImage"];
    [sourceOverFilter setValue:functionalCIImage forKey:@"inputBackgroundImage"];
	
	// Render CI 
	[myCIcontext drawImage: [sourceOverFilter valueForKey:@"outputImage"]
				   atPoint: CGPointZero  fromRect: functionalRect];
    
	// Bind to default framebuffer (unbind FBO)
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	
	[self setNeedsDisplay:YES];
}

- (void) renderScene
{
	NSRect bounds = [self bounds];
    
	// Setup OpenGL with a perspective projection
	// and back to 3D stuff with the depth buffer
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
		glViewport(0, 0, bounds.size.width, bounds.size.height);
		
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		gluPerspective(30.0, bounds.size.width / bounds.size.height, 0.1, 100.0);
		
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();
		// the GL_TEXTURE_RECTANGLE_ARB doesn't use normalized coordinates
		// scale the texture matrix to "increase" the texture coordinates
		// back to the image size
		glScalef(functionalRect.size.width,functionalRect.size.height,1.0f);
		
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		
		glTranslatef(0.0f, -0.5f, -2.0f);
        //glTranslatef(0.0f, 0.0f, -2.0f);
	}
    
    
    /*************/
    //glActiveTexture(GL_TEXTURE0);
//    glEnable(GL_TEXTURE_2D /* or whatever */);
//    glActiveTexture(GL_TEXTURE1);
//    glEnable(GL_TEXTURE_2D);
//    
//    glMultiTexCoord2f(GL_TEXTURE0, 0.0, 0.0);
//    glMultiTexCoord2f(GL_TEXTURE1, 0.0, 0.0);
    /***********/
	// Object on top of floor
	// Draw the image right side up
	// again using the texture from the FBO
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB,FBOTextureId);
	// Using GL_REPLACE because we want the image colors 
	// unaffected by the quad color.
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	// Draw a quad with the correct aspect ratio of the image
	glPushMatrix();
	{
		glScalef(functionalAspectRatio,1.0f,1.0f);
		glBegin(GL_QUADS);
		{
			glTexCoord2f( 1.0f, 1.0f ); glVertex2f(  0.5f, 1.0f );
			glTexCoord2f( 0.0f, 1.0f ); glVertex2f( -0.5f, 1.0f );
			glTexCoord2f( 0.0f, 0.0f ); glVertex2f( -0.5f, 0.0f );
			glTexCoord2f( 1.0f, 0.0f ); glVertex2f(  0.5f, 0.0f );
		}
		glEnd();
	}
	glPopMatrix();
}

- (void)drawRect:(NSRect)theRect
{		
	[[self openGLContext] makeCurrentContext];
    
	// Render using the resulting texture
	[self renderScene];
	
	// Make sure OpenGL does it thing!
	[[self openGLContext] flushBuffer];
}

- (void)setFunctionalImage:(BADataElement*)newFunctionalImage {
	functionalImage = newFunctionalImage;
    [self convertFunctionalImage];
    
    // load the image and setup the Core Image filters
    [self setupImages];
    [self initSourceOverFilter];
	
	// create an OpenGL backed CIContext
	[self createCIContext];
	
	// Create FBO and attached texture
	// FBO size depends on CI image extent
	// initialized in the methods called above.
	[self setFBO];	
    
    [self renderCoreImageToFBO];
}

/**
 * Converts the functional VImage into an linear color value array.
 */
- (void)convertFunctionalImage {
    int slice;
    short value;
    int pos;
    
    for (size_t col = 0; col < DISPLAY_IMAGE_WIDTH; col++) {
        for (size_t row = 0; row < DISPLAY_IMAGE_HEIGHT; row++) {
            slice = ((row / SLICE_DIMENSION) * SLICES_PER_ROW) + (col / SLICE_DIMENSION);
            pos = SLICES_PER_COL * ((row * DISPLAY_IMAGE_WIDTH) + col);
            value = [functionalImage getShortVoxelValueAtRow:(row % SLICE_DIMENSION) col:(col % SLICE_DIMENSION) slice:slice timestep:0];//VPixel(functionalImage[slice], 0, (row % SLICE_DIMENSION), (col % SLICE_DIMENSION), VShort);
            
            functionalImageRaw[pos] = value;
            functionalImageRaw[pos + 1] = value;
            functionalImageRaw[pos + 2] = value;
            functionalImageRaw[pos + 3] = -1;
        }
    }
}

- (void)updateImage:(BADataElement*)newActivationImage {

    activationOverlayAlpha = 1.0;
    
    if (activationCIImage) {
        [activationCIImage release];
    }
    
    size_t slice;
    size_t row;
    size_t col;
    float contrastVector[3] = {1.0, 0.0, 0.0};
    
    size_t pos;
    
    float minValue = 0.0;
    float maxValue = 0.0;
    
    for (col = 0; col < DISPLAY_IMAGE_WIDTH; col++) {
        for (row = 0; row < DISPLAY_IMAGE_HEIGHT; row++) {
            slice = ((row / SLICE_DIMENSION) * SLICES_PER_ROW) + (col / SLICE_DIMENSION);
            pos = NUMBER_OF_CHANNELS * ((row * DISPLAY_IMAGE_WIDTH) + col);
            float value = 0.0;
            for (size_t icontrast = 0; icontrast < newActivationImage.imageSize.slices; icontrast++){
                value += (contrastVector[icontrast]) * [newActivationImage getFloatVoxelValueAtRow:(row % SLICE_DIMENSION) col:(col % SLICE_DIMENSION) slice:icontrast timestep:slice];} // (timestep and slice are swapped in beta images)
            if (value > maxValue) {
                maxValue = value;
            } else if (value < minValue) {
                minValue = value;
            }
        }
    }
    NSLog(@"maxValue: %f; minValue: %f\n", maxValue, minValue);
    
    for (col = 0; col < DISPLAY_IMAGE_WIDTH; col++) {
        for (row = 0; row < DISPLAY_IMAGE_HEIGHT; row++) {
            slice = ((row / SLICE_DIMENSION) * SLICES_PER_ROW) + (col / SLICE_DIMENSION);
            pos = NUMBER_OF_CHANNELS * ((row * DISPLAY_IMAGE_WIDTH) + col);
            float value = 0.0;
            
            
            //multiply all betas with given contrast vector 
            for (size_t icontrast = 0; icontrast < newActivationImage.imageSize.slices; icontrast++ ){
                value += (contrastVector[icontrast]) * [newActivationImage getFloatVoxelValueAtRow:(row % SLICE_DIMENSION) col:(col % SLICE_DIMENSION) slice:icontrast timestep:slice];} // (timestep and slice are swapped in beta images)
          //  activationImageRaw[pos] = value;
//            activationImageRaw[pos + 1] = 0;
//            activationImageRaw[pos + 2] = 0;
            
            
            if (value > 0.0) {
                activationImageRaw[pos] = value;//(value + fabs(minValue))/(fabs(minValue) + maxValue) ;
                activationImageRaw[pos + 1] = 0;//(value)/ maxValue ;
                activationImageRaw[pos + 2] = 0;
                activationImageRaw[pos + 3] = activationOverlayAlpha;
            } else if (value < 0.0) {
                activationImageRaw[pos] = 0;
                activationImageRaw[pos + 1] = 0;//fabs(value);
                activationImageRaw[pos + 2] = fabs(value);//(value + fabs(minValue))/(fabs(minValue) + maxValue) ;//fabs(value);
                activationImageRaw[pos + 3] = activationOverlayAlpha;
            } else {//if (value == 0.0) {
                activationImageRaw[pos] = 0.0;
                activationImageRaw[pos + 1] = 0.0;
                activationImageRaw[pos + 2] = 0.0;
                activationImageRaw[pos + 3] = 0.0;

            }
            //activationImageRaw[pos] = value;//(value + fabs(minValue)) / (maxValue + fabs(minValue)); //(value + fabs(minValue)) / (maxValue - minValue);
            //activationImageRaw[pos + 1] = 0.0;
           
            //activationImageRaw[pos + 1] = 0.0; 
            
            
        }
    }
    
    bytes = activationImageRaw;
	myData = [NSData dataWithBytes:bytes length:float_bytes_length];
    activationCIImage =	[CIImage imageWithBitmapData:myData 
                                         bytesPerRow:float_bytesPerRow 
                                                size:mySize 
                                              format:floatFormat 
                                          colorSpace:colorSpace];
    [activationCIImage retain];
    
	// Update FBO for new size and check for correctness
	[self setFBO];	
    
    // Render Core Image to the FBO
	[self renderCoreImageToFBO];
}

+ (BAGUIPrototyp *)getGUI {
    return [gui retain];
}

@end