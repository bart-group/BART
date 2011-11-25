//
//  RORegistration.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistration.h"

#import "EDDataElement.h"
#import "EDDataElementIsis.h"

// ITK
#import <itkImageFileWriter.h>

// Isis
#import "DataStorage/image.hpp"
#import "Adapter/itkAdapter.hpp"

const int NR_THREADS = 8; //4;

@interface RORegistration (privateMethods)

-(DeformationFieldType::Pointer)computeTransform:(EDDataElement*)toAlign 
                               withReference:(EDDataElement*)ref;

-(EDDataElement*)transform:(EDDataElement*)toAlign 
             withReference:(EDDataElement*)ref 
            transformation:(DeformationFieldType::Pointer)trans 
                resolution:(std::vector<size_t>)res 
            functionalData:(BOOL)fmri; 

@end

@implementation RORegistration

-(id)init
{
    if (self = [super init]) {
        // From align3d
        self->registrationFactory = RegistrationFactoryType::New();
        
        // From dotrans3d
        self->resampler = ResampleImageFilterType::New();
        self->warper = WarpImageFilterType::New();
        self->linearInterpolator = LinearInterpolatorType::New();
        
//        isis::data::enable_log<isis::util::DefaultMsgPrint>(isis::info);

    }
    
    return self;    
}


-(id)initFindingTransformFrom:(EDDataElement*)toAlign 
                  toReference:(EDDataElement*)ref
{
    if (self = [self init]) {
//        self->tmpConstTransformPointer = [self computeTransform:toAlign withReference:ref];
    }
    
    return self;
}

-(EDDataElement*)align:(EDDataElement*)toAlign 
       beingFunctional:(BOOL)fmri
         withReference:(EDDataElement*)ref 
{
    if (toAlign == nil || ref == nil) {
        // exception?
        return nil;
    }
    
    // TODO: replace with method: align :: EDDataElement -> EDDataElement
    
    DeformationFieldType::Pointer trans = [self computeTransform:toAlign withReference:ref];
    
    std::vector<size_t> res;
    res.push_back(1);
    
    NSLog(@"### FINISHED COMPUTING TRANSFORM, ALIGNING NOW ###");
    
    EDDataElement* transformed = [self transform:toAlign 
                                   withReference:ref 
                                  transformation:trans 
                                      resolution:res 
                                  functionalData:fmri];
    
    return transformed;
}


-(RORegistration*)combineTransform:(RORegistration*)other
{
    return nil;
}

@end

@implementation RORegistration (privateMethods)

bool verbose = true;

-(DeformationFieldType::Pointer)computeTransform:(EDDataElement*)toAlign 
                                   withReference:(EDDataElement*)ref
{
    self->registrationFactory->Reset();
    
    self->registrationFactory->SetTransform(RegistrationFactoryType::VersorRigid3DTransform);
    //    self->registrationFactory->SetTransform(RegistrationFactoryType::AffineTransform); 
    
    self->registrationFactory->SetMetric(RegistrationFactoryType::MeanSquareMetric);
    //    self->registrationFactory->SetMetric(RegistrationFactoryType::NormalizedCorrelationMetric); // very runtime inefficient
    //    self->registrationFactory->SetMetric(RegistrationFactoryType::MutualInformationHistogramMetric); // even more runtime inefficient
    self->registrationFactory->SetInterpolator(RegistrationFactoryType::LinearInterpolator);
    self->registrationFactory->SetOptimizer(RegistrationFactoryType::RegularStepGradientDescentOptimizer);    
    
    self->registrationFactory->UserOptions.PREALIGN = false; //true;
    self->registrationFactory->UserOptions.PREALIGNPRECISION = 7;
    
    self->registrationFactory->UserOptions.CoarseFactor = 1;
    self->registrationFactory->UserOptions.BSplineBound = 15.0f;
    self->registrationFactory->UserOptions.NumberOfIterations = 3; // Default values: 1. run 500, 2. run 500, 3. run 100
    self->registrationFactory->UserOptions.NumberOfBins = 50;
    self->registrationFactory->UserOptions.PixelDensity = 0;
    self->registrationFactory->UserOptions.BSplineGridSize = 6; // 5 or 6 are defaults, must not be lower than 5
    self->registrationFactory->UserOptions.ROTATIONSCALE = -1;
    self->registrationFactory->UserOptions.TRANSLATIONSCALE = -1;
    self->registrationFactory->UserOptions.PREALIGNPRECISION = 5;
    
    // TODO: remove
    if (verbose) {
        registrationFactory->UserOptions.SHOWITERATIONATSTEP = 1;
        registrationFactory->UserOptions.PRINTRESULTS = true;
    } else {
        registrationFactory->UserOptions.SHOWITERATIONATSTEP = 10;
        registrationFactory->UserOptions.PRINTRESULTS = false;
    }
    // remove END
    
    self->registrationFactory->UserOptions.NumberOfThreads = 1;
    self->registrationFactory->UserOptions.MattesMutualInitializeSeed = 1;
    
    // Convert data elements to ITK images.
    ITKImage::Pointer refITKImg = [ref asITKImage];
    ITKImage::Pointer toAlignITKImg = [toAlign asITKImage];
    self->registrationFactory->SetFixedImage(refITKImg);
    self->registrationFactory->SetMovingImage(toAlignITKImg);
    
    // Causes unit tests/ITK to crash if the MattesMutualInformationMetric is used
    self->registrationFactory->StartRegistration();
    
//    return registrationFactory->GetTransform();
    return registrationFactory->GetTransformVectorField();
}

-(EDDataElement*)transform:(EDDataElement*)toAlign 
             withReference:(EDDataElement*)ref 
//            transformation:(const itk::TransformBase*)trans 
            transformation:(DeformationFieldType::Pointer)trans
                resolution:(std::vector<size_t>)res
            functionalData:(BOOL)fmri
{
    self->resampler->SetNumberOfThreads(NR_THREADS);
    self->warper->SetNumberOfThreads(NR_THREADS);

    ITKImage::Pointer inputImage = ITKImage::New();
    ITKImage::Pointer templateImage = ITKImage::New();
    ITKImage4D::Pointer fmriImage = ITKImage4D::New();

    templateImage = [ref asITKImage];
    
    ITKImage::SizeType    outputSize;
    ITKImage::SpacingType outputSpacing;
    ITKImage::SizeType fmriOutputSize;
	ITKImage::SpacingType fmriOutputSpacing;
    
    //setting up the output resolution
	if (res.size() > 0) {
		if (static_cast<unsigned int> (res.size()) < IMAGE_DIMENSION) {
			//user has specified less than 3 resolution values->sets isotrop resolution with the first typed value
			outputSpacing.Fill(res[0]);
		}
        
		if (res.size() >= 3 ) {
			//user has specified at least 3 values -> sets anisotrop resolution
			for (unsigned int i = 0; i < 3; i++) {
				outputSpacing[i] = res[i];
			}
		}
	} else {
		if (ref == nil) {
			outputSpacing = inputImage->GetSpacing();
			outputSize = inputImage->GetLargestPossibleRegion().GetSize();
		} else {
            outputSpacing = templateImage->GetSpacing();
			outputSize = templateImage->GetLargestPossibleRegion().GetSize();
        }
	}

    
	if (fmri) {
		fmriImage  = [toAlign asITKImage4D];
	} else {
		inputImage = [toAlign asITKImage];
    }
    
    ITKImage::PointType outputOrigin;
	ITKImage::DirectionType outputDirection;
    
    if (ref == nil) {
		outputDirection = inputImage->GetDirection();
		outputOrigin = inputImage->GetOrigin();
	} else {
		outputDirection = templateImage->GetDirection();
		outputOrigin = templateImage->GetOrigin();
	}
    
    if (res.size()) {
        if (ref != nil) {
            for (size_t i = 0; i < 3; i++) {
                //output spacing = (template size / output resolution) * template resolution
                outputSize[i] = (templateImage->GetLargestPossibleRegion().GetSize()[i] / outputSpacing[i]) * templateImage->GetSpacing()[i];
            }
        } else {
            for (size_t i = 0; i < 3; i++ ) {
                //output spacing = (moving size / output resolution) * moving resolution
                if (fmri) {
                    outputSize[i] = (fmriImage->GetLargestPossibleRegion().GetSize()[i] / outputSpacing[i]) * fmriImage->GetSpacing()[i];
                } else {
                    outputSize[i] = (inputImage->GetLargestPossibleRegion().GetSize()[i] / outputSpacing[i]) * inputImage->GetSpacing()[i];
                }
            }
        }
	}
    
    //setting up the interpolator
    // TODO: make configurable
    self->resampler->SetInterpolator(linearInterpolator);
    self->warper->SetInterpolator(linearInterpolator);
//    self->resampler->SetInterpolator(bsplineInterpolator);
//    self->warper->SetInterpolator(bsplineInterpolator);
//    self->resampler->SetInterpolator(nearestNeighborInterpolator);
//    self->warper->SetInterpolator(nearestNeighborInterpolator);
    
    ITKImage::PointType fmriOutputOrigin;
    ITKImage::DirectionType fmriOutputDirection;
    
    isis::adapter::itkAdapter* adapter = new isis::adapter::itkAdapter;
    std::list<isis::data::Image> imgList;
    enum ImageType imgType = IMAGE_UNKNOWN;
    
	if (fmri) {
        TimeStepExtractionFilterType::Pointer timeStepExtractionFilter = TimeStepExtractionFilterType::New();
		timeStepExtractionFilter->SetInput(fmriImage);
        
//		if (template_filename) {
			fmriOutputOrigin = templateImage->GetOrigin();
			fmriOutputDirection = templateImage->GetDirection();
//		}
        
		for ( unsigned int i = 0; i < 4; i++ ) {
			if (res.size()) {
				fmriOutputSpacing[i] = outputSpacing[i];
				fmriOutputSize[i] = outputSize[i];
			} else {
				if (ref == nil) {
					fmriOutputSpacing[i] = fmriImage->GetSpacing()[i];
					fmriOutputSize[i] = fmriImage->GetLargestPossibleRegion().GetSize()[i];
				} else {
					fmriOutputSpacing[i] = templateImage->GetSpacing()[i];
					fmriOutputSize[i] = templateImage->GetLargestPossibleRegion().GetSize()[i];
				}
			}
            
			if (ref == nil) {
				fmriOutputOrigin[i] = fmriImage->GetOrigin()[i];
                
				for ( unsigned int j = 0; j < 3; j++ ) {
					fmriOutputDirection[j][i] = fmriImage->GetDirection()[j][i];
				}
			}
		}
        
		if (fmriOutputSpacing[3] == 0) 
            fmriOutputSpacing[3] = 1; 
        
		if (trans.IsNotNull()) {
			self->warper->SetOutputDirection(fmriOutputDirection);
			self->warper->SetOutputOrigin(fmriOutputOrigin);
			self->warper->SetOutputSize(fmriOutputSize);
			self->warper->SetOutputSpacing(fmriOutputSpacing);
			self->warper->SetInput(inputImage);
            self->warper->SetDeformationField(trans);
		}
        
		itk::FixedArray<unsigned int, 4> layout;
		layout[0] = 1;
		layout[1] = 1;
		layout[2] = 1;
		layout[3] = 0;
		const unsigned int numberOfTimeSteps = fmriImage->GetLargestPossibleRegion().GetSize()[3];
		ITKImage::Pointer tileImage;
		std::cout << std::endl;
		inputImage = [toAlign asITKImage];
		ITKImage4D::DirectionType direction4D;
        
		for ( size_t i = 0; i < 3; i++ ) {
			for ( size_t j = 0; j < 3; j++ ) {
				direction4D[i][j] = fmriOutputDirection[i][j];
			}
		}
        
		direction4D[3][3] = 1;
        
        ITKImage::Pointer tmpImage = ITKImage::New();
        TileImageFilterType::Pointer tileImageFilter = TileImageFilterType::New();
        
		for (unsigned int timestep = 0; timestep < numberOfTimeSteps; timestep++) {
			std::cout << "Resampling timestep: " << timestep << "...\r" << std::flush;
			timeStepExtractionFilter->SetRequestedTimeStep(timestep);
			timeStepExtractionFilter->Update();
			tmpImage = timeStepExtractionFilter->GetOutput();
			tmpImage->SetDirection(inputImage->GetDirection());
			tmpImage->SetOrigin(inputImage->GetOrigin());
            
			if (trans.IsNotNull()) {
				warper->SetInput(tmpImage);
				warper->Update();
				tileImage = warper->GetOutput();
			}
            
			tileImage->Update();
			tileImage->DisconnectPipeline();
			tileImageFilter->PushBackInput(tileImage);
		}
        
		tileImageFilter->SetLayout(layout);
		tileImageFilter->GetOutput()->SetDirection(direction4D);
		tileImageFilter->Update();
		
        imgList = adapter->makeIsisImageObject<ITKImage4D>(tileImageFilter->GetOutput());
        imgType = IMAGE_FCTDATA;

	} else {
        // No fmri
//		if ( vtrans_filename or trans_filename.number > 1 && !identity ) {
        if (trans.IsNotNull()) {
			self->warper->SetOutputDirection(outputDirection);
			self->warper->SetOutputOrigin(outputOrigin);
			self->warper->SetOutputSize(outputSize);
			self->warper->SetOutputSpacing(outputSpacing);
			self->warper->SetInput(inputImage);
            
            self->warper->SetDeformationField(trans);
			            
			self->warper->Update();
            
            ITKImage::Pointer output = warper->GetOutput();
            
//            typedef itk::ImageFileWriter<ITKImage> ITKWriter;
//            ITKWriter::Pointer imageWriter = ITKWriter::New();
//            imageWriter->SetFileName("/tmp/RORegistrationTestImage.nii");
//            imageWriter->SetInput(output);
//            imageWriter->Update();

            NSLog(@"### START Converting ITK2Isis");
			imgList = adapter->makeIsisImageObject<ITKImage>(output);
            NSLog(@"### END Converting ITK2Isis");
            imgType = IMAGE_ANADATA;
		}
    }
    
//    isis::data::IOFactory::write( imgList, "/tmp/RORegIsisFix.nii", "", "" );
    
    EDDataElement* resultImg = nil;
    if (imgList.size() > 0) {
        resultImg = [[[EDDataElementIsis alloc] initFromImage:imgList.front() ofImageType:imgType] autorelease];
    }
    
    return resultImg;
}

@end
