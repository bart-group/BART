//
//  NEXMLFormatter.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class NETimetable;


/**
 * Class for converting BART objects into XML tree structures.
 */
@interface NEXMLFormatter : NSObject {

}

/**
 * Returns the default formatter (shared instance).
 *
 * \return An initialized NEXMLFormatter.
 */
+(NEXMLFormatter*)defaultFormatter;

/**
 * Generates a XML tree from a NETimetable object.
 *
 * \param timetable The timetable to convert.
 * \return          A XML tree representing the timetable
 *                  according to EDL specification.
 */
-(NSXMLElement*)xmlTreeForTimetable:(NETimetable*)timetable;

@end
