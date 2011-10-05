//
//  RORegistration.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EDDataElement.h"

#include "isisRegistrationFactory3D.hpp"

typedef isis::registration::RegistrationFactory3D<ITKImage, ITKImage> RegistrationFactoryType;

@interface RORegistration : NSObject {
    
    @private
    RegistrationFactoryType::Pointer registrationFactory;
    
}

/*
 * TODO: 
 * - pass transform/metric/optimizer/interpolator PLUS align&reference in constructor
 * - align :: DataElement -> DataElement
 *    applies the transformation stored into the registration object to the given DataElement
 *    and returns the transformed DataElement
 */
//-(RORegistration*)initWithParams:

/**
 *
 */
-(EDDataElement*)align:(EDDataElement*)toAlign withReference:(EDDataElement*)ref;

@end
