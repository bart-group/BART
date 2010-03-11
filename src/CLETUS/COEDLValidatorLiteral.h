//
//  COEDLValidatorLiteral.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


enum COLiteralValue {
	LIT_ERROR = -1,
    LIT_FALSE,
    LIT_TRUE
};

enum COEDLValidatorLiteralError {
	INCORRECT_SYNTAX
};

/**
 * Represents a literal in a premise or conclusion of an 
 * EDL rule.
 * Able to parse and evaluate the literal string. 
 */
@interface COEDLValidatorLiteral : NSObject {
    
    /** String representing the whole literal. */ 
    NSString* literalString;

}

/**
 * Initializes an allocated COEDLValidatorLiteral object.
 *
 * \param literal A string representing a single literal.
 * \param params  A dictionary containing all parameters
 *                that are in scope of the literal.
 *                Pass nil or an empty dictionary if no
 *                parameters are in scope of the literal.
 */
-(id)initWithLiteralString:(NSString*)literal 
             andParameters:(NSDictionary*)params;

/**
 * Return the value of the literal (LIT_ERROR, LIT_FALSE
 * or LIT_TRUE).
 * When asked for the first time, the orginal literal
 * string gets parsed and evaluated.
 *
 * \return The boolean value of the literal or error
 *         (both hidden behind COLiteralValue).
 */
-(enum COLiteralValue)getValue;

/**
 * If getValue returned LIT_ERROR you can ask for a
 * more descriptive error object. Nil otherwise.
 *
 * \return An NSError object.
 */
-(NSError*)getError;

@property (readonly) NSString* literalString;

@end
