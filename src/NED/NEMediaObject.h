//
//  NEMediaObject.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/**
 * Abstract representation of a media object in a MRI
 * stimulus presentation.
 */
@interface NEMediaObject : NSObject {
    
    /** Point of the lower left corner of the media object. */
    NSPoint mPosition;
    
    /** ID of the media object. Used for referencing in EDL stimEvent-s */
    NSString* mID;

}

/**
 * Initializes a newly allocated NEMediaObject with an EDL mediaObject
 * from the configuration represented by key.
 *
 * \param key Configuration key for the needed media object.
 * \return    A initialized NEMediaObject.
 */
-(id)initWithConfigEntry:(NSString*)key;

/**
 * Presents the media object in a given graphics context and frame.
 * In case of audio only data the playback is started and the parameters
 * are not needed.
 *
 * \param context Graphics context for drawing.
 * \param rect    Frame in which to draw.
 */
-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect;

/**
 * Pauses the playback of continuous media (audio/video).
 * No effect on static media (text/image).
 */
-(void)pausePresentation;

/**
 * Continues playback of paused media (audio/video).
 * No effect on static media (text/image).
 */
-(void)continuePresentation;

/**
 * Stops the playback of continuous media (audio/video).
 * No effect on static media (text/image).
 */
-(void)stopPresentation;

/**
 * Returns the ID of the media object.
 *
 * \return ID of the media object.
 */
-(NSString*)getID;

@end
