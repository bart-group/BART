//
//  RORegistrationBART.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RORegistrationVnormdata.h"

@interface RORegistrationBART : RORegistrationVnormdata {

    @protected
    DeformationFieldType::Pointer m_firstTransformation;
    
}

@end
