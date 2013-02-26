//
//  RORegistrationVnormdata.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RORegistrationMethod.h"

#import "ROTypedef.h"



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



// # Utility classes and enums #####

//#ifdef cplusplus

/** 
 * Wrapper class to simulate either one of two return types
 * of the transform function.
 */
struct ITKImageContainer
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

//#endif

enum ETransform {
    VersorRigid3DTransform = 0,
    AffineTransform,
    BSplineTransform,
    TranslationTransform
};

enum EOptimizer {
    RegularStepGradientDescentOptimizer = 0,
    VersorRigidOptimizer,
    LBFGSBOptimizer,
    AmoebaOptimizer,
    PowellOptimizer
};



// # Public interface #####

/**
 * Registration workflow like Lipsia's vnormdata script.
 *
 * 1. Registrate anatomical data to functional data
 *    ana2fun
 * 2. Registrate the aligned anatomy to the reference space (MNI)
 *    (ana2fun)2mni
 * 3. Apply the last transformation (ana2fun2mni) to the original functional data
 *    fun2mni
 */
@interface RORegistrationVnormdata : RORegistrationMethod {

    @protected
    /** ITKImage representing the anatomy. */
    ITKImage::Pointer m_anaITK;
    /** ITKImage representing the anatomical reference. */
    ITKImage::Pointer m_refITK;
    
    /** Transformation from functional to normalized space. */
    DeformationFieldType::Pointer m_transformation;
    
    @private    
    RegistrationFactoryType::Pointer registrationFactory;
    /** Holds the transformation information gathered during init. */
    const itk::TransformBase* tmpConstTransformPointer;
    
    LinearInterpolatorType::Pointer linearInterpolator;
    BSplineInterpolatorType::Pointer bsplineInterpolator;
	NearestNeighborInterpolatorType::Pointer nearestNeighborInterpolator;
    
}

@end



@interface RORegistrationVnormdata (lipsiaFunctions)
    
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
