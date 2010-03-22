//
//  COSystemConfig.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "COSystemConfig.h"
#import "COXMLUtility.h"
#import "COErrorCode.h"


@interface COSystemConfig (PrivateStuff)

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

-(id)init
{
    if (self = [super init]) {    
        mSystemSetting = nil;
        mRuntimeSetting = nil;
        [self initAbbreviations];
    }
    
    return self;
}

-(void)initAbbreviations
{
	NSArray *shortKeys   = [NSArray arrayWithObjects:@"$TR", 
                            @"$gwDesign",
						    nil];
	
	NSArray *xpathValues = [NSArray arrayWithObjects:@"/rtExperiment/experimentData/imageModalities/TR", 
                            @"/rtExperiment/experimentData/paradigm/gwDesignStruct",
							nil];
	mAbbreviations = [[NSDictionary alloc] initWithObjects:xpathValues
                                                   forKeys:shortKeys];
}

+(COSystemConfig*)getInstance
{
    /** Singleton object of COSystemConfig. */
    static COSystemConfig* mSingleton = nil;
    
	if (!mSingleton) {
		mSingleton = [[self alloc] init];
	} 
	
	return mSingleton;
}

-(NSError*)fillWithContentsOfEDLFile:(NSString*)edlPath 
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
    NSMutableString* query = [NSMutableString stringWithCapacity:0];
    [query appendString:key];

    for (NSString* entryKey in mAbbreviations) {
        [query replaceOccurrencesOfString:(NSString*)entryKey 
                               withString:[mAbbreviations valueForKey:entryKey] 
                                  options:NSLiteralSearch 
                                    range:NSMakeRange(0, [query length])];
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

-(NSUInteger)countNodes:(NSString*)key
{
    NSString* query = [self resolveKey:key];
	NSError* err = nil;
	// TODO: mRuntimeSetting correct here?
	NSUInteger numberOfNodes = [[mRuntimeSetting nodesForXPath:query error:&err] count];
	
	if (err != nil) {
		// TODO: Handle/deligate error! (return nil?)
	}
	
	return numberOfNodes;
}

-(void)dealloc
{
    [mSystemSetting release];
    [mRuntimeSetting release];
    [mAbbreviations release];
    
//    [mSingleton release];
    
	[super dealloc];
}

@end
