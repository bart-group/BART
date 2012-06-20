//
//  BAOpenExperimentToolbarButton.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAOpenExperimentToolbarButton.h"

@implementation BAOpenExperimentToolbarButton


- (NSImage*)image
{
    NSLog(@"BAOpenExperimentToolbarButton image: %@", [super image]);
    NSImage *returnImage = [super image];
    
    return returnImage;
}

- (void)setImage:(NSImage*)image
{
    NSLog(@"BAOpenExperimentToolbarButton image: %@", image);
    [super setImage:image];
}


@end
