//
//  TROYTestUtil.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/8/13.
//  Copyright (c) 2013 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "TROYTestUtil.h"

#import "EDDataElement.h"

@implementation TROYTestUtil

-(id)init
{
    if (self = [super init]) {
    }
    
    return self;
}

-(void)redirect:(FILE*)stream
             to:(NSString*)filepath
          using:(NSString*)mode
{
    freopen([filepath UTF8String], [mode UTF8String], stream);
}

-(EDDataElement*)createDiffImage:(EDDataElement*)a
                                :(EDDataElement*)b
{
    BARTImageSize* aSize = [a getImageSize];
    BARTImageSize* bSize = [b getImageSize];
    
    if (aSize.rows      == bSize.rows      and
        aSize.columns   == bSize.columns   and
        aSize.slices    == bSize.slices    and
        aSize.timesteps == bSize.timesteps and
        a.mImageType    == b.mImageType) {
        
        EDDataElement* diffImg = [[EDDataElement alloc] initEmptyWithSize:aSize ofImageType:a.mImageType];
        
        for (size_t ts = 0; ts < aSize.timesteps; ts++) {
            for (size_t slice = 0; slice < aSize.slices; slice++) {
                for (size_t row = 0; row < aSize.rows; row++) {
                    for (size_t col = 0; col < aSize.columns; col++) {
                        float aVal = [a getFloatVoxelValueAtRow:row col:col slice:slice timestep:ts];
                        float bVal = [a getFloatVoxelValueAtRow:row col:col slice:slice timestep:ts];
                        
                        float diffVal = aVal - bVal;
                        NSNumber* diffValNumber = [NSNumber numberWithFloat:diffVal];
                        [diffImg setVoxelValue:diffValNumber atRow:row col:col slice:slice timestep:ts];
                    }
                }
            }
        }
        
        return diffImg;
    }
    
    return nil;
}

@end
