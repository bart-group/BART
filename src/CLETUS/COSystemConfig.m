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
 * Ruleset that identifies functional dependencies between
 * configuration entries.
 */
NSXMLDocument* mEDLRules = nil;

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
 * Utility method for method initWithContentsOfEDLFile. Does
 * the actual reading of the XML file.
 *
 * \param fileURL URL of the desired EDL file.
 * \param err     Contains errors if something went wrong, nil otherwise.
 * \return        NSXMLDocument instance that represents the content of the
 *				  EDL file.
 */
-(NSXMLDocument*)parseXMLFile:(NSURL*)fileURL;

/**
 * Checks the logical consistency of the EDL configuration based on
 * the given EDL ruleset.
 */
-(NSError*)validateEDLConsistency;

/**
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

-(NSError*)initWithContentsOfEDLFile:(NSString*)edlPath 
                         andEDLRules:(NSString*)rulePath;
{
    NSURL* fileURL = [NSURL fileURLWithPath:edlPath];
    if (!fileURL) {
		NSString* errorString = [NSString stringWithFormat:@"Could not create URL from given path %s!", edlPath];
        return [NSError errorWithDomain:errorString code:URL_CREATION userInfo:nil];
    }
    
    [mSystemSetting release];
	mSystemSetting  = [self parseXMLFile:fileURL];
    [mRuntimeSetting release];
	mRuntimeSetting = [self parseXMLFile:fileURL];
    
    if (mSystemSetting == nil || mRuntimeSetting == nil)  {
		return [NSError errorWithDomain:@"Could not read/parse EDL file. Check well-formedness of XML syntax and existence of file!" 
                                   code:XML_DOCUMENT_READ 
                               userInfo:nil];
	}
    
    // Read EDL rules and validate the EDL.
    if (rulePath != nil) {
        
        [fileURL release];
        fileURL = [NSURL fileURLWithPath:rulePath];
        if (!fileURL) {
            NSString* errorString = [NSString stringWithFormat:@"Could not create URL from given path %s!", rulePath];
            return [NSError errorWithDomain:errorString code:URL_CREATION userInfo:nil];
        }
        
        [mEDLRules release];
        mEDLRules = [self parseXMLFile:fileURL];
        
        if (mEDLRules == nil)  {
            return [NSError errorWithDomain:@"Could not read/parse EDL rules file. Check well-formedness of XML syntax and existence of file!" 
                                       code:XML_DOCUMENT_READ 
                                   userInfo:nil];
        }
        
        return [self validateEDLConsistency];
    }
    
	return nil;
}

-(NSXMLDocument*)parseXMLFile:(NSURL*)fileURL
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

-(NSError*)validateEDLConsistency
{
    return nil;
}

-(NSString*)substituteEDLValueForRef:(NSString*)ref
                         basedOnNode:(NSXMLNode*)node
{
    if ([ref hasPrefix:@"ATTRIBUTE."]) {
        
        // Find and return an attribute value.
        NSString* attributeName  = [ref stringByReplacingOccurrencesOfString:@"ATTRIBUTE." 
                                                                  withString:@""];
        
        NSString* attributeValue = nil;
        
        for (NSXMLNode* child in [((NSXMLElement*) node) attributes]) {
            
            // Child is the requested attribute...
            if ([child kind] == NSXMLAttributeKind 
                && [[child name] compare:attributeName] == 0) {
                attributeValue = [[[NSString alloc] initWithString:[child stringValue]] autorelease];
            }
        }
        
        return attributeValue;
        
    } else if ([ref hasPrefix:@"CONTENT"]) {
        
        // Element value.
        return [[[NSString alloc] initWithString:[node stringValue]] autorelease];
        
    } else {
        
        // Go to child and repeat recursive...
        NSUInteger splitIndex = [ref rangeOfString:@"."].location;
        
        if (splitIndex == NSNotFound) {
            return nil;
        }
        
        NSString* newBaseNodeName = [ref substringToIndex:splitIndex];
        int occurenceNr = 1;
        
        // Node has multiple child elements of the same name. Locate the one wanted child.
        if ([newBaseNodeName hasSuffix:@"}"]) {
            NSUInteger curlyOpenIndex = [ref rangeOfString:@"{"].location;
            
            NSRange ofOccurenceNrString;
            ofOccurenceNrString.location = curlyOpenIndex + 1;
            ofOccurenceNrString.length   = [newBaseNodeName length] - 1 - curlyOpenIndex;
            
            occurenceNr = [[newBaseNodeName substringWithRange:ofOccurenceNrString] intValue];
            
            newBaseNodeName = [ref substringToIndex:curlyOpenIndex];
        }
        
        NSXMLNode* newBaseNode = nil;
        
        int currentOccurence = 0;
        for (NSXMLNode* child in [node children]) {
            
            if ([child kind] == NSXMLElementKind 
                || [child kind] == NSXMLAttributeKind) {
                
                if ([[child name] compare:newBaseNodeName] == 0) {
                    
                    currentOccurence++;
                    
                    // Child is the requested element...
                    if (currentOccurence == occurenceNr) {
                        newBaseNode = child;
                    }
                }
            }
        }
        
        if (newBaseNode) {
            return [self substituteEDLValueForRef:[ref substringFromIndex:splitIndex + 1] 
                                      basedOnNode:newBaseNode];
        } else {
            return nil;
        }
    }
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
