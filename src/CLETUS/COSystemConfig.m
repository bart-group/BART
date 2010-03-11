//
//  COSystemConfig.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COSystemConfig.h"
#import "COXMLUtility.h"


@interface COSystemConfig (PrivateStuff)

COSystemConfig* mSingleton = nil;

/**
 * Original configuration from the EDL file. Remains unchanged
 * during runtime.
 */
NSXMLDocument* mSystemSetting = nil;

/**
 * Copy of the original configuration. Changes to the experiment
 * configuration that occur during runtime are stored here.
 */
NSXMLDocument* mRuntimeSetting = nil;

/**
 * Dictionary that eliminates the need of knowing the exact XPath
 * for often used configuration entries (e.g. RepetitionTime).
 */
NSDictionary* mAbbreviations = nil;
    

/**
 * Setups abbreviation dictionary which contains short keywords
 * for often used config entries (and their associated XPath
 * locators).
 */
-(void)initAbbreviations;

/**
 * Utility method for accessing the internal XMLDocument/-Tree:
 * Decides whether the given key is a short keyword (XPath
 * supplement) and has to be expanded to the actual XPath string.
 *
 * \param key XPath or short word needed to be checked.
 * \return    XPath identifying and entry in the config tree.
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

-(NSError*)initializeWithContentsOfEDLFile:(NSString*)edlPath 
                         
{
    [mSystemSetting release];
	mSystemSetting  = [COXMLUtility newParsedXMLDocument:edlPath];
    [mRuntimeSetting release];
	mRuntimeSetting = [COXMLUtility newParsedXMLDocument:edlPath];
    
    if (mSystemSetting == nil || mRuntimeSetting == nil)  {
		return [NSError errorWithDomain:@"Could not read/parse EDL file. Check well-formedness of XML syntax and existence of file!" 
                                   code:XML_DOCUMENT_READ 
                               userInfo:nil];
	}
    
	return nil;
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
    
    [mSingleton release];
    
	[super dealloc];
}

@end
