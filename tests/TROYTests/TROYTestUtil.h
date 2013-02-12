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
 * Redirects all following prints to a stream to a given file.
 * Call this at the beginning of a SenTest if you want to preserve the
 * console output.
 *
 * \param stream   Stream to redirect (e.g. stdout/stderr).
 * \param filepath File to redirect prints (e.g. printf, NSLog, <<) to.
 * \param mode     Mode to open filepath with 
 *                 (e.g. "a" for append, "w" for (over-)write).
 */
-(void)redirect:(FILE*)stream
             to:(NSString*)filepath
          using:(NSString*)mode;

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
