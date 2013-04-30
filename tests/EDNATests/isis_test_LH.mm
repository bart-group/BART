//
//  isis_test_LH.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 4/9/13.
//  Copyright (c) 2013 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "isis_test_LH.h"

#import "EDNA/EDDataElement.h"

@implementation isis_test_LH

@end


int main(void)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    EDDataElement *elem2 = [[EDDataElement alloc] initWithDataFile:@"/Users/Lydi/Development/BART_lydiatgit/tests/EDNATests/14265.5c_ana_mdeft.nii" andSuffix:@"" andDialect:@"" ofImageType:IMAGE_ANADATA];
    
    NSArray *propsToCopy = [NSArray arrayWithObjects:
                            @"voxelsize",
                            @"voxelGap",
                            @"rowVec",
                            @"sliceVec",
                            @"columnVec",
                            @"indexOrigin",
                            nil];
    
    NSDictionary* orientationProps = [elem2 getProps:propsToCopy];
    
    NSLog(@"ORIENTATION ORIG: %@", orientationProps);
    
    
    BARTImageSize * s = [[BARTImageSize alloc] initWithRows:64 andCols:64 andSlices:30 andTimesteps:1];
    EDDataElement *elem3 = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_BETAS withOrientationFrom:elem2];

    NSDictionary* copiedProps = [elem3 getProps:propsToCopy];
    
    NSLog(@"ORIENTATION COPIED: %@", copiedProps);
    
    [elem2 release];
    [elem3 release];
    [pool drain];
}