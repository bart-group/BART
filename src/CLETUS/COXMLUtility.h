//
//  COXMLUtility.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


enum COXMLUtilityError {
    URL_CREATION,
	XML_DOCUMENT_READ
};

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
+(NSXMLDocument*)newParsedXMLDocument:(NSURL*)fileURL;

@end
