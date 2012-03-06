//
//  RORegistrationBARTAnaOnly.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/6/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RORegistrationVnormdata.h"

/**
 * Reduced BART registration workflow.
 * 
 * 1. Registrate the functional data to the anatomical data yielding 
 *    transformation T
 * 2. Apply transformation T to the functional data
 *    fun2ana
 */
@interface RORegistrationBARTAnaOnly : RORegistrationVnormdata

@end
