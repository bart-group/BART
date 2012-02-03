//
//  RORegistration.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EDNA/EDDataElement.h"

#import "ROTypedef.h"

/**
 * Based on valign3d and vdotrans from Lipsia.
 */
@interface RORegistration : NSObject {
    
    @private
    RegistrationFactoryType::Pointer registrationFactory;
    /** Holds the transformation information gathered during init. */
    const itk::TransformBase* tmpConstTransformPointer;
    
    LinearInterpolatorType::Pointer linearInterpolator;
    BSplineInterpolatorType::Pointer bsplineInterpolator;
	NearestNeighborInterpolatorType::Pointer nearestNeighborInterpolator;

}

/*
 * TODO: 
 * - pass transform/metric/optimizer/interpolator PLUS align&reference in constructor
 * - align :: DataElement -> DataElement
 *    applies the transformation stored into the registration object to the given DataElement
 *    and returns the transformed DataElement
 */
//-(RORegistration*)initWithParams:
-(id)initFindingTransformFrom:(EDDataElement*)toAlign toReference:(EDDataElement*)ref;

/**
 * Emulate vnormdata behaviour.
 * Memory management notice: the created DataElement is autoreleased!
 */
-(EDDataElement*)normdata:(EDDataElement*)fun
                  anatomy:(EDDataElement*)ana
      anatomicalReference:(EDDataElement*)ref;

/**
 */
-(EDDataElement*)bartRegistration:(EDDataElement*)fun
                          anatomy:(EDDataElement*)ana
              anatomicalReference:(EDDataElement*)ref;

//-(EDDataElement*)align:(EDDataElement*)toAlign;

/**
 * \param other 
 * \return RORegistration object representing the combined transformation of self and other.
 *         The object is autoreleased.
 */
-(RORegistration*)combineTransform:(RORegistration*)other;

@end
