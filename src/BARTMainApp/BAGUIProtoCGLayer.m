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
#import "ColorMappingFilter.h"

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
CIImage                 *foregroundCIImageFiltered;

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

int                     slicesPerRow = 1;
int                     slicesPerCol = 1;
int                     sliceDimension = 64;

float                   minThreshold = 0.0;
float                   maxThreshold = 0.0;

CGFloat                 scaleFactor = 1.0;

CGRect                  windowRect;

CGContextRef layerOneContext;
CGContextRef layerTwoContext;

float* colorTableData;

- (void)setupImages;
- (CGPoint)computeMinMaxVoxelValue:(BADataElement*)image;
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
    
    shortFormat = kCIFormatRGBA16;
    floatFormat = kCIFormatRGBAf;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /************************************/
    /*init CIFilter with color mapping kernel*/
    
    
    NSSize ctSize;
    ctSize.width  = 512;
    ctSize.height = 1;
    
    //float colorTableData[256 * 4 * 2];
    colorTableData = malloc(sizeof(float) * 256 * 4 * 2);
    
    // red to yellow (the more positive the more yellow)
    for(int _ctIndex = 0; _ctIndex < 256; _ctIndex++) {
        colorTableData[_ctIndex * 4 + 0] = 1.0;
        colorTableData[_ctIndex * 4 + 1] = 1.0 * (_ctIndex / 255.0);
        colorTableData[_ctIndex * 4 + 2] = 0.0;//1.0 * _ctIndex / 255.0;
        colorTableData[_ctIndex * 4 + 3] = 1.0;
    }
    // cyan to blue (the more negative the more cyan)
    for(int _ctIndex = 0; _ctIndex < 256; _ctIndex++) {
        colorTableData[(_ctIndex + 256) * 4 + 0] = 0.0;//0.5 - 0.5 * (_ctIndex / 255.0); // 127 to 0
        colorTableData[(_ctIndex + 256) * 4 + 1] = 1.0 * (_ctIndex / 255.0); // 255 to 0
        colorTableData[(_ctIndex + 256) * 4 + 2] = 1.0;//1.0 * (_ctIndex / 255.0);
        colorTableData[(_ctIndex + 256) * 4 + 3] = 1.0;
    }
    
    //short colorTableData[256 * 4];
//    for(int _ctIndex = 0; _ctIndex < 256; _ctIndex++) {
//        colorTableData[_ctIndex * 4 + 0] = USHRT_MAX;
//        colorTableData[_ctIndex * 4 + 1] = USHRT_MAX / 255.0 *_ctIndex;
//        colorTableData[_ctIndex * 4 + 2] = 0;
//        colorTableData[_ctIndex * 4 + 3] = USHRT_MAX;
//    }
    
    colorTable = [[CIImage imageWithBitmapData:[NSData dataWithBytes:colorTableData length:256 * sizeof(float) * 4 * 2]
                                   bytesPerRow:256 * sizeof(float) * 4 * 2
                                          size:ctSize 
                                        format:floatFormat 
                                    colorSpace:colorSpace] retain];

   // colorTable = [[CIImage imageWithBitmapData:[NSData dataWithBytes:colorTableData length:256 * sizeof(short) * 4]
//                                   bytesPerRow:256 * sizeof(short) * 4
//                                          size:ctSize 
//                                        format:shortFormat 
//                                    colorSpace:colorSpace] retain];
//    
    
//    NSLog(@"created color table: %@", colorTable);
//    NSLog(@"ColorTable[5]: %d" ,colorTableData[5]);
//    NSLog(@"ColorTable[25]: %d", colorTableData[25]);
//    NSLog(@"ColorTable[156]: %d", colorTableData[157]);
    
    /************************************/
	free(colorTableData);
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(updateTimesteps:)
	 name:@"updateTimesteps"
	 object:nil ] ;
	

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
    
    boundaries = [backgroundCIImage extent];//(CGRect){(CGPoint){0.0, 0.0}, (CGSize){320.0,256.0}};//[backgroundCIImage extent];
    
    CGContextRestoreGState(layerOneContext);
    CGContextSaveGState(layerOneContext);
    
    CGContextScaleCTM(layerOneContext, scaleFactor, scaleFactor);
    
    CGImageRef backgroundCGImage = [myCIContext createCGImage:backgroundCIImage fromRect:boundaries format:shortFormat colorSpace:colorSpace];    
    CGContextDrawImage(layerOneContext, boundaries, backgroundCGImage);
    CGContextDrawLayerAtPoint ([[applicationWindow graphicsContext] graphicsPort], CGPointZero, backgroundLayer);
    
    foregroundLayer = CGLayerCreateWithContext([[applicationWindow graphicsContext] graphicsPort], windowRect.size, NULL);
    layerTwoContext = CGLayerGetContext(foregroundLayer);
    
    CGContextSetInterpolationQuality(layerTwoContext, kCGInterpolationNone);
    CGContextScaleCTM(layerTwoContext, scaleFactor, scaleFactor);
    
    /********************************************************************************/
    if (nil != foregroundCIImage)
    {
    
        int colorTableMappingType = 0;
        [ColorMappingFilter class];
      
        colorMappingFilter = [CIFilter filterWithName: @"ColorMappingFilter"
										keysAndValues: @"inputImage", foregroundCIImage,
                              @"colorTable", colorTable, nil];
        
//        colorMappingFilter = [CIFilter filterWithName:@"ColorMappingFilter"];
        [colorMappingFilter retain];
        
  //      [colorMappingFilter setValue:foregroundCIImage forKey:@"inputImage"];
        
        //NSLog(@"got instance of colorMappingFilter: %@", colorMappingFilter);
        
        [(ColorMappingFilter*)colorMappingFilter setKernelToUse: colorTableMappingType];
        float    filterMinimum = 0.0;
        float    filterMaximum = 255.0;
        [colorMappingFilter setValue: [NSNumber numberWithFloat: filterMinimum / 255.0]
                              forKey: @"minimum"];
        
        [colorMappingFilter setValue: [NSNumber numberWithFloat: filterMaximum / 255.0]
                              forKey: @"maximum"];
        
    //    [colorMappingFilter setValue:colorTable
      //                      forKey:@"colorTable"];
        //NSLog(@"COLORMAPPINGFILTER: %@", colorMappingFilter);
        
        foregroundCIImage = [colorMappingFilter valueForKey:@"outputImage"];
        
       
    }
    /********************************************************************************/
    
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
    
    // Attributes that vary from functional to activation image. 
    short_bytes_length = sizeof(short) * NUMBER_OF_CHANNELS * displayImageWidth * displayImageHeight;//DISPLAY_IMAGE_WIDTH * DISPLAY_IMAGE_HEIGHT;
    short_bytesPerRow = sizeof(short) * NUMBER_OF_CHANNELS * displayImageWidth;//DISPLAY_IMAGE_WIDTH;
    
    float_bytes_length = sizeof(float) * NUMBER_OF_CHANNELS * displayImageWidth * displayImageHeight;//DISPLAY_IMAGE_WIDTH * DISPLAY_IMAGE_HEIGHT;
    float_bytesPerRow = sizeof(float) * NUMBER_OF_CHANNELS * displayImageWidth;//DISPLAY_IMAGE_WIDTH;
    
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
    
    CGPoint minmax;
    minmax = [self computeMinMaxVoxelValue:backgroundImage];
    
    float valueScale = ((float) SHRT_MAX) / (minmax.y - minmax.x);  
    
    NSLog(@"min: %8.0f, max: %8.0f, scale: %2.2f", minmax.x, minmax.y, valueScale);
    
    for (int col = 0; col < displayImageWidth; col++) {
        for (int row = 0; row < displayImageHeight; row++) {
            slice = ((row / sliceDimension) * slicesPerRow) + (col / sliceDimension);
            pos = NUMBER_OF_CHANNELS * ((row * displayImageWidth) + col);
            if (slice < numSlices) {
                value = [backgroundImage getShortVoxelValueAtRow:(row % sliceDimension) col:(col % sliceDimension) slice:slice timestep:0];//VPixel(functionalImage[slice], 0, (row % SLICE_DIMENSION), (col % SLICE_DIMENSION), VShort);
            } else {
                value = -1;
            }
                        
            backgroundImageRaw[pos] = (short) (value * valueScale);
            backgroundImageRaw[pos + 1] = (short) (value * valueScale);
            backgroundImageRaw[pos + 2] = (short) (value * valueScale);
            backgroundImageRaw[pos + 3] = -1;
        }
    }
}
- (CGPoint)computeMinMaxVoxelValue:(BADataElement*)image {
    enum ImageDataType imageDataType = image.imageDataType;
    float min = 0.0;
    float max = 0.0;
    float tmpFloat = 0.0;
    
    for (int slice = 0; slice < image.numberSlices; slice++) {
        for (int col = 0; col < image.numberCols; col++) {
            for (int row = 0; row < image.numberRows; row++) {
                if (imageDataType == IMAGE_DATA_SHORT) {
                    tmpFloat = (float) [image getShortVoxelValueAtRow:row col:col slice:slice timestep:0];
                } else if (imageDataType == IMAGE_DATA_FLOAT) {
                    tmpFloat = [image getFloatVoxelValueAtRow:row col:col slice:slice timestep:0];
                }
                
                if (tmpFloat > max) {
                    max = tmpFloat;
                } else if (tmpFloat < min) {
                    min = tmpFloat;
                }
            }
        }
    }
    
    return (CGPoint) {min, max};
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
    float contrastVector[3] = {1.0, 0.0, 0.0};
    
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
    NSLog(@"width: %d, height: %d, spr: %d, spc: %d",displayImageWidth, displayImageHeight, slicesPerRow, slicesPerCol);
    
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
            if (value > maxThreshold) {
                foregroundImageRaw[pos] = 0.5 * (value + fabs(minValue))/(fabs(minValue) + maxValue) + 0.5;//(value + fabs(minValue))/(fabs(minValue) + maxValue);
                foregroundImageRaw[pos + 1] = 0.5 * (value + fabs(minValue))/(fabs(minValue) + maxValue) + 0.5;//(value + fabs(minValue))/(fabs(minValue) + maxValue);
                foregroundImageRaw[pos + 2] = 0.5 * (value + fabs(minValue))/(fabs(minValue) + maxValue) + 0.5;//(value + fabs(minValue))/(fabs(minValue) + maxValue);
                foregroundImageRaw[pos + 3] = 1.0;
            } else if (value < minThreshold) {
                foregroundImageRaw[pos] = 0.5 * (value + fabs(minValue))/(fabs(minValue) + maxValue);
                foregroundImageRaw[pos + 1] = 0.5 * (value + fabs(minValue))/(fabs(minValue) + maxValue);
                foregroundImageRaw[pos + 2] = 0.5 * (value + fabs(minValue))/(fabs(minValue) + maxValue);//fabs(value);
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
                                          colorSpace:colorSpace];
    [foregroundCIImage retain];
	[self doPaint];
}

- (void)setSlicesPerRow:(int)spr col:(int)spc {
    slicesPerRow = spr;
    slicesPerCol = spc;
}

- (IBAction)updateSlider:(id)sender {
    minThreshold = [minimumSlider floatValue];
    maxThreshold = [maximumSlider floatValue];
    
    [minimumValueLabel setStringValue:[NSString stringWithFormat:@"%1.2f", minThreshold]];
    [maximumValueLabel setStringValue:[NSString stringWithFormat:@"%1.2f", maxThreshold]];
}


+ (BAGUIProtoCGLayer *)getGUI {
    return [gui retain];
}

-(void)awakeFromNib
{
	minThreshold = [minimumSlider floatValue];
	maxThreshold = [maximumSlider floatValue];    
    [minimumValueLabel setStringValue:[NSString stringWithFormat:@"%1.2f", minThreshold]];
    [maximumValueLabel setStringValue:[NSString stringWithFormat:@"%1.2f", maxThreshold]];
}

@end

