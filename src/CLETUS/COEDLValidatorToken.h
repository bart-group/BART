//
//  COEDLValidatorToken.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum COTokenKind {
    EMPTY_TOKEN = 0,
    BOOLEAN_TOKEN,
    NUMBER_TOKEN,
    STRING_TOKEN,
    PARAMETER_TOKEN,
    WORD_TOKEN,
    SYMBOL_TOKEN
};

/**
 * Represents a parsed token in a literal.
 */
@interface COEDLValidatorToken : NSObject {
    
    /** Kind of the token (e.g. word, symbol, number ...). */
    enum COTokenKind mKind;
    
    /** Value of the token in string representation. */
    NSString* mValue;

}

/**
 * Initializes an empty token of kind EMPTY_TOKEN
 * with an empty string as value.
 *
 * \return An empty token.
 */
-(id)init;

/**
 * Initializes a token with a kind and a value.
 *
 * \param aKind   Kind of the token.
 * \param aValue  String representing the value of the token.
 * \return        A fully initialized token.
 */
-(id)initWithKind:(enum COTokenKind)aKind andValue:(NSString*)aValue;

@property (assign) enum COTokenKind mKind;
@property (retain) NSString* mValue;

@end
