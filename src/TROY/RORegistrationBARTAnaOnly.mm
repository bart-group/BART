//
//  RORegistrationBARTAnaOnly.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/6/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistrationBARTAnaOnly.h"

@implementation RORegistrationBARTAnaOnly

-(id)init
{
    if (self = [super init]) {
    }
    
    return self;    
}

-(id)initFindingTransform:(EDDataElement*)fun
                  anatomy:(EDDataElement*)ana
                reference:(EDDataElement*)ref
{
    if (self = [self init]) {
        ITKImage::Pointer   funITK3D = [fun asITKImage];
        ITKImage4D::Pointer funITK4D = [fun asITKImage4D];
        self->m_anaITK = [ana asITKImage];
        
        std::vector<ETransform> transformTypes;
        std::vector<EOptimizer> optimizerTypes;
        self->m_transformation = [self computeTransform:funITK3D 
                                               withReference:self->m_anaITK
                                              transformTypes:transformTypes
                                              optimizerTypes:optimizerTypes 
                                                    prealign:YES
                                                      smooth:SMOOTH_FWHM];
    }
    
    return self;
}

-(EDDataElement*)apply:(EDDataElement*)toAlign
{
    ITKImage4D::Pointer funITK4D = [toAlign asITKImage4D];
    
    std::vector<size_t> reso;
    reso.push_back(1);
    ITKImageContainer* transformResult = [self transform:NULL
                                            orFunctional:funITK4D
                                           withReference:self->m_anaITK
                                          transformation:self->m_transformation 
                                              resolution:reso];
    
    if (transformResult != NULL) {
        ITKImage4D::Pointer fun2ana = transformResult->getImg4D();
        delete transformResult;
        
        return [toAlign convertFromITKImage4D:fun2ana];
    }
    
    return nil;
}

@end
