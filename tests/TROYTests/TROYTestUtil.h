//
//  TROYTestUtil.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/8/13.
//  Copyright (c) 2013 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDDataElement;
@class RORegistrationMethod;

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
 * Measures the runtime of a RORegistrationMethod for both finding and applying the
 * transformation.
 * This method prints the result using NSLog and also returns a tuple containing both
 * the time needed to find the transformation as well as the time to apply the
 * transformation.
 *
 * \param funPath Filepath for the functional image.
 * \param anaPath Filepath for the anatomical image.
 * \param mniPath Filepath to the MNI (template) file.
 * \param outPath File to write the registration result to. 
 *                Pass nil or empty NSString if you don't want to write the result.
 * \param method  RORegistrationMethod that should be computed and applied.
 *                Only pass the allocated class object! Do not initialize the object!
 *                Initialization (= finding the transformation) happens in this method.
 *                The caller is still responsible for releasing the object.
 * \param runs    Number of iterations. The resulting runtime is averaged.
 * \return        Auto-released NSArray of NSNumbers.
 *                It is always a tuple where the first entry denotes the time to find
 *                the registration transformation and the second entry tells the time 
 *                to apply the transformation.
 */
-(NSArray*)measureRegistrationRuntime:(NSString*)funPath
                              anatomy:(NSString*)anaPath
                                  mni:(NSString*)mniPath
                                  out:(NSString*)outPath
                         registration:(RORegistrationMethod*)method
                                 runs:(int)runs;

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
