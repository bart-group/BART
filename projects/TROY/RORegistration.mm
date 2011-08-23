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

-(EDDataElement*)align:(EDDataElement*)toAlign withReference:(EDDataElement*)ref 
{
    self->registrationFactory->Reset();
    
    self->registrationFactory->SetTransform(RegistrationFactoryType::VersorRigid3DTransform);
    self->registrationFactory->SetMetric(RegistrationFactoryType::MattesMutualInformationMetric);
    self->registrationFactory->SetInterpolator(RegistrationFactoryType::LinearInterpolator);
    self->registrationFactory->SetOptimizer(RegistrationFactoryType::RegularStepGradientDescentOptimizer);    
    
    self->registrationFactory->UserOptions.PREALIGN = true;
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
        
    self->registrationFactory->UserOptions.NumberOfThreads = 1;
    self->registrationFactory->UserOptions.MattesMutualInitializeSeed = 1;


    
    ITKImage::Pointer refITKImg = [ref asITKImage];
    ITKImage::Pointer toAlignITKImg = [toAlign asITKImage];
    
    // Causes unit tests to crash currently
//    self->registrationFactory->SetFixedImage(refITKImg);
//    self->registrationFactory->SetMovingImage(toAlignITKImg);

//    self->registrationFactory->StartRegistration();
    
    const itk::TransformBase* tmpConstTransformPointer;
    tmpConstTransformPointer = registrationFactory->GetTransform();
    
    return nil;
}

@end
