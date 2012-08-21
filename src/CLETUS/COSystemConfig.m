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
    if ((self = [super init])) {
        mEDLFilePath    = nil;
        mSystemSetting  = nil;
        mRuntimeSetting = nil;
        [self initAbbreviations];
    }
    
    return self;
}

-(void)initAbbreviations
{
	NSArray *shortKeys   = [NSArray arrayWithObjects:@"$TR", 
                            @"$gwDesign",
							@"$swDesign",
							@"$dynDesign",
							@"$nrTimesteps",
							@"$timeUnit",
							@"$refFctsGamma",
							@"$refFctsGlover",
                            @"$constraints",
                            @"$timeTable",
                            @"$systemVariables",
                            @"$mediaObjects",
                            @"$screenResolutionX",
                            @"$screenResolutionY",
                            @"$logFolder",
                            @"$transferFunctions",
                            @"$stimulusData",
						    nil];
	
	NSArray *xpathValues = [NSArray arrayWithObjects:@"/rtExperiment/experimentData/imageModalities/TR", 
                            @"/rtExperiment/experimentData/paradigm/gwDesignStruct",
							@"/rtExperiment/experimentData/paradigm/swDesignStruct",
							@"/rtExperiment/experimentData/paradigm/dynamicDesignStruct",
							@"/rtExperiment/mriParams/MR_TAG_MEASUREMENTS",
							@"/rtExperiment/environment/@globalTimeUnit",
							@"/rtExperiment/statistics/referenceFunctions/dGamma",
							@"/rtExperiment/statistics/referenceFunctions/gloverKernel",
                            @"/rtExperiment/stimulusData/constraints",
                            @"/rtExperiment/stimulusData/timeTable",
                            @"/rtExperiment/stimulusData/constraints/systemVariables",
                            @"/rtExperiment/stimulusData/mediaObjectList",
                            @"/rtExperiment/stimulusData/stimEnvironment/screen/screenResolutionX",
                            @"/rtExperiment/stimulusData/stimEnvironment/screen/screenResolutionY",
                            @"/rtExperiment/environment/logging/logFolder",
                            @"/rtExperiment/stimulusData/transferFunctions",
                            @"/rtExperiment/stimulusData",
							nil];
	mAbbreviations = [[NSDictionary alloc] initWithObjects:xpathValues
                                                   forKeys:shortKeys];
}

//+(COSystemConfig*)getInstance
//{
//    /** Singleton object of COSystemConfig. */
//    static COSystemConfig* mSingleton = nil;
//    
//	if (!mSingleton) {
//		mSingleton = [[self alloc] init];
//	} 
//	
//	return mSingleton;
//}

-(NSError*)fillWithContentsOfEDLFile:(NSString*)edlPath 
{
    NSError* error = nil;
    
    if (mSystemSetting) {
        [mSystemSetting release];
    }
	mSystemSetting  = [COXMLUtility newParsedXMLDocument:edlPath :&error];
    
    if (mRuntimeSetting) {
        [mRuntimeSetting release];
    }
	mRuntimeSetting = [COXMLUtility newParsedXMLDocument:edlPath :&error];
    
    if (!error) {
        mEDLFilePath = [edlPath copy];
    }
   	return error;
}

-(NSError*)validateAgainstXSD:(NSString*)xsdPath
{
    if (xsdPath) {
        NSXMLElement* documentElement = [mRuntimeSetting rootElement];
        NSMutableArray* documentAttributes = [[documentElement attributes] mutableCopy];
        
        NSUInteger attributeIndex = 0;
        NSXMLNode* newSchemaLocationAttr = nil;
        for (NSXMLNode* attribute in documentAttributes) {
            
            /*
             * Two possiblities for schema location declaration:
             * - xsi:schemaLocation="namespaceURL schemapath-or-URL"
             * - xsi:noNamespaceSchemaLocation="schemapath-or-URL"
             */
            if ([[attribute name] isEqualToString:@"xsi:noNamespaceSchemaLocation"]) {
                attributeIndex = [documentAttributes indexOfObject:attribute];
                newSchemaLocationAttr = [NSXMLNode attributeWithName:[attribute name] 
                                                         stringValue:xsdPath];
                
            } else if ([[attribute name] isEqualToString:@"xsi:schemaLocation"]) {
                attributeIndex = [documentAttributes indexOfObject:attribute];

                // Namespace url and schema location are seperated by one space character.
                NSString* namespaceURL = [[[attribute stringValue] componentsSeparatedByString:@" "] objectAtIndex:0];
                
                NSString* newSchemaLocationString = nil;
                
                if ([xsdPath isAbsolutePath]
                    || [[NSURL URLWithString:xsdPath] checkResourceIsReachableAndReturnError:nil]) {
                    newSchemaLocationString = [NSString stringWithFormat:@"%@ %@", 
                                               namespaceURL, 
                                               xsdPath];
                    
                } else if (![xsdPath isAbsolutePath]) {
                    NSString* edlDirectoryPath = [mEDLFilePath stringByDeletingLastPathComponent];
                    NSArray* xsdAbsolutePathComponents = [[edlDirectoryPath pathComponents] arrayByAddingObjectsFromArray:[xsdPath pathComponents]];
                    newSchemaLocationString = [NSString stringWithFormat:@"%@ %@", 
                                                                           namespaceURL, 
                                                                              [NSString pathWithComponents:xsdAbsolutePathComponents]];
                }
                
                if (newSchemaLocationString) {
                    newSchemaLocationAttr = [NSXMLNode attributeWithName:[attribute name] 
                                                             stringValue:newSchemaLocationString];
                }
            }
        }
        
        if (newSchemaLocationAttr) {
            [documentAttributes replaceObjectAtIndex:attributeIndex
                                          withObject:newSchemaLocationAttr];
        }
        
        [documentElement setAttributes:documentAttributes];
        [documentAttributes release];
    }
    
    NSError* validationError = nil;
    [mRuntimeSetting validateAndReturnError:&validationError];
    
    return validationError;
}

-(NSString*)getEDLFilePath
{
    return mEDLFilePath;
}

-(NSError*)writeToFile:(NSString*)path
{
    NSError* error = nil;
    NSData* xmlData = [mRuntimeSetting XMLDataWithOptions:NSXMLNodePrettyPrint];
    NSString* expandedPath = [path stringByExpandingTildeInPath];
    
    if (![xmlData writeToFile:expandedPath atomically:YES]) {
        NSString* errorString = [NSString stringWithFormat:@"Could not write the configuration to \"%@\"!", expandedPath];
        error = [NSError errorWithDomain:errorString code:XML_DOCUMENT_WRITE userInfo:nil];
    }
    
    return error;
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
			NSString* errorString = [NSString stringWithFormat:@"Found %ld configuration entries for the given key (1 would be expected)!", 
                                     [queryResult count]];
			err = [NSError errorWithDomain:errorString code:CONFIG_ENTRY userInfo:nil];
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
	
	if ([queryResult count] == 1
        && err == nil) {
		return [[queryResult objectAtIndex:0] stringValue];
	} else {
		return nil;
    }
}

-(NSUInteger)countNodes:(NSString*)key
{
    NSString* query = [self resolveKey:key];
	NSError* err = nil;
	// TODO: mRuntimeSetting correct here?
	NSUInteger numberOfNodes = [[mRuntimeSetting nodesForXPath:query error:&err] count];
	
	if (err) {
		numberOfNodes = 0;
	}
	
	return numberOfNodes;
}

-(NSError*)replaceProp:(NSString*)key 
              withNode:(NSXMLNode*)node
{
    NSError* err = nil;
    NSString* query = [self resolveKey:key];
    NSArray* queryResult = [mRuntimeSetting nodesForXPath:query error:&err];
    
    if ([queryResult count] == 1
        && err == nil) {
        NSXMLNode* toReplace = [queryResult objectAtIndex:0];
        NSXMLNode* toReplaceParent = [toReplace parent];
        
        if ([toReplaceParent kind] == NSXMLElementKind) {
            if (node) {
                // Replace toReplace with node.  
                if ([toReplace kind] == NSXMLAttributeKind
                    && [node kind]   == NSXMLAttributeKind) {
                    [(NSXMLElement*)toReplaceParent removeAttributeForName:[toReplace name]];
                    [(NSXMLElement*)toReplaceParent addAttribute:node];
                    
                } else if ([toReplace kind] == NSXMLElementKind
                           && [node kind]   == NSXMLElementKind) {
                    [(NSXMLElement*)toReplaceParent replaceChildAtIndex:[toReplace index] 
                                                               withNode:node];
                }
                
            } else {
                // Delete toReplace.
                if ([toReplace kind] == NSXMLAttributeKind) {
                    [(NSXMLElement*)toReplaceParent removeAttributeForName:[toReplace name]];
                } else if ([toReplace kind] == NSXMLElementKind) {
                    [(NSXMLElement*)toReplaceParent removeChildAtIndex:[toReplace index]];
                }
            }
        }
    } else {
        if (err == nil) {
            NSString* errorString = [NSString stringWithFormat:@"Found %ld configuration entries for the given key (1 would be expected)!", 
                                     [queryResult count]];
            err = [NSError errorWithDomain:errorString code:CONFIG_ENTRY userInfo:nil];
        }
    }
    
    return err;
}

-(void)dealloc
{
    [mSystemSetting release];
    [mRuntimeSetting release];
    [mAbbreviations release];
    
    if (mEDLFilePath) {
        [mEDLFilePath release];
    }
    
	[super dealloc];
}

@end
