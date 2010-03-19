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
 *
 * \param fileURL URL of the desired EDL file.
 * \return        NSXMLDocument instance that represents 
 *                the content of the XML file.
 */
+(NSXMLDocument*)newParsedXMLDocument:(NSString*)filePath;

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
