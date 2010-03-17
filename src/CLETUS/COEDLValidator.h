//
//  COEDLValidator.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/**
 * Object used for validation of an EDL file against an EDL rule file.
 * 
 */
@interface COEDLValidator: NSObject {
    
    /**
     * fMRI experiment configuration in EDL.
     */
    NSXMLDocument* mEDLdoc;
    
    /**
     * Ruleset that identifies functional dependencies between
     * configuration entries (as XML tree).
     */
    NSXMLDocument* mEDLRules;
    
    /**
     * All EDL rules extracted from the XML tree in mEDLRules.
     * Array of COEDLValidatorRule objects.
     */
    NSMutableArray* mRules;
    
    /**
     * Error object for initialization and validation.
     */
    NSError* mError;
    
}
 
/**
 * Initializes the validator with the information from an EDL file and
 * an EDL rule file.
 *
 * \param edlPath  Path to the experiment configuration file (EDL file). 
 * \param rulePath Path to the XML file containing the EDL 
 *                 logical validation rules (pass nil if not needed).
 * \return         Returns the validator object. Nil in case of failure.
 */
-(id)initWithContentsOfEDLFile:(NSString*)edlPath
                   andEDLRules:(NSString*)rulePath;
    
/**
 * Checks the logical consistency of the EDL configuration based on
 * the given EDL ruleset.
 *
 * \return YES if consistent, NO if not consistent or an error occured.
 */
-(BOOL)isEDLConfigCorrectAccordingToRules;

/**
 * Returns an error object if something went wrong during 
 * initialization/validation.
 *
 * \return Error object containing de
 */
-(NSError*)getError;
    
/**
 * Resolves a reference to a XML node given in MATLAB syntax.
 * Remove leading and trailing whitespace first!
 *
 * \param ref  Reference path to the wanted EDL value in MATLAB syntax.
 * \param node Context node from which the reference path navigates.
 * \return     Value of the node referenced by ref. Empty string if
 *             ref is just a reference to an XML node (thus no 
 *             attribute or element value). Nil if reference is not
 *             existing.
 */
+(NSString*)substituteEDLValueForRef:(NSString*)ref
                         basedOnNode:(NSXMLNode*)node;

@end
