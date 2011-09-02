//
//  NEPresentationExternalConditionController.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

/* The class to hold the information about influences from external devices to the stimulus events in the Presentation 
 * of the paradigm. Connects the e.g. SerialPorts with mediaObjectIDs to while runtime about their current state.
 */

#import <Foundation/Foundation.h>

@class NEStimEvent;

@interface NEPresentationExternalConditionController : NSObject {
    
}

/**
 * Initializes a newly allocated NEPresentationExternalConditionController object.
 * 
 * \param newMediaObjects   An array of all the mediaObjects to be influenced by external devices/conditions.
 * 
 * \return              An initialized NEPresentationExternalConditionController object.
 */
-(id)initWithMediaObjects:(NSArray*)newMediaObjects;


/**
 * ask if all external conditions for one mediaObject are fullfilled to run the trial in the Presentation
 * 
 * \param mediaObjectID        The ID for the mediaObject you want to check.
 * \return                     YES if all defined external conditions are fullfilled for this mediaObjectID, NO otherwise.
 */

-(NSPoint)isConditionFullfilledForEvent:(NEStimEvent*)event;
@end
