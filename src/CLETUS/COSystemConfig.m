//
//  COSystemConfig.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COSystemConfig.h"


@interface COSystemConfig (PrivateStuff)

COSystemConfig* mSingleton = nil;
NSXMLDocument* mSystemSetting = nil;
NSXMLDocument* mRuntimeSetting = nil;
NSDictionary* mAbbreviations = nil;

/*!
 * Setups abbreviation dictionary which contains short keywords
 * for often used config entries (and their associated XPath
 * locators).
 */
-(void)initAbbreviations;

/*!
 * Utility method for method initWithContentsOfEDLFile. Does
 * the actual reading of the XML file.
 *
 * \param fileURL URL of the desired EDL file.
 * \param err     Contains errors if something went wrong, nil otherwise.
 * \return        NSXMLDocument instance that represents the content of the
 *				  EDL file.
 */
-(NSXMLDocument*)parseEDLFile:(NSURL*)fileURL;

/*!
 * Utility method for accessing the internal XMLDocument/-Tree:
 * Decides whether the given key is a short keyword (XPath
 * supplement) and has to be expanded to the actual XPath string.
 */
-(NSString*)resolveKey:(NSString*)key;

@end


@implementation COSystemConfig

-(void)initAbbreviations
{
	NSArray *shortKeys = [NSArray arrayWithObjects:@"sTR", 
												   @"sNumEvents", 
												   @"sFoo", 
						  nil];
	
	NSArray *xpathValues = [NSArray arrayWithObjects:@"", 
													 @"", 
													 @"", 
							nil];
	mAbbreviations = [NSDictionary dictionaryWithObjects:xpathValues
												 forKeys:shortKeys];
}

+(COSystemConfig*)getInstance
{
	if (mSingleton == nil) {
		mSingleton = [[COSystemConfig alloc] init];
        [mSingleton initAbbreviations];
	} 
	
	return mSingleton;
}

-(NSError*)initWithContentsOfEDLFile:(NSString*)path
{
    NSURL* fileURL = [NSURL fileURLWithPath:path];
    if (!fileURL) {
		NSString* errorString = [NSString stringWithFormat:@"Could not create URL from given path %s!", path];
        return [NSError errorWithDomain:errorString code:URL_CREATION userInfo:nil];
    }
	
	NSError* err = nil;
    
    [mSystemSetting release];
	mSystemSetting  = [self parseEDLFile:fileURL];
    [mRuntimeSetting release];
	mRuntimeSetting = [self parseEDLFile:fileURL];
    
    if (mSystemSetting == nil || mRuntimeSetting == nil)  {
		err = [NSError errorWithDomain:@"Could not read/parse XML file. Check XML-Syntax and existence of file!" 
                                  code:XML_DOCUMENT_READ 
                              userInfo:nil];
	}

	return err;
}

-(NSXMLDocument*)parseEDLFile:(NSURL*)fileURL
{	
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

-(NSString*)resolveKey:(NSString*)key
{
	NSString* query = nil;
	
	if ([key hasPrefix:@"s"]) {
		query = [mAbbreviations objectForKey:key];
	} else {
		query = key;
	}
	
	return query;
}

-(NSError*)setProp:(NSString*)key 
				  :(NSString*)value
{
	NSString* query = [self resolveKey:key];
	NSError* err = nil;
	// TODO: mRuntimeSetting correct here?
	NSArray* queryResult = [mRuntimeSetting nodesForXPath:query error:&err];
	
	if ([queryResult count] == 1) {
		[[queryResult objectAtIndex:0] setStringValue:value];
	} else {
		if (err == nil) {
			NSString* errorString = [NSString stringWithFormat:@"Found %d configuration entries for the given key (1 would be expected)!", [queryResult count]];
			return [NSError errorWithDomain:errorString code:CONFIG_ENTRY userInfo:nil];
		}
	}

	return err;
}

-(NSString*)getProp:(NSString*)key
{
	NSString* query = [self resolveKey:key];
	NSError* err = nil;
	// TODO: mRuntimeSetting correct here?
	NSArray* queryResult = [mRuntimeSetting nodesForXPath:query error:&err];
	
	NSString* resultValue;
	
	if ([queryResult count] == 1) {
		resultValue = [[queryResult objectAtIndex:0] stringValue];
	} else {
		resultValue = nil;
	}
	
	if (err != nil) {
		// TODO: Handle/deligate error! (return nil?)
	}
	
	return resultValue;
}

-(void)dealloc
{
    [mSystemSetting release];
    [mRuntimeSetting release];
    
	[super dealloc];
}

@end
