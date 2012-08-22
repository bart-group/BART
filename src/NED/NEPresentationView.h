//
//  NEPresentationView.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef NEPRESENTATIONVIEW_H
#define NEPRESENTATIONVIEW_H

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"


@class NEFeedbackObject;


/**
 * Represents the presentation panel/screen that is usually embedded in
 * a window.
 */
@interface NEPresentationView : NSView {
    
    /**
     * All media objects that are currently presented.
     */
    NSMutableArray* mMediaObjects;
    /** Lock for synchronizing access to mMediaObjects. */
    //NSLock* mLockMediaObjects;
    
    /**
     * Holds the DisplayCount for each media object
     * in mMediaObjects.
     * Key is the ID of the media object. Value is a
     * NSNumber containing the DisplayCount.
     * The DisplayCount is incremented when the media
     * object is added and decremented when it's removed.
     * The media object is removed from mMediaObjects
     * when its DisplayCount reaches 0 (similar to 
     * reference counts and deallocation).
     */
    NSMutableDictionary* mDisplayCounts;
    
    /** 
     * A feedback object that is drawn alongside the 
     * stimulus presentation.
     */
//    NEFeedbackObject* feedbackObject;
    
    
    BOOL needsDisplay;
    
    /** Indicates whether a feedback object has been set. */
    BOOL feedbackIsSet;
}

//@property (retain) NEFeedbackObject* feedbackObject;
/** Indicates whether the view needs to be displayed/redrawn. */
@property (readwrite) BOOL needsDisplay;

/**
 * Adds a media object to the presentation panel.
 * Results in drawing (text/image) or playing (audio/video)
 * of mediaObj alongside all other media objects that have
 * been added previously and are not removed yet.
 *
 * \param mediaObj NEMediaObject that should be added to the
 *                 presentation.
 */
-(void)addMediaObject:(NEMediaObject*)mediaObj;

/**
 * Removes a media object from the presentation panel.
 * Redraws the scene with all remaining media objects.
 * In case of continuous media: stops the playback of
 * (and only of) mediaObj.
 *
 * \param mediaObj NEMediaObject that should be removed from
 *                 presentation.
 */
-(void)removeMediaObject:(NEMediaObject*)mediaObj;

/**
 * Removes all active media objects from the presentation
 * panel. Results in a redraw of the panel.
 */
-(void)removeAllMediaObjects;

/**
 * Pauses the playback of all currently active
 * continuous media (audio/video).
 */
-(void)pausePresentation;

/**
 * Continues the playback of all currently paused
 * continuous media (audio/video).
 */
-(void)continuePresentation;

/**
 * Acknowledges a feedback object to the presentation view.
 * Removes the currently active feedback object if necessary. 
 *
 * \param feedbackObj The NEFeedbackObject to set. Pass nil
 *                    to remove the current feedback object.
 */
-(void)setFeedback:(NEFeedbackObject*)feedbackObj;

@end

#endif // NEPRESENTATIONVIEW_H
