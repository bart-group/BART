//
//  TROYTestUtil.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/8/13.
//  Copyright (c) 2013 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDDataElement;

/**
 * Utilities for testing the BART registration module.
 */
@interface TROYTestUtil : NSObject

/**
 * Creates the voxel-by-voxel difference of two EDDataElements.
 *
 * \param a First EDDataElement.
 * \param b Second EDDataElement.
 * \return  Newly allocated EDDataElement showing the difference between a and b.
 *          Caller is responsible for releasing the object.
 *          Returns nil if a and b have non-identical image sizes or image types.
 */
-(EDDataElement*)createDiffImage:(EDDataElement*)a
                                :(EDDataElement*)b;

@end
