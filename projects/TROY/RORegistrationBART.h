//
//  RORegistrationBART.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RORegistrationVnormdata.h"

/**
 * BART registration workflow:
 *
 * 1. Align functional data to anatomy yielding transformation T1
 * 2. Align anatomical data to reference space (MNI) yielding transformation T2
 * 3. Apply T1, T2 to the original functional data
 *    fun2mni
 */
@interface RORegistrationBART : RORegistrationVnormdata {

    @protected
    DeformationFieldType::Pointer m_firstTransformation;
    
}

@end
