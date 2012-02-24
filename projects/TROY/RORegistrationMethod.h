//
//  RORegistrationMethod.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDDataElement;

/**
 * Common interface for all BART registration methods.
 */
@interface RORegistrationMethod : NSObject

/**
 * Initializes a new RegistrationMethod object by finding
 * the registration for a functional data set fun with the
 * corresponding anatomy ana and the anatomical reference ref.
 * 
 * If applied by apply() the resulting DataElement should
 * contain the functional data in the reference space.
 *
 * \param fun The functional MRI data.
 * \param ana The anatomical MRI data for parameter fun.
 * \param ref The anatomical reference space.
 */
-(id)initFindingTransform:(EDDataElement*)fun
                  anatomy:(EDDataElement*)ana
                reference:(EDDataElement*)ref;

/**
 * Applies a transformation determined earlier by calling
 * the constructor initFindingTransform().
 *
 * \param toAlign The EDDataElement to align.
 * \return        A new EDDataElement (autoreleased) that
 *                represents the aligned image.
 */
-(EDDataElement*)apply:(EDDataElement*)toAlign;

@end
