//
//  NEFeedbackObject.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/**
 * Abstract class for feedback objects.
 * You need to subclass NEFeedbackObject in order to
 * implement your own feedback system.
 *
 * Methods to overwrite:
 *    initWithFrame:andParameters:
 *    tick
 *    drawRect:
 *    dealloc
 */
@interface NEFeedbackObject : NSView {

    /** The latest or all parameter(s) of the feedback object. */
    NSDictionary* parameters;
    
    /** Thread that regulary updates the feedback presentation. */
    NSThread* mTickThread; 
    
}

/**
 * Initializes an already allocated NEFeedbackObject with a
 * specified frame rectangle and initial parameters.
 *
 * \param frame  The frame rectangle for the feedback object.
 * \param params The parameters used for initialization of the
 *               feedback object. Pass nil if no initialization is
 *               needed.
 *               Key: parameter name (String).
 *               Value: parameter value (String).
 */
-(id)initWithFrame:(NSRect)frame
     andParameters:(NSDictionary*)params;

/**
 * Passes new parameters to the feedback object.
 * The previous parameters are discarded.
 *
 * \param newParams The new parameter(s) to set.
 *                  Key: parameter name (String).
 *                  Value: parameter value (String).
 */
-(void)setParameters:(NSDictionary*)newParams;

/**
 * Entry point / main function for the thread mTickThread.
 * Periodically calls tick and displays the feedback object.
 */
-(void)runTickThread;

/**
 * Method that is regulary invoked by the tick thread.
 * Should update the feedback object state based on
 * subject input.
 */
-(void)tick;

@end
