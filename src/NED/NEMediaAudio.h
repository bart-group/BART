//
//  NEMediaAudio.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef NEMEDIAAUDIO_H
#define NEMEDIAAUDIO_H

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "NEMediaObject.h"
#import "NERegressorAssignment.h"

/**
 * Represents an audio media object in a MRI stimulus presentation.
 */
@interface NEMediaAudio : NEMediaObject {

    /** Playable track. */
    QTMovie* mTrack;

}

/**
 * Initializes a newly allocated NEMediaAudio object
 * with an ID and audio file.
 *
 * \param objID ID of the media object.
 * \param path  Path to the audio file.
 * \return      A initialized NEMediaAudio object.
 */
-(id)initWithID:(NSString*)objID 
        andFile:(NSString*)path
  constrainedBy:(NSString*)constraintID
andRegAssignment:(NERegressorAssignment*)regAssign;

@end

#endif // NEMEDIAAUDIO_H
