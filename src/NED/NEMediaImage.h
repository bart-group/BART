//
//  NEMediaImage.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"


/**
 * Represents an image media object in a MRI stimulus presentation.
 */
@interface NEMediaImage : NEMediaObject {
    
    /** Image (bitmap) information. */
    CIImage* mImage;

}

/**
 * Initializes a newly allocated NEMediaImage object
 * with an ID and image file.
 *
 * \param objID    ID of the media object.
 * \param path     Path to the image file.
 * \param position Position of the lower left corner of the image
 *                    when displaying it on a screen / in a given NSRect.
 * \return         A initialized NEMediaImage object.
 */
-(id)initWithID:(NSString*)objID
           file:(NSString*)path
      displayAt:(NSPoint)position;

@end
