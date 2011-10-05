//
//  RORegistration.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistration.h"

#import "EDDataElement.h"

@implementation RORegistration

-(id)init
{
    if (self = [super init]) {
        self->registrationFactory = RegistrationFactoryType::New();
    }
    
    return self;    
}

bool verbose = true;

-(EDDataElement*)align:(EDDataElement*)toAlign withReference:(EDDataElement*)ref 
{
    if (toAlign == nil || ref == nil) {
        // TODO: throw exception?
        return nil;
    }
    
    self->registrationFactory->Reset();
    
    self->registrationFactory->SetTransform(RegistrationFactoryType::VersorRigid3DTransform);
//    self->registrationFactory->SetTransform(RegistrationFactoryType::AffineTransform); 

    self->registrationFactory->SetMetric(RegistrationFactoryType::MeanSquareMetric);
//    self->registrationFactory->SetMetric(RegistrationFactoryType::NormalizedCorrelationMetric); // very runtime inefficient
//    self->registrationFactory->SetMetric(RegistrationFactoryType::MutualInformationHistogramMetric); // even more runtime inefficient
    self->registrationFactory->SetInterpolator(RegistrationFactoryType::LinearInterpolator);
    self->registrationFactory->SetOptimizer(RegistrationFactoryType::RegularStepGradientDescentOptimizer);    
    
    self->registrationFactory->UserOptions.PREALIGN = false; //true;
    self->registrationFactory->UserOptions.PREALIGNPRECISION = 7;
    
    self->registrationFactory->UserOptions.CoarseFactor = 1;
    self->registrationFactory->UserOptions.BSplineBound = 15.0f;
    self->registrationFactory->UserOptions.NumberOfIterations = 500;
    self->registrationFactory->UserOptions.NumberOfBins = 50;
    self->registrationFactory->UserOptions.PixelDensity = 0;
    self->registrationFactory->UserOptions.BSplineGridSize = 6; // 5 or 6 are defaults, must not be lower than 5
    self->registrationFactory->UserOptions.ROTATIONSCALE = -1;
    self->registrationFactory->UserOptions.TRANSLATIONSCALE = -1;
    self->registrationFactory->UserOptions.PREALIGNPRECISION = 5;
    
    // TODO: remove
    if ( verbose ) {
        registrationFactory->UserOptions.SHOWITERATIONATSTEP = 1;
        registrationFactory->UserOptions.PRINTRESULTS = true;
    } else {
        registrationFactory->UserOptions.SHOWITERATIONATSTEP = 10;
        registrationFactory->UserOptions.PRINTRESULTS = false;
    }
    // remove END
        
    self->registrationFactory->UserOptions.NumberOfThreads = 1;
    self->registrationFactory->UserOptions.MattesMutualInitializeSeed = 1;

    // Convert data elements to ITK images.
    ITKImage::Pointer refITKImg = [ref asITKImage];
    ITKImage::Pointer toAlignITKImg = [toAlign asITKImage];
    self->registrationFactory->SetFixedImage(refITKImg);
    self->registrationFactory->SetMovingImage(toAlignITKImg);
    
    // Causes unit tests to crash if the MattesMutualInformationMetric is used
    self->registrationFactory->StartRegistration();
    
    const itk::TransformBase* tmpConstTransformPointer;
    tmpConstTransformPointer = registrationFactory->GetTransform();
    
    return nil;
}

@end
