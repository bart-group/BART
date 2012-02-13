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

-(id)initWithTransform:(DeformationFieldType::Pointer)trans
{
    if (self = [self init]) {
        self->m_Trans = trans;
    }
    
    return self;
}

//-(EDDataElement*)transform:(EDDataElement*)element
//{
//    ITKImage::Pointer itkImage = [element asITKImage];
//    return nil;
//}

-(DeformationFieldType::Pointer)getTransform
{
    return self->m_Trans;
}

-(ROTransformation*)join:(ROTransformation *)other
{
    return nil;
}

@end
