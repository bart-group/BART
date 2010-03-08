//
//  COXMLUtility.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COXMLUtility.h"


@implementation COXMLUtility

+(NSXMLDocument*)newParsedXMLDocument:(NSURL*)fileURL
{	
    //TODO: Error nutzen!
	NSXMLDocument* doc = nil;
    NSError* err = nil;
    doc = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL
                                               options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                 error:&err];
    if (doc == nil) {
		err = nil;
        doc = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL
                                                   options:NSXMLDocumentTidyXML
                                                     error:&err];
    }
	
	return doc;
}

@end
