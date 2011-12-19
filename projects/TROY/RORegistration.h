//
//  RORegistration.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EDNA/EDDataElement.h"

// ISIS includes
#import "isisRegistrationFactory3D.hpp"
#import "isisTimeStepExtractionFilter.hpp"

// ITK includes
#import <itkImageFileReader.h>
#import <itkHistogramMatchingImageFilter.h>
#import <itkWarpImageFilter.h>
#import <itkTileImageFilter.h>


// ISIS typedef
typedef isis::registration::RegistrationFactory3D<ITKImage, ITKImage> RegistrationFactoryType;
typedef isis::extitk::TimeStepExtractionFilter<ITKImage4D, ITKImage> TimeStepExtractionFilterType;

// ITK typedefs
typedef itk::Vector<float, 3> VectorType;
typedef itk::Image<VectorType, 3> DeformationFieldType;
//typedef itk::ImageFileReader<DeformationFieldType> DeformationFieldReaderType;

typedef itk::HistogramMatchingImageFilter<ITKImage, ITKImage> MatchingFilterType;

typedef itk::ResampleImageFilter<ITKImage, ITKImage> ResampleImageFilterType;
typedef itk::WarpImageFilter<ITKImage, ITKImage, DeformationFieldType> WarpImageFilterType;

typedef itk::LinearInterpolateImageFunction<ITKImage, double> LinearInterpolatorType;
typedef itk::TileImageFilter<ITKImage, ITKImage4D> TileImageFilterType;




/**
 * Based on valign3d and vdotrans from Lipsia.
 */
@interface RORegistration : NSObject {
    
    @private
    RegistrationFactoryType::Pointer registrationFactory;
    /** Holds the transformation information gathered during init. */
    const itk::TransformBase* tmpConstTransformPointer;
    
    /** Applies the transformation to an ISIS image. */
    ResampleImageFilterType::Pointer resampler;
    WarpImageFilterType::Pointer warper;
    
    LinearInterpolatorType::Pointer linearInterpolator;
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
 */
-(EDDataElement*)normdata:(EDDataElement*)fun
                  anatomy:(EDDataElement*)ana
      anatomicalReference:(EDDataElement*)ref;

/**
 * Memory management notice: the created DataElement is autoreleased!
 */
//-(EDDataElement*)align:(EDDataElement*)toAlign 
//       beingFunctional:(BOOL)fmri
//         withReference:(EDDataElement*)ref;


//-(EDDataElement*)align:(EDDataElement*)toAlign;

/**
 * \param other 
 * \return RORegistration object representing the combined transformation of self and other.
 *         The object is autoreleased.
 */
-(RORegistration*)combineTransform:(RORegistration*)other;

@end
