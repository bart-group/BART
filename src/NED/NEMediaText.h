//
//  NEMediaText.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef NEMEDIATEXT_H
#define NEMEDIATEXT_H

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"
#import "NERegressorAssignment.h"

/**
 * Represents a text media object in a MRI stimulus presentation.
 */
@interface NEMediaText : NEMediaObject {
    
    /** Actual text information. */
    NSString* mText;
    
    /** Size of the text (in em). */
    NSUInteger mSize;
    
    /** Text color. */
    NSColor* mColor;
    
}

/**
 * Initializes a newly allocated NEMediaText object
 * with an ID and a text.
 *
 * \param objID ID of the media object.
 * \param text  Text of the media object.
 * \return      A initialized NEMediaText object.
 */
-(id)initWithID:(NSString*)objID
        andText:(NSString*)text
  constrainedBy:(NSString*)constraintID
andRegAssignment:(NERegressorAssignment*)regAssign;

/**
 * Initializes a newly allocated NEMediaText object
 * with an ID, text, text size, text color and
 * frame position.
 *
 * \param objID   ID of the media object.
 * \param text    Text of the media object.
 * \param size    Size in which the text should be displayed (in em).
 * \param color   Color in which the text should be displayed.
 * \param positon Point of the lower left corner of the text.
 *                Relative to the frame in which the text should be
 *                displayed.
 * \return        A initialized NEMediaText object.
 */
-(id)initWithID:(NSString*)objID
           Text:(NSString*)text
         inSize:(NSUInteger)size
       andColor:(NSColor*)color
      atPostion:(NSPoint)position
  constrainedBy:(NSString*)constraintID
andRegAssignment:(NERegressorAssignment*)regAssign;

@end

#endif //NEMEDIATEXT_H
