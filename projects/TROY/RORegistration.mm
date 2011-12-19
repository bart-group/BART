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

const int NR_THREADS = 1; //8; //4;

class ITKImageContainer
{
private:
    ITKImage::Pointer   img3D;
    ITKImage4D::Pointer img4D;
public:
    ITKImageContainer(ITKImage::Pointer   img3D) { this->img3D = img3D; this->img4D = NULL;  };
    ITKImageContainer(ITKImage4D::Pointer img4D) { this->img3D = NULL;  this->img4D = img4D; };
    ~ITKImageContainer() { };
    bool is3D() { if (this->img3D.IsNull()) { return false; } else { return true; } };
    bool is4D() { if (this->img4D.IsNull()) { return false; } else { return true; } };
    ITKImage::Pointer   getImg3D() { return this->img3D; };
    ITKImage4D::Pointer getImg4D() { return this->img4D; };
};

@interface RORegistration (privateMethods)

-(DeformationFieldType::Pointer)computeTransform:(ITKImage::Pointer)toAlign 
                                   withReference:(ITKImage::Pointer)ref
                                  transformTypes:(std::vector<int>)transform
                                  optimizerTypes:(std::vector<int>)optimizer
                                        prealign:(BOOL)prealign
                                          smooth:(BOOL)smooth;

-(ITKImageContainer*)transform:(ITKImage::Pointer)toAlign
                  orFunctional:(ITKImage4D::Pointer)toAlignFun
                 withReference:(ITKImage::Pointer)ref 
                transformation:(DeformationFieldType::Pointer)trans 
                    resolution:(std::vector<size_t>)res; 

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

-(EDDataElement*)normdata:(EDDataElement*)fun
                  anatomy:(EDDataElement*)ana
      anatomicalReference:(EDDataElement*)ref
{
    ITKImage::Pointer   funITK3D = [fun asITKImage];
    ITKImage4D::Pointer funITK4D = [fun asITKImage4D];
    ITKImage::Pointer anaITK = [ana asITKImage];
    ITKImage::Pointer refITK = [ref asITKImage];
    
    std::vector<int> transformTypes;
    std::vector<int> optimizerTypes;
    DeformationFieldType::Pointer trans_ana2fun = [self computeTransform:anaITK 
                                                           withReference:funITK3D
                                                          transformTypes:transformTypes
                                                          optimizerTypes:optimizerTypes 
                                                                prealign:YES 
                                                                  smooth:YES];
    
    std::vector<size_t> reso;
    reso.push_back(1);
    ITKImageContainer* transformResult = [self transform:anaITK
                                            orFunctional:NULL
                                           withReference:funITK3D
                                          transformation:trans_ana2fun 
                                              resolution:reso];
    if (transformResult != NULL) {
        ITKImage::Pointer ana2fun = transformResult->getImg3D();
        free(transformResult);
        
        transformTypes.push_back(0);
        transformTypes.push_back(1);
        transformTypes.push_back(2);
        optimizerTypes.push_back(0);
        optimizerTypes.push_back(0);
        optimizerTypes.push_back(2);
        DeformationFieldType::Pointer trans_ana2ref = [self computeTransform:ana2fun 
                                                               withReference:refITK 
                                                              transformTypes:transformTypes
                                                              optimizerTypes:optimizerTypes 
                                                                    prealign:YES 
                                                                      smooth:YES];
        
        reso.clear();
        reso.push_back(3);
        transformResult = [self transform:NULL
                             orFunctional:funITK4D
                            withReference:refITK 
                           transformation:trans_ana2ref 
                               resolution:reso];
        
        if (transformResult != NULL) {
            return [fun convertFromITKImage4D:transformResult->getImg4D()];
        }

    }
    
    return nil;
}

//-(EDDataElement*)align:(EDDataElement*)toAlign 
//       beingFunctional:(BOOL)fmri
//         withReference:(EDDataElement*)ref 
//{
//    if (toAlign == nil || ref == nil) {
//        // exception?
//        return nil;
//    }
//    
//    // TODO: replace with method: align :: EDDataElement -> EDDataElement
//    
//    DeformationFieldType::Pointer trans = [self computeTransform:toAlign 
//                                                   withReference:ref];
//    
//    std::vector<size_t> res;
//    res.push_back(1);
//    
//    NSLog(@"### FINISHED COMPUTING TRANSFORM, ALIGNING NOW ###");
//    
//    EDDataElement* transformed = [self transform:toAlign 
//                                   withReference:ref 
//                                  transformation:trans 
//                                      resolution:res 
//                                  functionalData:fmri];
//    
//    return transformed;
//}


-(RORegistration*)combineTransform:(RORegistration*)other
{
    return nil;
}

@end

@implementation RORegistration (privateMethods)

bool verbose = true;

-(DeformationFieldType::Pointer)computeTransform:(ITKImage::Pointer)toAlign 
                                   withReference:(ITKImage::Pointer)ref
                                  transformTypes:(std::vector<int>)transform
                                  optimizerTypes:(std::vector<int>)optimizer
                                        prealign:(BOOL)prealign
                                          smooth:(BOOL)smooth
{
    self->registrationFactory->Reset();
    
    // Convert data elements to ITK images.
    // ### TODO: redundant
    ITKImage::Pointer fixedImage = ref;
    ITKImage::Pointer movingImage = toAlign;
    
    // ### Lipsia Reinclude START
    MatchingFilterType::Pointer matcher = MatchingFilterType::New();    
    bool histogram_matching = true;
    if( histogram_matching ) {
		matcher->SetNumberOfThreads(NR_THREADS);
		matcher->SetNumberOfHistogramLevels(100);
		matcher->SetNumberOfMatchPoints(30);
		matcher->ThresholdAtMeanIntensityOn();
		matcher->SetReferenceImage(fixedImage);
		matcher->SetInput(movingImage);
		matcher->Update();
		movingImage->DisconnectPipeline();
		movingImage = matcher->GetOutput();
	}
    
    //analyse transform vector
	//transform is the master for determining the number of repetitions
	int repetition = transform.size(); // = transformType.number
	int bsplineCounter = 0;
    
	if ( repetition == 0 ) {
		repetition = 1;
    }

    
    
    
    // ### Lipsia Reinclude END
    
    

    
    
    
    
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
    
    self->registrationFactory->SetFixedImage(fixedImage);
    self->registrationFactory->SetMovingImage(movingImage);
    
    // Causes unit tests/ITK to crash if the MattesMutualInformationMetric is used
    self->registrationFactory->StartRegistration();
    
//    return registrationFactory->GetTransform();
    return registrationFactory->GetTransformVectorField();
}

-(ITKImageContainer*)transform:(ITKImage::Pointer)toAlign
                  orFunctional:(ITKImage4D::Pointer)toAlignFun
                 withReference:(ITKImage::Pointer)ref 
                transformation:(DeformationFieldType::Pointer)trans 
                    resolution:(std::vector<size_t>)res; 
{
    self->resampler->SetNumberOfThreads(NR_THREADS);
    self->warper->SetNumberOfThreads(NR_THREADS);

    ITKImage::Pointer inputImage = ITKImage::New();
    ITKImage::Pointer templateImage = ref;
    ITKImage4D::Pointer fmriImage = ITKImage4D::New();
    
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
		if (ref.IsNull()) {
			outputSpacing = inputImage->GetSpacing();
			outputSize = inputImage->GetLargestPossibleRegion().GetSize();
		} else {
            outputSpacing = templateImage->GetSpacing();
			outputSize = templateImage->GetLargestPossibleRegion().GetSize();
        }
	}

    
	if (toAlignFun.IsNotNull()) {
		fmriImage  = toAlignFun;
	} else {
		inputImage = toAlign;
    }
    
    ITKImage::PointType outputOrigin;
	ITKImage::DirectionType outputDirection;
    
    if (ref.IsNull()) {
		outputDirection = inputImage->GetDirection();
		outputOrigin = inputImage->GetOrigin();
	} else {
		outputDirection = templateImage->GetDirection();
		outputOrigin = templateImage->GetOrigin();
	}
    
    if (res.size()) {
        if (ref.IsNotNull()) {
            for (size_t i = 0; i < 3; i++) {
                //output spacing = (template size / output resolution) * template resolution
                outputSize[i] = (templateImage->GetLargestPossibleRegion().GetSize()[i] / outputSpacing[i]) * templateImage->GetSpacing()[i];
            }
        } else {
            for (size_t i = 0; i < 3; i++ ) {
                //output spacing = (moving size / output resolution) * moving resolution
                if (toAlignFun.IsNotNull()) {
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
    
    ITKImageContainer* result = NULL;
    
	if (toAlignFun.IsNotNull()) {
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
				if (ref.IsNull()) {
					fmriOutputSpacing[i] = fmriImage->GetSpacing()[i];
					fmriOutputSize[i] = fmriImage->GetLargestPossibleRegion().GetSize()[i];
				} else {
					fmriOutputSpacing[i] = templateImage->GetSpacing()[i];
					fmriOutputSize[i] = templateImage->GetLargestPossibleRegion().GetSize()[i];
				}
			}
            
			if (ref.IsNull()) {
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
		inputImage = toAlign;
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
		
//        resultImg = [toAlign convertFromITKImage4D:tileImageFilter->GetOutput()];
        result = new ITKImageContainer(tileImageFilter->GetOutput());

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

//            NSLog(@"### START Converting ITK2Isis");
//			resultImg = [toAlign convertFromITKImage:output];
            result = new ITKImageContainer(output);
//            NSLog(@"### END Converting ITK2Isis");
		}
    }
    
//    isis::data::IOFactory::write( imgList, "/tmp/RORegIsisFix.nii", "", "" );
    
    return result;
}

@end
