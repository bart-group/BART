//
//  BAGUIProtoCGLayer.m
//  BARTApplication
//
//  Created by First Last on 12/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

/*
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ++++                                                                                      ++++
 ++++ TODO: Datentyp (byte/char, short, float) von backgroundImage muss frei waehlbar sein ++++
 ++++                                                                                      ++++
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */


#import "BAGUIProtoCGLayer.h"

#import <CoreGraphics/CGColorSpace.h>
#import <QuartzCore/QuartzCore.h>

//extern CIFormat kCIFormatARGB8;
extern CIFormat kCIFormatRGBA16;
extern CIFormat kCIFormatRGBAf;

static const int NUMBER_OF_CHANNELS = 4;
static const CGFloat MAX_SCALE_FACTOR = 8.0;

@interface BAGUIProtoCGLayer (PrivateMethods)

CIContext               *myCIContext;
CIImage                 *backgroundCIImage;
CIImage                 *foregroundCIImage;

BADataElement           *backgroundImage;
BADataElement           *foregroundImage;

CGRect                  boundaries;
NSUInteger              short_bytes_length;
NSUInteger              float_bytes_length;
short                   *backgroundImageRaw = nil;
float                   *foregroundImageRaw = nil;
void                    *chunkOfMemory;
NSData                  *imageData;
size_t                  short_bytesPerRow;
size_t                  float_bytesPerRow;
CGSize                  imageSize;
CIFormat                shortFormat;
CIFormat                floatFormat;
CGColorSpaceRef         colorSpace;
unsigned char           *colorTable = nil;

int                     slicesPerRow = 1;
int                     slicesPerCol = 1;
int                     sliceDimension = 64;

CGFloat                 scaleFactor = 1.0;

CGRect                  windowRect;

CGContextRef layerOneContext;
CGContextRef layerTwoContext;

- (void)setupImages;
- (void)convertFunctionalImage;
/**
 * Sets the number of rows/columns of the display matrix.
 */
- (void)setSlicesPerRow:(int)spr col:(int)spc;
//- (CGFloat *)convertToRGBFromHue:(int)h Saturation:(float)s Value:(float)v;

@end

static BAGUIProtoCGLayer *gui;

@implementation BAGUIProtoCGLayer

@synthesize applicationWindow;

- (id)initWithWindow:(NSWindow*)window {
	self = [super init];
	if(self != nil) {
		applicationWindow = window;
	}
    gui = self;
    
    //[self setSlicesPerRow:1 col:1];
    
	return self;
}

- (void)initLayers {
	windowRect = CGRectMake(0, 0, [[applicationWindow contentView] frame].size.width,
								  [[applicationWindow contentView] frame].size.height);
    
	// from the documentation of CGLayerRelease ;-)
	//
	//	Discussion
	//	This function is equivalent to calling CFRelease (layer) except that it does not
	//	crash (as CFRetain does) if the layer parameter is null.
	CGLayerRelease(backgroundLayer);
	CGLayerRelease(foregroundLayer);
	
	backgroundLayer = CGLayerCreateWithContext([[applicationWindow graphicsContext] graphicsPort], windowRect.size, NULL);
	foregroundLayer = CGLayerCreateWithContext([[applicationWindow graphicsContext] graphicsPort], windowRect.size, NULL);
    layerOneContext = CGLayerGetContext(backgroundLayer);
    layerTwoContext = CGLayerGetContext(foregroundLayer);
    
    CGContextSetInterpolationQuality(layerOneContext, kCGInterpolationHigh);
    CGContextSaveGState(layerOneContext);
    
    
}

- (void)doPaint {
    
    if (foregroundLayer) {
        //   CGLayerRelease(backgroundLayer);
        CGLayerRelease(foregroundLayer);
    }
    
	myCIContext = [CIContext contextWithCGContext:layerOneContext options:nil];
    
    boundaries = [backgroundCIImage extent];
    
    CGContextRestoreGState(layerOneContext);
    CGContextSaveGState(layerOneContext);
    
    CGContextScaleCTM(layerOneContext, scaleFactor, scaleFactor);
    
    CGImageRef backgroundCGImage = [myCIContext createCGImage:backgroundCIImage fromRect:boundaries format:shortFormat colorSpace:colorSpace];    
    CGContextDrawImage(layerOneContext, boundaries, backgroundCGImage);
    CGContextDrawLayerAtPoint ([[applicationWindow graphicsContext] graphicsPort], CGPointZero, backgroundLayer);
    
    foregroundLayer = CGLayerCreateWithContext([[applicationWindow graphicsContext] graphicsPort], windowRect.size, NULL);
    layerTwoContext = CGLayerGetContext(foregroundLayer);
    
    /********************************************/
    /*ColorSpaceRefTest*/
    
//    unsigned char* colorTable = (unsigned char*)malloc(sizeof(unsigned char)*3*256);
//    for (int i = 0; i<3*256; i++)
//    {
//        colorTable[i]= 0;
//    }
//    
//    colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorSpaceRef overlayColorSpace = CGColorSpaceCreateIndexed(colorSpace, 255, colorTable);
//    
//    CGContextSetFillColorSpace(layerTwoContext, colorSpace);
//    CGContextSetStrokeColorSpace(layerTwoContext, colorSpace);
//    CGContextSetRGBFillColor(layerTwoContext, 0.0, 1.0, 0.0, 1.0);
//	
//	CGContextFillRect(layerTwoContext, CGRectMake(0.0, 0.0, CGLayerGetSize(backgroundLayer).width, CGLayerGetSize(backgroundLayer).height));
//	
//	CGContextDrawLayerAtPoint ([[applicationWindow graphicsContext] graphicsPort], CGPointZero, foregroundLayer);
    /********************************************/
    
    CGContextSetInterpolationQuality(layerTwoContext, kCGInterpolationNone);
    CGContextScaleCTM(layerTwoContext, scaleFactor, scaleFactor);
    
    CGImageRef foregroundCGImage = [myCIContext createCGImage:foregroundCIImage fromRect:boundaries format:floatFormat colorSpace:colorSpace];    
    CGContextDrawImage(layerTwoContext, boundaries, foregroundCGImage);
    CGContextDrawLayerAtPoint ([[applicationWindow graphicsContext] graphicsPort], CGPointZero, foregroundLayer);
    
    [applicationWindow setViewsNeedDisplay:YES];
}

- (void)setupImages {
    
    // Common in both images.
    int displayImageWidth = slicesPerRow * sliceDimension;
    int displayImageHeight = slicesPerCol * sliceDimension;
    imageSize.width = (float) displayImageWidth;// DISPLAY_IMAGE_WIDTH;
    imageSize.height = (float) displayImageHeight;//DISPLAY_IMAGE_HEIGHT;
    
    /***** COLOR TABLE TEST *****/
    
//    if (colorTable == nil) {
//        colorTable = (unsigned char*)malloc(sizeof(unsigned char)*256);
//        
//        int pos = 0;
//        for (int i = 0; i<256; i++)
//        {
//            //pos = i * 3;
//            colorTable[pos] = i;//255-i;
//            //colorTable[pos + 1] = 0;//255-i;
////            colorTable[pos + 2] = 255;//255-i;
//        }
//        
//        colorSpace = CGColorSpaceCreateIndexed(CGColorSpaceCreateDeviceRGB(), 255, colorTable);
//        printf("NUMBER OF COMPONENTS: %d\n", CGColorSpaceGetNumberOfComponents(colorSpace));
//        CGColorSpaceRetain(colorSpace);
//    }
    
    /***** END COLOR TABLE TEST *****/
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Attributes that vary from functional to activation image. 
    short_bytes_length = sizeof(short) * NUMBER_OF_CHANNELS * displayImageWidth * displayImageHeight;//DISPLAY_IMAGE_WIDTH * DISPLAY_IMAGE_HEIGHT;
    short_bytesPerRow = sizeof(short) * NUMBER_OF_CHANNELS * displayImageWidth;//DISPLAY_IMAGE_WIDTH;
    shortFormat = kCIFormatRGBA16;
    
    float_bytes_length = sizeof(float) * NUMBER_OF_CHANNELS * displayImageWidth * displayImageHeight;//DISPLAY_IMAGE_WIDTH * DISPLAY_IMAGE_HEIGHT;
    float_bytesPerRow = sizeof(float) * NUMBER_OF_CHANNELS * displayImageWidth;//DISPLAY_IMAGE_WIDTH;
    floatFormat = kCIFormatRGBAf;
    
    // Generate functional CIImage and retain it.
    chunkOfMemory = backgroundImageRaw; 
	imageData = [NSData dataWithBytes:chunkOfMemory length:short_bytes_length];
    
	backgroundCIImage =	[CIImage imageWithBitmapData:imageData 
                                         bytesPerRow:short_bytesPerRow 
                                                size:imageSize 
                                              format:shortFormat 
                                          colorSpace:colorSpace];
    [backgroundCIImage retain];
       
    // Generate activation CIImage and retain it.
    // TODO: separate function
    if (foregroundImageRaw != nil) {
        
        chunkOfMemory = foregroundImageRaw;    
        imageData = [NSData dataWithBytes:chunkOfMemory length:float_bytes_length];

        foregroundCIImage =	[CIImage imageWithBitmapData:imageData
                                             bytesPerRow:float_bytesPerRow 
                                                    size:imageSize
                                                  format:floatFormat 
                                              //colorSpace:overlayColorSpace];
                                              colorSpace:colorSpace];
        [foregroundCIImage retain];
    }
}

- (void)setBackgroundImage:(BADataElement*)newBackgroundImage {
    
    if (backgroundCIImage) {
        [backgroundCIImage release];
    }
    
    backgroundImage = newBackgroundImage;
    if (backgroundImage.numberCols != backgroundImage.numberRows) {
        NSLog(@"Incompatible image dimensions (numberCols != numberRows). Choosing numberCols for display image.\n");
    }
    sliceDimension = backgroundImage.numberCols;
    
    double numSlices = (double) backgroundImage.numberSlices;
    double sqrtSlices = sqrt(numSlices);
    if (floor(sqrtSlices) + 0.5 > sqrtSlices) {
        [self setSlicesPerRow:(int) ceil(sqrtSlices) col:(int) floor(sqrtSlices)];
    } else {
        [self setSlicesPerRow:(int) ceil(sqrtSlices) col:(int) ceil(sqrtSlices)];
    }
    
    scaleFactor = MAX_SCALE_FACTOR / (CGFloat) slicesPerCol;
    
    
    //[self setSlicesPerRow:1 col:1];

    [self convertFunctionalImage];
    [self setupImages];
	[self doPaint];
}

/**
 * Converts the functional VImage into an linear color value array.
 */
- (void)convertFunctionalImage {
    
    int displayImageWidth = slicesPerRow * sliceDimension;
    int displayImageHeight = slicesPerCol * sliceDimension;
    int numSlices = backgroundImage.numberSlices;
    int slice;
    short value;
    int pos;
    
    if (backgroundImageRaw != nil) {
        free(backgroundImageRaw);
        backgroundImageRaw = nil;
    }
    
    backgroundImageRaw = (short*) malloc(sizeof(short) * NUMBER_OF_CHANNELS * displayImageWidth * displayImageHeight);
    
    for (int col = 0; col < displayImageWidth; col++) {
        for (int row = 0; row < displayImageHeight; row++) {
            slice = ((row / sliceDimension) * slicesPerRow) + (col / sliceDimension);
            pos = NUMBER_OF_CHANNELS * ((row * displayImageWidth) + col);
            if (slice < numSlices) {
                value = [backgroundImage getShortVoxelValueAtRow:(row % sliceDimension) col:(col % sliceDimension) slice:slice timestep:0];//VPixel(functionalImage[slice], 0, (row % SLICE_DIMENSION), (col % SLICE_DIMENSION), VShort);
            } else {
                value = -1;
            }
                        
            backgroundImageRaw[pos] = value;
            backgroundImageRaw[pos + 1] = value;
            backgroundImageRaw[pos + 2] = value;
            backgroundImageRaw[pos + 3] = -1;
        }
    }
}
 
- (void)setForegroundImage:(BADataElement*)newForegroundImage {
    
    int displayImageWidth = slicesPerRow * sliceDimension;
    int displayImageHeight = slicesPerCol * sliceDimension;
    
    if (foregroundCIImage) {
        [foregroundCIImage release];
    }
    
    foregroundImage = newForegroundImage;
    int numSlices = backgroundImage.numberSlices;
    
    int slice;
    int row;
    int col;
    float contrastVector[5] = {1.0, 0.0, 0.0, 0.0, 0.0};
    
    int pos;
    
    // Compute min/max voxel value for each image
    float minValue = 0.0;
    float maxValue = 0.0;
    for (col = 0; col < displayImageWidth; col++) {
        for (row = 0; row < displayImageHeight; row++) {
            slice = ((row / sliceDimension) * slicesPerRow) + (col / sliceDimension);
            if (slice < numSlices) { 
                pos = NUMBER_OF_CHANNELS * ((row * displayImageWidth) + col);
                float value = 0.0;
                                       
                for (int icontrast = 0; icontrast < foregroundImage.numberSlices; icontrast++) {
                    value += (contrastVector[icontrast]) * [foregroundImage getFloatVoxelValueAtRow:(row % sliceDimension) col:(col % sliceDimension) slice:icontrast timestep:slice]; // (timestep and slice are swapped in beta images)
                }
 
                if (value > maxValue) {
                    maxValue = value;
                } else if (value < minValue) {
                    minValue = value;
                }
            }
        }
    }
    NSLog(@"maxValue: %f; minValue: %f\n", maxValue, minValue);
    
    if (foregroundImageRaw != nil) {
        free(foregroundImageRaw);
    }
    
    // Convert BADataElement to raw color/pixel data.
    foregroundImageRaw = (float*) malloc(sizeof(float) * NUMBER_OF_CHANNELS * displayImageWidth * displayImageHeight);
    for (col = 0; col < displayImageWidth; col++) {
        for (row = 0; row < displayImageHeight; row++) {
            slice = ((row / sliceDimension) * slicesPerRow) + (col / sliceDimension);
            pos = NUMBER_OF_CHANNELS * ((row * displayImageWidth) + col);
            float value = 0.0;
            
            if (slice < numSlices) {
                //multiply all betas with given contrast vector 
                for (int icontrast = 0; icontrast < foregroundImage.numberSlices; icontrast++ ) {
                    value += (contrastVector[icontrast]) * [foregroundImage getFloatVoxelValueAtRow:(row % sliceDimension) col:(col % sliceDimension) slice:icontrast timestep:slice]; // (timestep and slice are swapped in beta images)
                }
            } else {
                value = 0.0;
            }

            //  activationImageRaw[pos] = value;
            //            activationImageRaw[pos + 1] = 0;
            //            activationImageRaw[pos + 2] = 0;
            
            
            if (value > 0.75) {
                foregroundImageRaw[pos] = value;//(value + fabs(minValue))/(fabs(minValue) + maxValue) ;
                foregroundImageRaw[pos + 1] = 0;//(value)/ maxValue ;
                foregroundImageRaw[pos + 2] = 0;
                foregroundImageRaw[pos + 3] = 1.0;
            } else if (value < -2.0) {
                foregroundImageRaw[pos] = 0;
                foregroundImageRaw[pos + 1] = 0;//fabs(value);
                foregroundImageRaw[pos + 2] = fabs(value);//(value + fabs(minValue))/(fabs(minValue) + maxValue) ;//fabs(value);
                foregroundImageRaw[pos + 3] = 1.0;
            } else {
                foregroundImageRaw[pos] = 0.0;
                foregroundImageRaw[pos + 1] = 0.0;
                foregroundImageRaw[pos + 2] = 0.0;
                foregroundImageRaw[pos + 3] = 0.0;
            }
        }
    }
    
    /****************************************/
    /*ColorSpaceRefTest*/
    
//    unsigned char* colorTable = (unsigned char*)malloc(sizeof(unsigned char)*3*256);
//    for (int i = 0; i<3*256; i++)
//    {
//        colorTable[i]=0;
//    }
//    
//    CGColorSpaceRef overlayColorSpace = CGColorSpaceCreateIndexed(colorSpace, 255, colorTable);
//    
//    
//    
    /***************************************/
    
    
    chunkOfMemory = foregroundImageRaw;
	imageData = [NSData dataWithBytes:chunkOfMemory length:float_bytes_length];
    foregroundCIImage =	[CIImage imageWithBitmapData:imageData 
                                         bytesPerRow:float_bytesPerRow 
                                                size:imageSize
                                              format:floatFormat
                                            //colorSpace:overlayColorSpace];
                                          colorSpace:colorSpace];
    [foregroundCIImage retain];
	[self doPaint];
}

- (void)setSlicesPerRow:(int)spr col:(int)spc {
    slicesPerRow = spr;
    slicesPerCol = spc;
}

//- (CGFloat*) convertToRGBFromHue:(int)h Saturation:(float)s Value:(float)v {
//    CGFloat *rgbVector = malloc(sizeof(CGFloat) * 3);
//    int hi = (h / 60) % 6;
//    float f = ((float) h / 60.0) - (float) (h / 60);
//    float p = v * (1.0 - s);
//    float q = v * (1.0 - f * s);
//    float t = v * (1.0 - (1.0 - f) * s);
//    
//    switch (hi) {
//        case 0:
//            rgbVector[0] = v;
//            rgbVector[1] = t;
//            rgbVector[2] = p;
//            break;
//        case 1:
//            rgbVector[0] = q;
//            rgbVector[1] = v;
//            rgbVector[2] = p;
//            break;
//        case 2:
//            rgbVector[0] = p;
//            rgbVector[1] = v;
//            rgbVector[2] = t;
//            break;
//        case 3:
//            rgbVector[0] = p;
//            rgbVector[1] = q;
//            rgbVector[2] = v;
//            break;
//        case 4:
//            rgbVector[0] = t;
//            rgbVector[1] = p;
//            rgbVector[2] = v;
//            break;
//        case 5:
//            rgbVector[0] = v;
//            rgbVector[1] = p;
//            rgbVector[2] = q;
//            break;
//        default:
//            break;
//    }
//
//    return rgbVector;
//}

+ (BAGUIProtoCGLayer *)getGUI {
    return [gui retain];
}


@end

