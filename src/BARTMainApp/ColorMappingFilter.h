//
//  ColorMappingFilterOne.h
//  CIFilter Test 001
//
//  Created by Torsten Schlumm on 12/23/09.
//  Copyright 2009 MPI CBS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuartzCore/CIFilter.h>


@interface ColorMappingFilter : CIFilter {
	
	CIImage*  inputImage;
	CIImage*  colorTable;
	NSNumber* minimum;
	NSNumber* maximum;

}

@property int kernelToUse;

@end
