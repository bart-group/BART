//
//  RORegistration.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#include <assert.h>

#import "RORegistration.h"

#import "EDDataElement.h"
#import "EDDataElementIsis.h"

// ITK
//#import <itkImageFileWriter.h>

// Isis
#import "DataStorage/image.hpp"
#import "Adapter/itkAdapter.hpp"



// # Constants #####

const int NR_THREADS = 16; //8; //4;

const float SMOOTH_FWHM = 1.0f; // in valign3d: defined as 2.0 and overwritten as 1.0 by vnormdata cmdline args
const float PIXEL_DENSITY_DEFAULT = 1.0f; // 0.012f; // 1.0f;
const short GRID_SIZE_MINIMUM = 5;
const short NITERATION_DEFAULT = 500; // 500
const short N_BINS_DEFAULT = 50;
const float COARSE_FACTOR_DEFAULT = 1.0f;
const float BSPLINE_BOUND_DEFAULT = 15.0f;
const float ROTATION_SCALE_DEFAULT = -1.0f;
const float TRANSLATION_SCALE_DEFAULT = -1.0f;
const short PREALIGN_PRECISION_DEFAULT = 5;

const unsigned int MATTES_MUTUAL_SEED = 1;

const bool VERBOSE = false;

const unsigned int SHOW_ITERATION_STEP_DEFAULT = 10;
const unsigned int SHOW_ITERATION_STEP_VERBOSE = 1;





// # Utility classes #####

/** 
 * Wrapper class to simulate either one of two return types
 * of the transform function.
 */
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



// # Enums ###

enum ETransform {
    VersorRigid3DTransform = 0,
    AffineTransform,
    BSplineDeformableTransform,
    TranslationTransform
};

enum EOptimizer {
    RegularStepGradientDescentOptimizer = 0,
    VersorRigidOptimizer,
    LBFGSBOptimizer,
    AmoebaOptimizer,
    PowellOptimizer
};



// # Private interface extension #####

@interface RORegistration (privateMethods)

/**
 * Reduced version of Lipsia's valign3d:
 * Aligns a moving image to a fixed reference image.
 * Yields the deformation field describing the transformation.
 *
 * \param toAlign   The image that should be aligned on ref (moving image)
 * \param ref       The image on which toAlign is aligned (fixed image)
 * \param transform Vector of transformation algorithms that should be used.
 *                  Size of this vector determines the number repetitions.
 *                  Do not confuse these with the number of iterations!
 *                  The total number of registration steps is:
 *                  #repetitons * #iterations
 *                  If an empty vector is passed the default transformation
 *                  VersorRigid3DTransform is used.
 * \param optimizer Vector of optimizer algorithms. Used pair-wise with
 *                  the passed transformation methods provided by transform
 *                  (1st repetition: 1st transform + 1st optimizer etc.)
 *                  The used optimizer should suit the used transformation
 *                  in each repetition!
 * \param prealign  Flag whether prealign should be performed
 * \param smooth    Smoothing value. Smoothing is only applied if this
 *                  parameter is greater than 0.0f !
 *
 * \return          Deformation field scribing the transformation from
 *                  toAlign to ref.
 */
-(DeformationFieldType::Pointer)computeTransform:(ITKImage::Pointer)toAlign 
                                   withReference:(ITKImage::Pointer)ref
                                  transformTypes:(std::vector<ETransform>)transform
                                  optimizerTypes:(std::vector<EOptimizer>)optimizer
                                        prealign:(BOOL)prealign
                                          smooth:(const float)smooth;

// TODO: use ITKImageContainer for toAlign/toAlignFun!

/**
 * Reduced version of Lipsia's vdotrans3d:
 * Applies a transformation determined by computeTransform()
 *
 * \param toAlign    The 3D image that should be transformed (moving image).
 *                   Should be NULL, if toAlignFun is used!
 * \param toAlignFun The 4D image that should be transformed (moving image).
 *                   Should be NULL, if toAlign is used!
 * \param ref        The fixed image on which either toAlign or toAlignFun 
 *                   was aligned .
 * \param trans      Deformation field that should be applied to either
 *                   toAlign or toAlignFun
 *
 * \return           ITKImageContainer containing either a 3D or 4D ITKImage
 *                   depending on whether toAlign or toAlignFun was used.
 */
-(ITKImageContainer*)transform:(ITKImage::Pointer)toAlign
                  orFunctional:(ITKImage4D::Pointer)toAlignFun
                 withReference:(ITKImage::Pointer)ref 
                transformation:(DeformationFieldType::Pointer)trans 
                    resolution:(std::vector<size_t>)res; 

@end



// # Public interface implementation #####

@implementation RORegistration

-(id)init
{
    if (self = [super init]) {
        // From align3d
        self->registrationFactory = RegistrationFactoryType::New();
        self->tmpConstTransformPointer = NULL;
        
//        isis::data::enable_log<isis::util::DefaultMsgPrint>(isis::info);
    }
    
    return self;    
}


-(id)initFindingTransformFrom:(EDDataElement*)toAlign 
                  toReference:(EDDataElement*)ref
{
    if (self = [self init]) {
//        self->v = [self computeTransform:toAlign withReference:ref];
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
    
    std::vector<ETransform> transformTypes;
    std::vector<EOptimizer> optimizerTypes;
    DeformationFieldType::Pointer trans_ana2fun = [self computeTransform:anaITK 
                                                           withReference:funITK3D
                                                          transformTypes:transformTypes
                                                          optimizerTypes:optimizerTypes 
                                                                prealign:YES
                                                                  smooth:SMOOTH_FWHM];
    
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
        
        // TODO: check whether back conversion is really necessary
//        EDDataElement* ana2funBackconv = [ana convertFromITKImage:ana2fun];
//        [ana2funBackconv WriteDataElementToFile:@"/tmp/BARTReg_ana2fun.nii"];
//        ana2fun = [ana2funBackconv asITKImage];
        // TODO END

        transformTypes.push_back(VersorRigid3DTransform);
        transformTypes.push_back(AffineTransform);
        transformTypes.push_back(BSplineDeformableTransform);
        
        optimizerTypes.push_back(RegularStepGradientDescentOptimizer);
        optimizerTypes.push_back(RegularStepGradientDescentOptimizer);
        optimizerTypes.push_back(LBFGSBOptimizer);

        DeformationFieldType::Pointer trans_ana2ref = [self computeTransform:ana2fun 
                                                               withReference:refITK 
                                                              transformTypes:transformTypes
                                                              optimizerTypes:optimizerTypes 
                                                                    prealign:YES
                                                                      smooth:SMOOTH_FWHM];
        
        reso.clear();
        reso.push_back(3);
        
        transformResult = [self transform:NULL
                             orFunctional:funITK4D
                            withReference:refITK 
                           transformation:trans_ana2ref 
                               resolution:reso];
        
        if (transformResult != NULL) {
            ITKImage4D::Pointer ana2fun2mni = transformResult->getImg4D();
            free(transformResult);
            return [fun convertFromITKImage4D:ana2fun2mni];
        }

    }
    
    return nil;
}

-(EDDataElement*)bartRegistration:(EDDataElement*)fun
                          anatomy:(EDDataElement*)ana
              anatomicalReference:(EDDataElement*)ref 
{
    ITKImage::Pointer   funITK3D = [fun asITKImage];
    ITKImage4D::Pointer funITK4D = [fun asITKImage4D];
    ITKImage::Pointer anaITK = [ana asITKImage];
    ITKImage::Pointer refITK = [ref asITKImage];
    
    std::vector<ETransform> transformTypes;
    std::vector<EOptimizer> optimizerTypes;
    DeformationFieldType::Pointer trans_fun2ana = [self computeTransform:funITK3D 
                                                           withReference:anaITK
                                                          transformTypes:transformTypes
                                                          optimizerTypes:optimizerTypes 
                                                                prealign:YES
                                                                  smooth:SMOOTH_FWHM];
    
    std::vector<size_t> reso;
    reso.push_back(1);
    ITKImageContainer* transformResult = [self transform:NULL
                                            orFunctional:funITK4D
                                           withReference:anaITK
                                          transformation:trans_fun2ana 
                                              resolution:reso];
    
    
    if (transformResult != NULL) {
        ITKImage4D::Pointer fun2ana = transformResult->getImg4D();
        free(transformResult);
        
//        return [fun convertFromITKImage:fun2ana];
        
        transformTypes.push_back(VersorRigid3DTransform);
        transformTypes.push_back(AffineTransform);
        transformTypes.push_back(BSplineDeformableTransform);
        
        optimizerTypes.push_back(RegularStepGradientDescentOptimizer);
        optimizerTypes.push_back(RegularStepGradientDescentOptimizer);
        optimizerTypes.push_back(LBFGSBOptimizer);
        
        DeformationFieldType::Pointer trans_ana2ref = [self computeTransform:anaITK
                                                               withReference:refITK 
                                                              transformTypes:transformTypes
                                                              optimizerTypes:optimizerTypes 
                                                                    prealign:YES
                                                                      smooth:SMOOTH_FWHM];
        
        reso.clear();
        reso.push_back(3);
        
        transformResult = [self transform:NULL
                             orFunctional:fun2ana
                            withReference:refITK
                           transformation:trans_ana2ref 
                               resolution:reso];
        
        if (transformResult != NULL) {
            ITKImage4D::Pointer fun2ana2mni = transformResult->getImg4D();
            free(transformResult);
            return [fun convertFromITKImage4D:fun2ana2mni];
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



// # Private interface implementation #####

@implementation RORegistration (privateMethods)

-(DeformationFieldType::Pointer)computeTransform:(ITKImage::Pointer)toAlign 
                                   withReference:(ITKImage::Pointer)ref
                                  transformTypes:(std::vector<ETransform>)transforms
                                  optimizerTypes:(std::vector<EOptimizer>)optimizers
                                        prealign:(BOOL)prealign
                                          smooth:(const float)smooth
{
    self->registrationFactory->Reset();
    
    // Convert data elements to ITK images.
    // ### TODO: redundant
    ITKImage::Pointer fixedImage = ref;
    ITKImage::Pointer movingImage = toAlign;
    
    if ( smooth > 0.0f ) {
		GaussianFilterType::Pointer fixedGaussianFilterX = GaussianFilterType::New();
		GaussianFilterType::Pointer fixedGaussianFilterY = GaussianFilterType::New();
		GaussianFilterType::Pointer fixedGaussianFilterZ = GaussianFilterType::New();
		fixedGaussianFilterX->SetNumberOfThreads( NR_THREADS );
		fixedGaussianFilterY->SetNumberOfThreads( NR_THREADS );
		fixedGaussianFilterZ->SetNumberOfThreads( NR_THREADS );
		fixedGaussianFilterX->SetInput( fixedImage );
		fixedGaussianFilterY->SetInput( fixedGaussianFilterX->GetOutput() );
		fixedGaussianFilterZ->SetInput( fixedGaussianFilterY->GetOutput() );
		fixedGaussianFilterX->SetDirection( 0 );
		fixedGaussianFilterY->SetDirection( 1 );
		fixedGaussianFilterZ->SetDirection( 2 );
		fixedGaussianFilterX->SetOrder( GaussianFilterType::ZeroOrder );
		fixedGaussianFilterY->SetOrder( GaussianFilterType::ZeroOrder );
		fixedGaussianFilterZ->SetOrder( GaussianFilterType::ZeroOrder );
		fixedGaussianFilterX->SetNormalizeAcrossScale( false );
		fixedGaussianFilterY->SetNormalizeAcrossScale( false );
		fixedGaussianFilterZ->SetNormalizeAcrossScale( false );
		fixedGaussianFilterX->SetSigma( smooth );
		fixedGaussianFilterY->SetSigma( smooth );
		fixedGaussianFilterZ->SetSigma( smooth );
		std::cout << "smoothing the fixed image..." << std::endl;
		fixedGaussianFilterZ->Update();
		fixedImage->DisconnectPipeline();
		fixedImage = fixedGaussianFilterZ->GetOutput();
		GaussianFilterType::Pointer movingGaussianFilterX = GaussianFilterType::New();
		GaussianFilterType::Pointer movingGaussianFilterY = GaussianFilterType::New();
		GaussianFilterType::Pointer movingGaussianFilterZ = GaussianFilterType::New();
		movingGaussianFilterX->SetNumberOfThreads( NR_THREADS );
		movingGaussianFilterY->SetNumberOfThreads( NR_THREADS );
		movingGaussianFilterZ->SetNumberOfThreads( NR_THREADS );
		movingGaussianFilterX->SetInput( movingImage );
		movingGaussianFilterY->SetInput( movingGaussianFilterX->GetOutput() );
		movingGaussianFilterZ->SetInput( movingGaussianFilterY->GetOutput() );
		movingGaussianFilterX->SetDirection( 0 );
		movingGaussianFilterY->SetDirection( 1 );
		movingGaussianFilterZ->SetDirection( 2 );
		movingGaussianFilterX->SetOrder( GaussianFilterType::ZeroOrder );
		movingGaussianFilterY->SetOrder( GaussianFilterType::ZeroOrder );
		movingGaussianFilterZ->SetOrder( GaussianFilterType::ZeroOrder );
		movingGaussianFilterX->SetNormalizeAcrossScale( false );
		movingGaussianFilterY->SetNormalizeAcrossScale( false );
		movingGaussianFilterZ->SetNormalizeAcrossScale( false );
		movingGaussianFilterX->SetSigma( smooth );
		movingGaussianFilterY->SetSigma( smooth );
		movingGaussianFilterZ->SetSigma( smooth );
		std::cout << "smoothing the moving image..." << std::endl;
		movingGaussianFilterZ->Update();
		movingImage->DisconnectPipeline();
		movingImage = movingGaussianFilterZ->GetOutput();
	}

    
    
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
	unsigned long repetition = transforms.size(); // = transformType.number
    
	if (repetition == 0) {
		repetition = 1;
    }
    
    std::vector<int>   metrics;
    std::vector<short> interpolators;
    std::vector<int>   iterations;
    std::vector<short> gridSizes;
    
    enum ETransform transform = static_cast<ETransform>( 0 );
    enum EOptimizer optimizer = static_cast<EOptimizer>( 0 );
    short metric       = 0;
    short interpolator = 0;
    short niteration   = NITERATION_DEFAULT;
    short gridSize     = GRID_SIZE_MINIMUM + 1;
    
    // from isisreg3d.cxx:
//    //if no pixel density is specified it will be calculated to achieve a amount of 30000 voxel considered for registration
//	float pixelDens = float( 150000 ) / ( refList.front().getSizeAsVector()[0] * refList.front().getSizeAsVector()[1] * refList.front().getSizeAsVector()[2] ) ;
//	if(pixelDens > 1) { pixelDens=1;}
    
    //now, our version:
    ITKImage::SizeType imSize = fixedImage->GetLargestPossibleRegion().GetSize(); 
    
    float pixelDensity =  150000.0f  / ( static_cast<float>( imSize[0] * imSize[1] * imSize[2] )) ;
    if (pixelDensity <= 0 or pixelDensity > 1) {
        pixelDensity = PIXEL_DENSITY_DEFAULT;
    }

    unsigned long bsplineCounter = 0;
    for (unsigned long counter = 0; counter < repetition; counter++ ) {
		//transform is the master for determining the number of repetitions
		if ( transforms.size() ) {
			transform = transforms[counter];
		}
        
		if (counter < optimizers.size()) {
			optimizer = optimizers[counter];
		} else if (counter >= optimizers.size() and optimizers.size() > 0 ) {
			optimizer = optimizers[optimizers.size() - 1];
		}
        
        metric = 0;
        interpolator = 0;
        niteration = NITERATION_DEFAULT;
        
		if (counter < metrics.size()) {
			metric = (short) metrics[counter];
		} else if (counter >= metrics.size() and metrics.size() > 0) {
			metric = (short) metrics[metrics.size() - 1];
		}
        
		if (counter < interpolators.size()) {
			interpolator = interpolators[counter];
		} else if (counter >= interpolators.size() and interpolators.size() > 0) {
			interpolator = interpolators[interpolators.size() - 1];
		}
        
		if (counter < iterations.size()) {
			niteration = (short) iterations[counter];
		} else if (counter >= iterations.size() and iterations.size() > 0) {
			niteration = (short) iterations[iterations.size() - 1];
		}
        
		if (bsplineCounter < gridSizes.size()) {
			gridSize = gridSizes[bsplineCounter];
		} else if (bsplineCounter >= gridSizes.size() and gridSizes.size() > 0) {
			gridSize = gridSizes[gridSizes.size() - 1];
		}
        
		if (transform == 2) {
			bsplineCounter++;
		}
		if( counter > 0) {
			registrationFactory->Reset();
		}
        
        // Check pixel density
		if (pixelDensity >= 1) {
			NSLog(@"metric uses all voxels");
		}
        
		//check grid size
		if (gridSize < GRID_SIZE_MINIMUM) {
			NSLog(@"Warning: grid size has to be at least %d! Setting grid size to %d!", GRID_SIZE_MINIMUM, GRID_SIZE_MINIMUM);
			gridSize = GRID_SIZE_MINIMUM;
		}
        
        if (transform     == BSplineDeformableTransform 
            and optimizer != 2) {
			NSLog(@"It is recommended using the BSpline transform in connection with the LBFGSB optimizer!");
		}
        
		if (transform     != VersorRigid3DTransform
//             and transform != 4) 
            and optimizer == VersorRigidOptimizer) {
			NSLog(@"Inappropriate combination of transform and optimizer! Setting optimizer to RegularStepGradientDescentOptimizer.");
			optimizer = RegularStepGradientDescentOptimizer;
		}
        
        
		if (VERBOSE) {
			NSLog(@"Setting up the registration object...");
			NSLog(@" used transform: %d", transform);
			NSLog(@" used metric: %d", metric);
			NSLog(@" used interpolator: %d", interpolator);
			NSLog(@" used optimizer: %d", optimizer);
		}
        
        //transform setup
        switch (transform) {
            case         0: self->registrationFactory->SetTransform( RegistrationFactoryType::VersorRigid3DTransform );
            break; case  1: self->registrationFactory->SetTransform( RegistrationFactoryType::AffineTransform );
            break; case  2: self->registrationFactory->SetTransform( RegistrationFactoryType::BSplineDeformableTransform );
            break; case  3: self->registrationFactory->SetTransform( RegistrationFactoryType::TranslationTransform );
            break; default: NSLog(@"Error: Unknown transform!");
                            return NULL;
		}
        
        //metric setup
		switch (metric) {
            case         0: self->registrationFactory->SetMetric( RegistrationFactoryType::MattesMutualInformationMetric );
            break; case  1: self->registrationFactory->SetMetric( RegistrationFactoryType::MutualInformationHistogramMetric );
            break; case  2: self->registrationFactory->SetMetric( RegistrationFactoryType::NormalizedCorrelationMetric );
            break; case  3: self->registrationFactory->SetMetric( RegistrationFactoryType::MeanSquareMetric );
            break; default: NSLog(@"Error: Unknown metric!");
                            return NULL;
		}
        
		//interpolator setup
		switch (interpolator) {
            case         0: self->registrationFactory->SetInterpolator( RegistrationFactoryType::LinearInterpolator );
            break; case  1: self->registrationFactory->SetInterpolator( RegistrationFactoryType::BSplineInterpolator );
            break; case  2: self->registrationFactory->SetInterpolator( RegistrationFactoryType::NearestNeighborInterpolator );
            break; default: NSLog(@"Error: Unknown interpolator!");
                            return NULL;
		}
        
		//optimizer setup
		switch (optimizer) {
            case         0: self->registrationFactory->SetOptimizer( RegistrationFactoryType::RegularStepGradientDescentOptimizer );
            break; case  1: self->registrationFactory->SetOptimizer( RegistrationFactoryType::VersorRigidOptimizer );
            break; case  2: self->registrationFactory->SetOptimizer( RegistrationFactoryType::LBFGSBOptimizer );
            break; case  3: self->registrationFactory->SetOptimizer( RegistrationFactoryType::AmoebaOptimizer );
            break; case  4: self->registrationFactory->SetOptimizer( RegistrationFactoryType::PowellOptimizer );
            break; default: NSLog(@"Unknown optimizer!");
                            return NULL;
		}

		if (prealign) {
			self->registrationFactory->UserOptions.PREALIGN          = true;
			self->registrationFactory->UserOptions.PREALIGNPRECISION = 7;
		}
        
		if (counter != 0) {
			self->registrationFactory->UserOptions.PREALIGN          = false;
			self->registrationFactory->SetInitialTransform( const_cast<TransformBasePointerType>(self->tmpConstTransformPointer) );
		}

//        if ( mask_filename ) {
//			maskReader->SetFileName( mask_filename );
//			maskReader->Update();
//			mask->SetImage( maskReader->GetOutput() );
//			mask->Update();
//			registrationFactory->SetFixedImageMask( mask );
//		}
//        
//		if ( pointset_filename ) {
//			registrationFactory->UserOptions.LANDMARKINITIALIZE = true;
//			std::ifstream pointSetFile;
//			pointSetFile.open( pointset_filename );
//            
//			if ( pointSetFile.fail() ) {
//				std::cout << "Pointset file " << pointset_filename << " not found!" << std::endl;
//				return EXIT_FAILURE;
//			}
//            
//			LandmarkBasedTransformInitializerType::LandmarkPointContainer fixedPointsContainer;
//			LandmarkBasedTransformInitializerType::LandmarkPointContainer movingPointsContainer;
//			LandmarkBasedTransformInitializerType::LandmarkPointType fixedPoint;
//			LandmarkBasedTransformInitializerType::LandmarkPointType movingPoint;
//			pointSetFile >> fixedPoint;
//			pointSetFile >> movingPoint;
//            
//			while ( !pointSetFile.eof() ) {
//				fixedPointsContainer.push_back( fixedPoint );
//				movingPointsContainer.push_back( movingPoint );
//				pointSetFile >> fixedPoint;
//				pointSetFile >> movingPoint;
//			}
//            
//			registrationFactory->SetFixedPointContainer( fixedPointsContainer );
//			registrationFactory->SetMovingPointContainer( movingPointsContainer );
//		}
        
        self->registrationFactory->UserOptions.CoarseFactor = COARSE_FACTOR_DEFAULT;
        self->registrationFactory->UserOptions.BSplineBound = BSPLINE_BOUND_DEFAULT;
        self->registrationFactory->UserOptions.NumberOfIterations = niteration; // Default values: 1. run 500, 2. run 500, 3. run 100
        self->registrationFactory->UserOptions.NumberOfBins = N_BINS_DEFAULT;
        self->registrationFactory->UserOptions.PixelDensity = pixelDensity;
        self->registrationFactory->UserOptions.BSplineGridSize = gridSize;
        self->registrationFactory->UserOptions.ROTATIONSCALE = ROTATION_SCALE_DEFAULT;
        self->registrationFactory->UserOptions.TRANSLATIONSCALE = TRANSLATION_SCALE_DEFAULT;
        self->registrationFactory->UserOptions.PREALIGNPRECISION = PREALIGN_PRECISION_DEFAULT;
        
        // TODO: remove
        if (VERBOSE) {
            registrationFactory->UserOptions.SHOWITERATIONATSTEP = SHOW_ITERATION_STEP_VERBOSE;
            registrationFactory->UserOptions.PRINTRESULTS = true;
        } else {
            registrationFactory->UserOptions.SHOWITERATIONATSTEP = SHOW_ITERATION_STEP_DEFAULT;
            registrationFactory->UserOptions.PRINTRESULTS = false;
        }
        // remove END
//        registrationFactory->UserOptions.PRINTRESULTS = false;
        
        self->registrationFactory->UserOptions.NumberOfThreads = NR_THREADS;
        self->registrationFactory->UserOptions.MattesMutualInitializeSeed = MATTES_MUTUAL_SEED;
    
        self->registrationFactory->SetFixedImage(fixedImage);
        self->registrationFactory->SetMovingImage(movingImage);

		self->registrationFactory->StartRegistration();
        
//        if (!use_inverse) {
        self->tmpConstTransformPointer = self->registrationFactory->GetTransform();
//        }
    }
    
//    return registrationFactory->GetTransform();    
    
    return registrationFactory->GetTransformVectorField();
}

-(ITKImageContainer*)transform:(ITKImage::Pointer)toAlign
                  orFunctional:(ITKImage4D::Pointer)toAlignFun
                 withReference:(ITKImage::Pointer)ref 
                transformation:(DeformationFieldType::Pointer)trans 
                    resolution:(std::vector<size_t>)res; 
{
//    if (toAlignFun.IsNotNull()) {
//        ITKImage4D::PointType toAlignFunOrigin = toAlignFun->GetOrigin();
//        std::cout << "Functional origin:" << std::endl;
//        std::cout << toAlignFunOrigin << std::endl;
//        
//        ITKImage4D::DirectionType toAlignFunDirection = toAlignFun->GetDirection();
//        std::cout << "Functional direction matrix:" << std::endl;
//        std::cout << toAlignFunDirection << std::endl;
//    }
//    if (toAlign.IsNotNull()) {
//        ITKImage::PointType toAlignOrigin = toAlign->GetOrigin();
//        std::cout << "3D origin:" << std::endl;
//        std::cout << toAlignOrigin << std::endl;
//        
//        ITKImage::DirectionType toAlignDirection = toAlign->GetDirection();
//        std::cout << "3D direction matrix:" << std::endl;
//        std::cout << toAlignDirection << std::endl;
//    }
    
    // From dotrans3d
    ResampleImageFilterType::Pointer resampler = ResampleImageFilterType::New();
    WarpImageFilterType::Pointer     warper    = WarpImageFilterType::New();
    
    self->linearInterpolator = LinearInterpolatorType::New();
    self->bsplineInterpolator = BSplineInterpolatorType::New();
    self->nearestNeighborInterpolator = NearestNeighborInterpolatorType::New();
        
    resampler->SetNumberOfThreads(NR_THREADS);
    warper->SetNumberOfThreads(NR_THREADS);

    ITKImage::Pointer   inputImage    = ITKImage::New();
    ITKImage::Pointer   templateImage = ref;
    ITKImage4D::Pointer fmriImage     = ITKImage4D::New();
    
    ITKImage::SizeType    outputSize;
    ITKImage::SpacingType outputSpacing;
    
    ITKImage::SizeType    fmriOutputSize;
	ITKImage::SpacingType fmriOutputSpacing;
    
    //setting up the output resolution
	if (res.size() > 0) {
		if (static_cast<unsigned int> (res.size()) < IMAGE_DIMENSION) {
			//user has specified less than 3 resolution values->sets isotrop resolution with the first typed value
			outputSpacing.Fill( static_cast<float>( res[0] ) );
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
			outputSize    = inputImage->GetLargestPossibleRegion().GetSize();
		} else {
            outputSpacing = templateImage->GetSpacing();
			outputSize    = templateImage->GetLargestPossibleRegion().GetSize();
        }
	}
    
	if (toAlignFun.IsNotNull()) {
		fmriImage  = toAlignFun;
	} 
    if (toAlign.IsNotNull()) {
		inputImage = toAlign;
    }
    
    ITKImage::PointType     outputOrigin;
	ITKImage::DirectionType outputDirection;
    
    if (ref.IsNull()) {
		outputDirection = inputImage->GetDirection();
		outputOrigin    = inputImage->GetOrigin();
	} else {
		outputDirection = templateImage->GetDirection();
		outputOrigin    = templateImage->GetOrigin();
	}
    
    if (res.size() > 0) {
        if (ref.IsNotNull()) {
            for (long i = 0; i < 3; i++) {
                //output spacing = (template size / output resolution) * template resolution
                outputSize[i] = (templateImage->GetLargestPossibleRegion().GetSize()[i] / outputSpacing[i]) * templateImage->GetSpacing()[i];
            }
        } 
        else {
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
    short interpolator_type = 0;
    switch (interpolator_type) {
        case 0:
            resampler->SetInterpolator( linearInterpolator );
            warper->SetInterpolator(    linearInterpolator );
            break;
        case 1:
            resampler->SetInterpolator( bsplineInterpolator );
            warper->SetInterpolator(    bsplineInterpolator );
            break;
        case 2:
            resampler->SetInterpolator( nearestNeighborInterpolator );
            warper->SetInterpolator(    nearestNeighborInterpolator );
            break;
	}
    
    ITKImage::PointType     fmriOutputOrigin;
    ITKImage::DirectionType fmriOutputDirection;
    
    ITKImageContainer* result = NULL;
    
	if (toAlignFun.IsNotNull()) {
        TimeStepExtractionFilterType::Pointer timeStepExtractionFilter = TimeStepExtractionFilterType::New();
		timeStepExtractionFilter->SetInput(fmriImage);
        
		if (ref.IsNotNull()) {
			fmriOutputOrigin    = templateImage->GetOrigin();
			fmriOutputDirection = templateImage->GetDirection();
		}
        
		for ( unsigned int i = 0; i < 3; i++ ) {
			if (res.size() > 0) {
				fmriOutputSpacing[i] = outputSpacing[i];
				fmriOutputSize[i]    = outputSize[i];
			} else {
				if (ref.IsNull()) {
					fmriOutputSpacing[i] = fmriImage->GetSpacing()[i];
					fmriOutputSize[i]    = fmriImage->GetLargestPossibleRegion().GetSize()[i];
				} else {
					fmriOutputSpacing[i] = templateImage->GetSpacing()[i];
					fmriOutputSize[i]    = templateImage->GetLargestPossibleRegion().GetSize()[i];
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
			warper->SetOutputDirection(fmriOutputDirection);
			warper->SetOutputOrigin(fmriOutputOrigin);
			warper->SetOutputSize(fmriOutputSize);
			warper->SetOutputSpacing(fmriOutputSpacing);
			warper->SetInput(inputImage);
            warper->SetDeformationField(trans);
		}
        
		itk::FixedArray<unsigned int, 4> layout;
		layout[0] = 1;
		layout[1] = 1;
		layout[2] = 1;
		layout[3] = 0;
		const unsigned long numberOfTimeSteps = fmriImage->GetLargestPossibleRegion().GetSize()[3];
        
		ITKImage::Pointer tileImage;
		std::cout << std::endl;
//		inputImage = ... <code using itkAdapter>
        
		ITKImage4D::DirectionType direction4D;
		for ( size_t i = 0; i < 3; i++ ) {
			for ( size_t j = 0; j < 3; j++ ) {
				direction4D[i][j] = fmriOutputDirection[i][j];
			}
		}
        
		direction4D[3][3] = 1;
        assert(direction4D[0][3] == 0);
        assert(direction4D[1][3] == 0);
        assert(direction4D[2][3] == 0);
        assert(direction4D[3][0] == 0);
        assert(direction4D[3][1] == 0);
        assert(direction4D[3][2] == 0);
        
        // Convert 4D Origin/Direction to 3D (no direct assignment possible due to ITK's templated design)
        ITKImage::PointType       inputImageOrigin;
        ITKImage::DirectionType   inputImageDirection;
        ITKImage4D::PointType     toAlignFunOrigin    = toAlignFun->GetOrigin();
        ITKImage4D::DirectionType toAlignFunDirection = toAlignFun->GetDirection();

        for (unsigned int i = 0; i < ITKImage::GetImageDimension(); i++) {
            inputImageOrigin[i] = toAlignFunOrigin[i];
            
            for (unsigned int j = 0; j < ITKImage::GetImageDimension(); j++) {
                inputImageDirection[i][j] = toAlignFunDirection[i][j];
            }
        }
        
        ITKImage::Pointer tmpImage = ITKImage::New();
        TileImageFilterType::Pointer tileImageFilter = TileImageFilterType::New();
        
//        std::cout << "inputImageOrigin" << std::endl;
//        std::cout << inputImageOrigin << std::endl;
//        std::cout << "inputImageDirection:" << std::endl;
//        std::cout << inputImageDirection << std::endl;
        
		for (unsigned int timestep = 0; timestep < numberOfTimeSteps; timestep++) {
			std::cout << "Resampling timestep: " << timestep << "...\r" << std::flush;
			timeStepExtractionFilter->SetRequestedTimeStep(timestep);
			timeStepExtractionFilter->Update();
			tmpImage = timeStepExtractionFilter->GetOutput();
			tmpImage->SetDirection(inputImageDirection);
			tmpImage->SetOrigin(inputImageOrigin);
            
			if (trans.IsNotNull()) {
				warper->SetInput(tmpImage);
				warper->Update();                      // Original lipsia function call
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
			warper->SetOutputDirection(outputDirection);
			warper->SetOutputOrigin(outputOrigin);
			warper->SetOutputSize(outputSize);
			warper->SetOutputSpacing(outputSpacing);
			warper->SetInput(inputImage);
            
            warper->SetDeformationField(trans);
			      
			warper->Update();
            
            ITKImage::Pointer output = warper->GetOutput();

//			resultImg = [toAlign convertFromITKImage:output];
            result = new ITKImageContainer(output);
		}
    }
    
    return result;
}

@end
