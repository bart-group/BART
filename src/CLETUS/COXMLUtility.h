//
//  COXMLUtility.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/**
 * Providing functions for common XML issues.
 */
@interface COXMLUtility : NSObject {

}

/**
 * Utility method for method for reading a XML file.
 * Note that even if an error occured a partially correct
 * NSXMLDocument object could be constructed and returned. 
 * So always check for existence of the error object instead of
 * existence of the NSXMLDocument object.
 *
 * \param filePath URL of the desired EDL file.
 * \param error   Indirect returned error object if something went wrong.
 * \return        NSXMLDocument instance that represents 
 *                the content of the XML file.
 */
+(NSXMLDocument*)newParsedXMLDocument:(NSString*)filePath
                                     :(NSError**)error;

/**
 * Loops through all child elements of a XML node until it finds the
 * first child named childName and that has the kind childKind. 
 * Returns the value of this child as a string.
 *
 * \param childName Name of the child element.
 * \param childKind Node kind of the child element.
 * \param node      XML node whose children are inspected (parent).
 * \return          StringValue of the child element, nil if not found.
 */
+(NSString*)valueOfFirstChild:(NSString*)childName 
                     withKind:(NSXMLNodeKind)childKind 
                    ofElement:(NSXMLNode*)node;

/**
 * Loops through all attributes of a XML element until it finds
 * the attribute name. Returns the string value of this attribute.
 *
 * \param name Name of the attribute. 
 * \param elem Element that should have the attribute.
 * \return     StringValue of the attribute, nil if not found.
 */
+(NSString*)valueOfAttribute:(NSString*)name 
                   inElement:(NSXMLElement*)elem;

@end
