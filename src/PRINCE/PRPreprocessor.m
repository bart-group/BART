//
//  PRPreprocessor.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/30/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "PRPreprocessor.h"
#import <Quartz/Quartz.h>

@implementation PRPreprocessor



-(BOOL)preprocessTheData:(EDDataElement*)data
           timestepRange:(NSRange)range
{
    
    // CIContext *ciContext = [CIContext contextWithOptions:nil];
    
    
    BARTImageSize *dataSize = [data getImageSize];
    //NSArray *minMax = [data getMinMaxOfDataElement];
    //float minVal = [[minMax objectAtIndex:0] floatValue];
    //float maxVal = [[minMax objectAtIndex:1] floatValue];
    
     NSLog(@"(Pre)Processing Range location: %lu", range.location);
    NSLog(@"(Pre)Processing Range length: %lu", range.length);
    for(size_t timestep = range.location; timestep < range.location + range.length; timestep++) {

        NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];

        NSLog(@"(Pre)Processing Timestep: %lu", timestep);
        for(size_t slice = 0; slice < [dataSize slices]; slice++) {
            float *sliceData     = [data getSliceData:slice atTimestep:timestep];
            float *sliceRGBAData = malloc([dataSize rows] * [dataSize columns] * sizeof(float) * 4);
            
            for(size_t row = 0 ; row < [dataSize rows]; row++) {
                for(size_t column = 0 ; column < [dataSize columns]; column++) {
                    float value = sliceData[(row * [dataSize columns]) + column];///maxVal;
//                    NSLog(@"Input Bitmap: Row: %lu; Col: %lu; Slice: %lu; TS: %lu; Val: %.2f", row, column, slice, timestep, value);
                    sliceRGBAData[((row * [dataSize columns]) + column) * 4 + 0] = value;
                    sliceRGBAData[((row * [dataSize columns]) + column) * 4 + 1] = value;
                    sliceRGBAData[((row * [dataSize columns]) + column) * 4 + 2] = value;
                    sliceRGBAData[((row * [dataSize columns]) + column) * 4 + 3] = 1.0;
                }
            }
            
            NSData *sliceNSData = [NSData dataWithBytes:sliceRGBAData length:[dataSize columns] * [dataSize rows] * sizeof(float) * 4];
            
            CIImage *sliceImage = [CIImage imageWithBitmapData:sliceNSData
                                                   bytesPerRow:[dataSize columns] * sizeof(float) * 4
                                                          size:CGSizeMake([dataSize columns], [dataSize rows])
                                                        format:kCIFormatRGBAf
                                                    colorSpace:CGColorSpaceCreateDeviceRGB()];
//            CGContextRef sliceContext = CGBitmapContextCreate(sliceNSData,
//                                                              [dataSize columns],
//                                                              [dataSize rows],
//                                                              sizeof(float) * 8,
//                                                              [dataSize columns] * sizeof(float) * 4,
//                                                              CGColorSpaceCreateDeviceRGB(),
//                                                              kCGBitmapFloatComponents);
            CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [gaussianBlurFilter setValue:sliceImage forKey:@"inputImage"];
            [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 1.5] forKey: @"inputRadius"];

            CIImage *blurredImage = [gaussianBlurFilter valueForKey:@"outputImage"];
            //[blurredImage ]
//            NSBitmapImageRep *resultRef = [[NSBitmapImageRep alloc] initWithCIImage:blurredImage];
//            NSBitmapImageRep *resultRef = [[NSBitmapImageRep alloc] initWithCIImage:sliceImage];

            [[[NSGraphicsContext currentContext] CIContext] render:blurredImage
                                                          toBitmap:sliceRGBAData
                                                          rowBytes:[dataSize columns] * sizeof(float) * 4
                                                            bounds:CGRectMake(0,0,[dataSize columns], [dataSize rows])
                                                            format:kCIFormatRGBAf
                                                        colorSpace:CGColorSpaceCreateDeviceRGB()];
            
            
            
            
//            CGImageRef blurredCGImageRef  = [blurredImage CGImage];
//            CFDataRef  blurredCGImageData = CGDataProviderCopyData(CGImageGetDataProvider(blurredCGImageRef));
//            float *pResultData = (float*)(CFDataGetBytePtr(blurredCGImageData));
            
            
            for(size_t row = 0 ; row < [dataSize rows]; row++) {
                for(size_t column = 0 ; column < [dataSize columns]; column++) {
                    
                    float resVal = sliceRGBAData[(row * [dataSize columns] + column) * 4];
                    //NSLog(@"Result Bitmap: Row: %lu; Col: %lu; Slice: %lu; TS: %lu; Val: %.2f", row, column, slice, timestep, resVal);
                    NSNumber *value = [NSNumber numberWithFloat:resVal];
                    [data setVoxelValue:value atRow:row col:column slice:slice timestep:timestep];
                }
            }
            
            // [resultRef release];
            free(sliceRGBAData);
            free(sliceData);
        }
        
        [autoreleasePool drain];
    }
    
    NSLog(@"PREPROC data Pointer: %@",data);
    return true;
}




@end
