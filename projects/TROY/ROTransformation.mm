//
//  ROTransformation.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/11/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "ROTransformation.h"
#import "EDDataElement.h"


@implementation ROTransformation

-(id)init
{
    if (self = [super init]) {
    }
    
    return self;    
}

-(EDDataElement*)transform:(EDDataElement*)element
{
    ITKImage::Pointer itkImage = [element asITKImage];
    return nil;
}

@end
