//
//  COEDLValidator.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COEDLValidator.h"
#import "COXMLUtility.h"


@interface COEDLValidator (PrivateStuff)
    
/**
 * Ruleset that identifies functional dependencies between
 * configuration entries.
 */
NSXMLDocument* mEDLRules = nil;

@end


@implementation COEDLValidator

-(id)initWithEDLRules:(NSString*)rulePath {
        
    NSURL* fileURL = [NSURL fileURLWithPath:rulePath];
    if (!fileURL) {
        NSString* errorString = [NSString stringWithFormat:@"Could not create URL from given path %s!", rulePath];
        return [NSError errorWithDomain:errorString code:URL_CREATION userInfo:nil];
    }
    
    [mEDLRules release];
    mEDLRules = [COXMLUtility newParsedXMLDocument:fileURL];
    
    if (mEDLRules == nil)  {
        return [NSError errorWithDomain:@"Could not read/parse EDL rules file. Check well-formedness of XML syntax and existence of file!" 
                                   code:XML_DOCUMENT_READ 
                               userInfo:nil];
    }
        
    return self;

}

-(NSError*)validateEDLConsistency
{
    return nil;
}

+(NSString*)substituteEDLValueForRef:(NSString*)ref
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

-(void)dealloc {
    
    [mEDLRules release];
    
    [super dealloc];
}

@end
