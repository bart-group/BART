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
    
    BARTImageSize *s = [elem2 getImageSize];
    NSLog(@"Image size: %lu %lu %lu %lu", s.columns, s.rows, s.slices, s.timesteps);
    
    
    [elem2 setVoxelValue:[NSNumber numberWithFloat:0.0] atRow:123 col:23 slice:54 timestep:0];
    
    
    [elem2 release];
    [pool drain];
}