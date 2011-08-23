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

/**
 *
 */
-(EDDataElement*)align:(EDDataElement*)toAlign withReference:(EDDataElement*)ref;

@end
