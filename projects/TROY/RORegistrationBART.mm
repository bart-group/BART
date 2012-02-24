//
//  RORegistrationBART.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistrationBART.h"

@implementation RORegistrationBART

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
        self->m_refITK = [ref asITKImage];
        
        std::vector<ETransform> transformTypes;
        std::vector<EOptimizer> optimizerTypes;
        self->m_firstTransformation = [self computeTransform:funITK3D 
                                              withReference:self->m_anaITK
                                             transformTypes:transformTypes
                                             optimizerTypes:optimizerTypes 
                                                   prealign:YES
                                                     smooth:SMOOTH_FWHM];
        
        std::vector<size_t> reso;
        reso.push_back(1);
        ITKImageContainer* transformResult = [self transform:NULL
                                                orFunctional:funITK4D
                                               withReference:self->m_anaITK
                                              transformation:self->m_firstTransformation 
                                                  resolution:reso];
        
        if (transformResult != NULL) {
            ITKImage4D::Pointer fun2ana = transformResult->getImg4D();
            free(transformResult);
            
            //        return [fun convertFromITKImage:fun2ana];
            
            transformTypes.push_back(VersorRigid3DTransform);
            transformTypes.push_back(AffineTransform);
            transformTypes.push_back(BSplineDeformableTransform);
            
            optimizerTypes.push_back(RegularStepGradientDescentOptimizer);
            optimizerTypes.push_back(RegularStepGradientDescentOptimizer);
            optimizerTypes.push_back(LBFGSBOptimizer);
            
            self->m_transformation = [self computeTransform:self->m_anaITK
                                              withReference:self->m_refITK 
                                             transformTypes:transformTypes
                                             optimizerTypes:optimizerTypes 
                                                   prealign:YES
                                                     smooth:SMOOTH_FWHM];
            
            // START Compositor test!
            //        typedef itk::DisplacementFieldCompositionFilter<DeformationFieldType, DeformationFieldType> TransformationCompositionFilter;
            //        TransformationCompositionFilter::Pointer compositor = TransformationCompositionFilter::New();
            //                
            //        compositor->SetInput(0, trans_fun2ana);
            //        compositor->SetInput(1, trans_ana2ref);
            
            //        compositor->SetInput(0, trans_ana2ref);
            //        compositor->SetInput(1, trans_fun2ana);
            
            ////        compositor->Update();
            
            //        DeformationFieldType::Pointer combinedTrans = compositor->GetOutput();
            // END Compositor test
        }
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
                                          transformation:self->m_firstTransformation 
                                              resolution:reso];
    
    if (transformResult != NULL) {
        ITKImage4D::Pointer fun2ana = transformResult->getImg4D();
        free(transformResult);
    
        reso.clear();
        reso.push_back(3);
        
        transformResult = [self transform:NULL
                             orFunctional:fun2ana
                            withReference:self->m_refITK
                           transformation:self->m_transformation 
                               resolution:reso];
        
        //        transformResult = [self transform:NULL 
        //                             orFunctional:funITK4D
        //                            withReference:refITK 
        //                           transformation:compositor->GetOutput() 
        //                               resolution:reso];
        
        //        DeformationFieldType::Pointer combinedTrans = compositor->GetOutput();
        //        std::cout << "##### FUN2ANA #####" << std::endl;
        //        std::cout << trans_fun2ana << std::endl;
        //        std::cout << "##### ANA2REF #####" << std::endl;
        //        std::cout << trans_ana2ref << std::endl;
        //        std::cout << "##### COMBINED #####" << std::endl;
        //        std::cout << combinedTrans << std::endl;
        
        if (transformResult != NULL) {
            ITKImage4D::Pointer fun2ana2mni = transformResult->getImg4D();
            free(transformResult);
            return [toAlign convertFromITKImage4D:fun2ana2mni];
        }
    }
    
    return nil;
}

@end
