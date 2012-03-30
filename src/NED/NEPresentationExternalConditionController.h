//
//  NEPresentationExternalConditionController.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

/* The class to hold the information about influences from external devices to the stimulus events in the Presentation 
 * of the paradigm. Connects the e.g. SerialPorts with constraints to be asked while runtime about their current state.
 */

#import <Foundation/Foundation.h>

//@class NEStimEvent;

@interface NEPresentationExternalConditionController : NSObject {
    
}

/**
 * Initializes a newly allocated NEPresentationExternalConditionController object.
 * 
 * \param newConstraintsArray   An array of all the constraints read from edl-file.
 * 
 * \return              An initialized NEPresentationExternalConditionController object.
 */
-(id)initWithConstraints:(NSArray*)newConstraintsArray;


/**
 * check the external conditions for the current constraint
 * 
 * \param constraintID          The ID for the constrint you want to check.
 * \return                      a dictionary with the results for the conditions and relevant parameters for actions
 */

-(NSDictionary*)checkConstraintForID:(NSString*)constraintID;

@end
