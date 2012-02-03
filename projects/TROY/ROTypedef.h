//
//  ROTypedef.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/3/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef BARTApplication_ROTypedef_h
#define BARTApplication_ROTypedef_h

// ISIS includes
#import "isisRegistrationFactory3D.hpp"
#import "isisTimeStepExtractionFilter.hpp"

// ITK includes
//#import <itkImageFileReader.h>
#import <itkHistogramMatchingImageFilter.h>
#import <itkWarpImageFilter.h>
#import <itkTileImageFilter.h>



// ISIS typedef
typedef isis::registration::RegistrationFactory3D<ITKImage, ITKImage> 
        RegistrationFactoryType;

typedef isis::extitk::TimeStepExtractionFilter<ITKImage4D, ITKImage> 
        TimeStepExtractionFilterType;



// # ITK typedefs
typedef itk::Vector<float, 3> 
        VectorType;

typedef itk::Image<VectorType, 3> 
        DeformationFieldType;

//typedef itk::ImageFileReader<DeformationFieldType> DeformationFieldReaderType;

// ## Filter
typedef itk::RecursiveGaussianImageFilter<ITKImage, ITKImage> 
        GaussianFilterType;

typedef itk::HistogramMatchingImageFilter<ITKImage, ITKImage> 
        MatchingFilterType;

typedef itk::ResampleImageFilter<ITKImage, ITKImage> 
        ResampleImageFilterType;

typedef itk::WarpImageFilter<ITKImage, ITKImage, DeformationFieldType> 
        WarpImageFilterType;

typedef itk::TileImageFilter<ITKImage, ITKImage4D> 
        TileImageFilterType;

// ## Interpolator
typedef itk::LinearInterpolateImageFunction<ITKImage, double> 
        LinearInterpolatorType;

typedef itk::NearestNeighborInterpolateImageFunction<ITKImage, double> 
        NearestNeighborInterpolatorType;

typedef itk::BSplineInterpolateImageFunction<ITKImage, double> 
        BSplineInterpolatorType;

// ## Transform
typedef itk::TransformBase* TransformBasePointerType;

#endif
