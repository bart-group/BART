//
//  COEDLValidatorLiteral.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COEDLValidatorLiteral.h"
#import "COEDLValidatorToken.h"


enum COLiteralComparisonOperator {
    LIT_BIGGERTHAN,
    LIT_LOWERTHAN
};
enum COLiteralArithmeticOperation {
    LIT_MULTIPLICATION,
    LIT_DIVISION,
    LIT_ADDITION,
    LIT_SUBTRACTION
};

@interface COEDLValidatorLiteral (PrivateStuff)

/**
 * Splits the literalString into an array of COEDLValidatorToken objects
 * prepared for evaluation.
 *
 * \param cur Current reading position in the literal string. 
 */
-(void)tokenize:(int*)cur;

/**
 * Methods identifing signaling characters for each token kind.
 */
-(BOOL)isBeginOfSymbol:(unichar)character;
-(BOOL)isBeginOfWord:(unichar)character;
-(BOOL)isBeginOfString:(unichar)character;
-(BOOL)isDigit:(unichar)character;

/**
 * Methods parsing a token of the appropriate token kind.
 */
-(void)parseSymbol:(int*)cur;
-(void)parseWord:(int*)cur;
-(void)parseString:(int*)cur;
-(void)parseNumber:(int*)cur;

/**
 * Lookup all tokens of kind WORD_TOKEN that are not 
 * predefined EDL functions in the dictionary mParameters.
 *
 * If found:  replace the parameter name with value and 
 *            change token kind to PARAM_TOKEN.
 * Not found: remove word token. This will most likely 
 *            result in an evaluation error later. Except
 *            this word token (not existing parameter) is
 *            argument for the predefined EDL function
 *            edlValidation_exists - calling this function
 *            without an argument will result in NO/FALSE.
 */
-(void)resolveParameters;

/**
 * Checks whether a given word represents an EDL
 * function. Predefined EDL functions are:
 *
 * - edlValidation_biggerThan
 * - edlValidation_lowerThan
 * - edlValidation_exists
 * - edlValidation_strcmp
 */
-(BOOL)isPredefinedEDLFunction:(NSString*)word;

/**
 * Recursively evaluates the array parsedTokens until only 
 * one COEDLValidatorToken of kind BOOLEAN_TOKEN is left.
 *
 * \param range Defines the subsequence of parsedTokens
 *              that shall be evaluated.
 */
-(void)evaluateTokensOver:(NSRange)range;
-(NSUInteger)indexOfSymbol:(NSString*)symbol inRange:(NSRange)range;
-(void)evaluateEquals:(NSUInteger)equalsIndex;

-(void)evaluateBracketsOver:(NSRange)range;
-(void)removePair:(NSUInteger)leftIndex and:(NSUInteger)rightIndex;
-(BOOL)isFunctionOpeningBracket:(NSUInteger)bracketIndex;

-(void)evaluateUnaryFunctionWith:(NSRange)argumentRange;
-(void)evaluateEDLValidationExistsWith:(NSRange)argumentRange;

-(void)evaluateBinaryFunctionWith:(NSRange)leftArgRange and:(NSRange)rightArgRange;
-(void)evaluateEDLValidationStrcmpWith:(NSRange)leftArgRange and:(NSRange)rightArgRange;
-(void)evaluateEDLValidationCompare:(NSRange)leftArgRange 
                                and:(NSRange)rightArgRange 
                       withOperator:(enum COLiteralComparisonOperator)op;

-(void)evaluateArithmeticTermOver:(NSRange)range;
-(void)evaluateUnaryMinus:(NSUInteger)minusIndex;
-(void)evaluateBinaryOperation:(enum COLiteralArithmeticOperation)op at:(NSUInteger)index;

@end


@implementation COEDLValidatorLiteral

@synthesize literalString;

-(id)initWithLiteralString:(NSString*)literal 
             andParameters:(NSDictionary*)params
{
    literalString = literal;//[literal copy];
    if (params) {
        mParameters = params;
    } else {
        mParameters = [NSDictionary dictionary];
    }
    
    mTokens = [[NSMutableArray alloc] initWithCapacity:0];
    litValue = LIT_FALSE;
    mError = nil;
    
    return self;
}

-(enum COLiteralValue)getValue 
{    
    if ([mTokens count] == 0) {
        // Tokenize...
        int cur = 0;
        while (cur < [literalString length]) {
            [self tokenize:&cur];
        }
        
        // Evaluate...
        if ([mTokens count] > 0) {
            [self resolveParameters];
            
//            // TODO: remove output
//            FILE* fp = fopen("/tmp/cletusTest.txt", "w");
//            for (COEDLValidatorToken* token in mTokens) {
//                fputc(48 + [token mKind], fp);
//                fputc(' ', fp);
//                fputs([[token mValue] cStringUsingEncoding:NSUTF8StringEncoding], fp);
//                fputc('\n', fp);
//            }
//            fclose(fp);
//            // END output
            
            NSRange evalRange;
            evalRange.location = 0;
            evalRange.length   = [mTokens count];
            [self evaluateTokensOver:evalRange];
        } else {
            litValue = LIT_ERROR;
            // TODO: error and explosion
        }
        
        // Get value from last token that is left after
        // evaluation.
        if ([mTokens count] == 1) {
            COEDLValidatorToken* resultToken = [mTokens objectAtIndex:0];
            if ([resultToken mKind] == BOOLEAN_TOKEN) {
                if ([[resultToken mValue] compare:@"TRUE"] == 0) {
                    litValue = LIT_TRUE;
                } else {
                    litValue = LIT_FALSE;
                }
            } else {
                litValue = LIT_ERROR;
            }
        } else {
            litValue = LIT_ERROR;
        }
    }
    
    return litValue;
}

-(NSError*)getError
{
    return mError;
}

-(void)tokenize:(int*)cur
{
    unichar character = [literalString characterAtIndex:*cur];
    
    if ([self isBeginOfSymbol:character]) {
        [self parseSymbol:cur];
        (*cur)++;
    } else if ([self isBeginOfWord:character]) {
        [self parseWord:cur];
    } else if ([self isBeginOfString:character]) {
        [self parseString:cur];
    } else if ([self isDigit:character]) {
        [self parseNumber:cur];
    } else {
        (*cur)++;
    }
}

-(BOOL)isBeginOfSymbol:(unichar)character
{
    switch (character) {
        case '+':
        case '-':
        case '/':
        case '*':
        case '(':
        case ')':
        case ',':
        case '=':
            return YES;
        default:
            return NO;
            break;
    }
}

-(BOOL)isBeginOfWord:(unichar)character
{
    // character matches [A-Za-z]
    if ((character >= 65 && character <= 90) 
        || (character >= 97 && character <= 122)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)isBeginOfString:(unichar)character
{
    // character is '
    if (character == 39) {
        return YES;
    } 
    
    return NO;
}

-(BOOL)isDigit:(unichar)character
{
    // character matches [0-9]
    if (character >= 48 && character <= 57) {
        return YES;
    }
    
    return NO;
}

-(void)parseSymbol:(int*)cur
{
    COEDLValidatorToken* token = nil;
    
    switch ([literalString characterAtIndex:*cur]) {
        case '+':
        case '-':
        case '/':
        case '*':
        case '(':
        case ')':
        case ',':
            token = [[COEDLValidatorToken alloc] initWithKind:SYMBOL_TOKEN 
                                                     andValue:[NSString stringWithFormat:@"%c", [literalString characterAtIndex:*cur]]];
            //(*cur)++;
            break;
        case '=':
            @try {
                if ('=' == [literalString characterAtIndex:(*cur) + 1]) {
                    token = [[COEDLValidatorToken alloc] initWithKind:SYMBOL_TOKEN 
                                                             andValue:[NSString stringWithString:@"=="]];
                    
                    (*cur)++;
                } else {
                    litValue = LIT_ERROR;
                    mError = [NSError errorWithDomain:@"Cannot parse '=' at the end of the literal string." code:INCORRECT_SYNTAX userInfo:nil];
                }
                
            }
            @catch (NSException * e) {
                litValue = LIT_ERROR;
                mError = [NSError errorWithDomain:@"Cannot parse '=' at the end of the literal string." code:INCORRECT_SYNTAX userInfo:nil];
            }
            break;

        default:
            litValue = LIT_ERROR;
            mError = [NSError errorWithDomain:[NSString stringWithFormat:@"Unsupported symbol at position %d in literal string.", (*cur) + 1] 
                                        code:INCORRECT_SYNTAX 
                                    userInfo:nil];
            break;
    }
    
    [mTokens addObject:token];
    [token release];
}

-(void)parseWord:(int*)cur
{
    NSMutableString* buffer = [[NSMutableString alloc] initWithString:@""];
    unichar character = [literalString characterAtIndex:(*cur)];
    
    /* While cur is in the boundaries of literalString and the
     * character is either a letter, a number or the underscore
     * fill buffer.                                            
     */
    while (([self isDigit:character]
           || [self isBeginOfWord:character]
           || character == '_')
           && ((*cur) < [literalString length])) {
        
        [buffer appendFormat:@"%c", character];
        
        (*cur)++;
        
        if ((*cur) < [literalString length]) {
            character = [literalString characterAtIndex:(*cur)];
        }
    }
    
    COEDLValidatorToken* token = [[COEDLValidatorToken alloc] initWithKind:WORD_TOKEN 
                                                                  andValue:buffer];
    [mTokens addObject:token];
    [token release];
    [buffer release];
}

-(void)parseString:(int*)cur
{
    if ((*cur) >= [literalString length] - 1) {
        litValue = LIT_ERROR;
        mError = [NSError errorWithDomain:@"Beginning string (character ') at the end of the literal string." code:INCORRECT_SYNTAX userInfo:nil];
    }
    
    (*cur)++; // Skip string beginning.
    
    NSMutableString* buffer = [[NSMutableString alloc] initWithString:@""];
    unichar character;
    BOOL stringEndFound = NO;
    
    while (!stringEndFound
           && ((*cur) < [literalString length])) {
        
        character = [literalString characterAtIndex:(*cur)];
        
        /* Check for an escaped ' (string terminator), other escapes are copied
         * character by character.
         */
        if (character == '\\') {
            @try {
                character = [literalString characterAtIndex:(*cur) + 1];
                
                if (character == '\'') {
                    [buffer appendFormat:@"'", character];
                } else {
                    [buffer appendFormat:@"\\%c", character];
                }
                
                (*cur)++;
            }
            @catch (NSException * e) {
                litValue = LIT_ERROR;
                mError = [NSError errorWithDomain:@"Broken string at the end of the literal." code:INCORRECT_SYNTAX userInfo:nil];
            }
            
        // End of the string...
        } else if (character == '\'') {
            stringEndFound = YES;
        
        // 
        } else {
            [buffer appendFormat:@"%c", character];
        }
        
        (*cur)++;
    }
    
    if (!stringEndFound) {
        litValue = LIT_ERROR;
        mError = [NSError errorWithDomain:@"Broken string (missing string terminator) at the end of the literal." 
                                    code:INCORRECT_SYNTAX userInfo:nil];
    } else {
        COEDLValidatorToken* token = [[COEDLValidatorToken alloc] initWithKind:STRING_TOKEN 
                                                                      andValue:buffer];
        [mTokens addObject:token];
        [token release];
    }
    
    [buffer release];
}

/* TODO: document in interface: 
         have to match reg. expr. [0-9]{1,*}[[\.[0-9]{1,*}]?    
         e.g. 2, 90.02, 100.100, 5.0 */
-(void)parseNumber:(int*)cur
{
    NSMutableString* buffer = [[NSMutableString alloc] initWithString:@""];
    unichar character = [literalString characterAtIndex:(*cur)];
    
    // Pre decimal point or normal integer.
    while ([self isDigit:character]
           && ((*cur) < [literalString length])) {

        [buffer appendFormat:@"%c", character];
        
        (*cur)++;
        
        if ((*cur) < [literalString length]) {
            character = [literalString characterAtIndex:(*cur)];
        }
    }
    
    // Post decimal point.
    if (character == '.') {
        if ((*cur) + 1 < [literalString length]) {
            
            [buffer appendString:@"."];
            (*cur)++;
            character = [literalString characterAtIndex:(*cur)];
            
            if ([self isDigit:character]) {
                while ([self isDigit:character]
                       && ((*cur) < [literalString length])) {
                    
                    [buffer appendFormat:@"%c", character];
                    
                    (*cur)++;
                    
                    if ((*cur) < [literalString length]) {
                        character = [literalString characterAtIndex:(*cur)];
                    }
                }
            } else {
                litValue = LIT_ERROR;
                NSString* errorString = 
                    [NSString stringWithFormat:@"Malformed decimal point number (no position after the decimal point) at position %d in literal.", (*cur) + 1];
                mError = [NSError errorWithDomain:errorString 
                                            code:INCORRECT_SYNTAX userInfo:nil];
            }

        } else {
            litValue = LIT_ERROR;
            mError = [NSError errorWithDomain:@"Broken number format at the end of the literal (number that dosn't have any position after the decimal point discovered)." 
                                        code:INCORRECT_SYNTAX userInfo:nil];
        }
    }
    
    if (litValue != LIT_ERROR) {
        COEDLValidatorToken* token = [[COEDLValidatorToken alloc] initWithKind:NUMBER_TOKEN 
                                                                      andValue:buffer];
        [mTokens addObject:token];
        [token release];
    }
    
    [buffer release];
}

-(void)resolveParameters
{
    NSMutableArray* wordTokensToRemove = [NSMutableArray arrayWithCapacity:0];
    
    for (COEDLValidatorToken* token in mTokens) {
        if ([token mKind] == WORD_TOKEN
            && ![self isPredefinedEDLFunction:[token mValue]]) {
            
            NSString* paramValue = [mParameters valueForKey:[token mValue]];
            if (paramValue) {
                [token setMKind:PARAMETER_TOKEN];
                [token setMValue:paramValue];
            } else {
                [wordTokensToRemove addObject:token];
            }
        }
    }
    
    [mTokens removeObjectsInArray:wordTokensToRemove];
}

-(BOOL)isPredefinedEDLFunction:(NSString*)word
{
    if ([word compare:@"edlValidation_biggerThan"] == 0
        || [word compare:@"edlValidation_lowerThan"] == 0
        || [word compare:@"edlValidation_exists"] == 0
        || [word compare:@"edlValidation_strcmp"] == 0) {
        return YES;
    }
    
    return NO;
}

-(void)evaluateTokensOver:(NSRange)range
{
            // TODO: remove output
            FILE* fp = fopen("/tmp/cletusTest.txt", "a");
    fputc('\n', fp);
            for (COEDLValidatorToken* token in mTokens) {
                fputs([[token mValue] cStringUsingEncoding:NSUTF8StringEncoding], fp);
            }
            fclose(fp);
    fputc('\n', fp);
            // END output
    
    NSUInteger symbolIndex    = [self indexOfSymbol:@"(" inRange:range];
    NSUInteger altSymbolIndex = 0;
    
    if (symbolIndex < [mTokens count]) {
        range.length   = range.length - (symbolIndex - range.location);
        range.location = symbolIndex;
        [self evaluateBracketsOver:range];
    } //else {
        symbolIndex = [self indexOfSymbol:@"*" inRange:range];
        altSymbolIndex = [self indexOfSymbol:@"/" inRange:range];
        
        if (symbolIndex != altSymbolIndex) {
            // While any of both operations is in range (= stop when when both are equal to [mTokens count])
            while (symbolIndex != altSymbolIndex) {
                
                if (symbolIndex < altSymbolIndex) {
                    [self evaluateBinaryOperation:LIT_MULTIPLICATION at:symbolIndex];
                } else if (symbolIndex > altSymbolIndex) {
                    [self evaluateBinaryOperation:LIT_DIVISION at:altSymbolIndex];
                }
                
                symbolIndex = [self indexOfSymbol:@"*" inRange:range];
                altSymbolIndex = [self indexOfSymbol:@"/" inRange:range];
            }
            range.location = 0;
            range.length   = [mTokens count];
            [self evaluateTokensOver:range];
        } //else {
            symbolIndex = [self indexOfSymbol:@"+" inRange:range];
            altSymbolIndex = [self indexOfSymbol:@"-" inRange:range];
            
            if (symbolIndex != altSymbolIndex) {
                while (symbolIndex != altSymbolIndex) {
                    if (symbolIndex < altSymbolIndex) {
                        [self evaluateBinaryOperation:LIT_ADDITION at:symbolIndex];
                    } else if (symbolIndex > altSymbolIndex) {
                        [self evaluateBinaryOperation:LIT_SUBTRACTION at:altSymbolIndex];
                    }
                    
                    symbolIndex = [self indexOfSymbol:@"+" inRange:range];
                    altSymbolIndex = [self indexOfSymbol:@"-" inRange:range];
                }
                range.location = 0;
                range.length   = [mTokens count];
                [self evaluateTokensOver:range];
            } //else {
                symbolIndex = [self indexOfSymbol:@"==" inRange:range];
                
                if (symbolIndex < [mTokens count]) {
                    [self evaluateEquals:symbolIndex];
                }
//            }
//        }
//    }
}
-(NSUInteger)indexOfSymbol:(NSString*)symbol inRange:(NSRange)range;
{
    NSUInteger i = 0;
   
    while (i < range.length
           && (i + range.location) < [mTokens count]) {
        COEDLValidatorToken* token = [mTokens objectAtIndex:range.location + i];
        if ([token mKind] == SYMBOL_TOKEN
            && [[token mValue] compare:symbol] == 0) {
            return range.location + i;
        }
        i++;
    }
    
    return [mTokens count];
}
-(void)evaluateEquals:(NSUInteger)equalsIndex
{
    if (equalsIndex > 0 && equalsIndex < ([mTokens count] - 1)) {
        COEDLValidatorToken* leftOperand  = [mTokens objectAtIndex:equalsIndex - 1];
        COEDLValidatorToken* rightOperand = [mTokens objectAtIndex:equalsIndex + 1];
        if (([leftOperand mKind] == PARAMETER_TOKEN || [leftOperand mKind] == NUMBER_TOKEN)
            && ([rightOperand mKind] == PARAMETER_TOKEN || [rightOperand mKind] == NUMBER_TOKEN)) {
            
            COEDLValidatorToken* resultToken;
            
            double leftValue  = [[leftOperand mValue] doubleValue];
            double rightValue = [[rightOperand mValue] doubleValue];
            if (leftValue == rightValue) {
                resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"TRUE"];
            } else {
                resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
            }
            [mTokens replaceObjectAtIndex:(equalsIndex - 1) withObject:resultToken];
            [resultToken release];
            [self removePair:equalsIndex and:equalsIndex + 1];
        } else {
            // TODO: syntax error
        }
    } else {
        // TODO: syntax error: left or right operand for == missing
    }
}

// BEGIN Bracket evaluation.
-(void)evaluateBracketsOver:(NSRange)range
{
    // TODO: error if no corresponding bracket is found
    
    NSUInteger openingBracketIndex = range.location;
    NSUInteger seperatorIndex = 0;
    NSUInteger closingBracketIndex = 0;
    BOOL closingBracketFound = NO;
    int bracketPairNr = 1;
    int maxBracketPairNr = bracketPairNr;

    
    // First: find indices for opening/closing bracket (and optional seperator)
    NSUInteger lookupIndex = openingBracketIndex + 1;
    while (!closingBracketFound
           && (lookupIndex < (range.location + range.length))
           && (lookupIndex < [mTokens count])) {
        
        COEDLValidatorToken* lookupToken = [mTokens objectAtIndex:lookupIndex];
        
        if ([lookupToken mKind] == SYMBOL_TOKEN) {
            NSString* lookupTokenValue = [lookupToken mValue];
            
            if ([lookupTokenValue compare:@"("] == 0) {
                bracketPairNr++;
                if (bracketPairNr > maxBracketPairNr) {
                    openingBracketIndex = lookupIndex;
                }
            } else if ([lookupTokenValue compare:@")"] == 0) {
                bracketPairNr--;

                if (bracketPairNr == maxBracketPairNr - 1
                    && openingBracketIndex != range.location) {
            
                    [self evaluateBracketsOver:(NSRange){openingBracketIndex, [mTokens count]}];
                }

                if (bracketPairNr == 0
                    && !closingBracketFound) {
                    closingBracketIndex = lookupIndex;
                    closingBracketFound = YES;
                }
            } else if (seperatorIndex == 0
                       && bracketPairNr == 1
                       && [lookupTokenValue compare:@","] == 0) {
                seperatorIndex = lookupIndex;
            }
        }
        
        lookupIndex++;
    }

    if (openingBracketIndex == range.location) {
        // Second: Determine whether the brackets encapsulate function argument(s)
        //         or just annother expression.
        if ([self isFunctionOpeningBracket:openingBracketIndex]) {
            [self removePair:openingBracketIndex and:closingBracketIndex];
            
            if (seperatorIndex == 0) {
                NSRange argumentRange;
                argumentRange.location = openingBracketIndex;
                argumentRange.length   = closingBracketIndex - 1 - openingBracketIndex;
                
                [self evaluateUnaryFunctionWith:argumentRange];
            } else {
                [mTokens removeObjectAtIndex:seperatorIndex - 1]; // - 1 because of bracket removal.
                
                NSRange leftArgRange;
                leftArgRange.location  = openingBracketIndex;
                leftArgRange.length    = seperatorIndex - 1 - openingBracketIndex;
                NSRange rightArgRange;
                rightArgRange.location = seperatorIndex - 1; // seperator position before it was removed
                rightArgRange.length   = closingBracketIndex - 1 - seperatorIndex;
                
                [self evaluateBinaryFunctionWith:leftArgRange and:rightArgRange];
            }
        } else {
            if (seperatorIndex == 0) {
                [self removePair:openingBracketIndex and:closingBracketIndex];
                range.length = closingBracketIndex - 1 - openingBracketIndex;
                
                // openingBracketIndex is now the index of the first token
                // formerly enclosed by the brackets
                [self evaluateTokensOver:range];
            } else {
                // TODO: error: syntax error!
            }
        }
    }
}

-(void)removePair:(NSUInteger)leftIndex and:(NSUInteger)rightIndex
{
    [mTokens removeObjectAtIndex:leftIndex];
    [mTokens removeObjectAtIndex:rightIndex - 1];
}
-(BOOL)isFunctionOpeningBracket:(NSUInteger)bracketIndex
{
    if (bracketIndex > 0) {
        COEDLValidatorToken* possibleWordToken = [mTokens objectAtIndex:bracketIndex - 1];
        if ([possibleWordToken mKind] == WORD_TOKEN) {
            return [self isPredefinedEDLFunction:[possibleWordToken mValue]];
        }
    } 
    
    return NO;
}
// END Bracket evaluation.

// BEGIN Unary function evaluation.
-(void)evaluateUnaryFunctionWith:(NSRange)argumentRange
{
    if ([[[mTokens objectAtIndex:argumentRange.location - 1] mValue] compare:@"edlValidation_exists"] == 0) {
        [self evaluateEDLValidationExistsWith:argumentRange];
    }
}
-(void)evaluateEDLValidationExistsWith:(NSRange)argumentRange
{
    //[[mTokens objectAtIndex:argumentRange.location - 1] setMKind:BOOLEAN_TOKEN];
    
    COEDLValidatorToken* resultToken;
    
    if (argumentRange.length == 1) {
        enum COTokenKind tokenKind = [[mTokens objectAtIndex:argumentRange.location] mKind];
        if (tokenKind == NUMBER_TOKEN
            || tokenKind == STRING_TOKEN
            || tokenKind == PARAMETER_TOKEN) {
            
            [mTokens removeObjectAtIndex:argumentRange.location];
            resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"TRUE"];
            [mTokens replaceObjectAtIndex:(argumentRange.location - 1) withObject:resultToken];
            [resultToken release];
        } else {
            // TODO: error - no valid argument for exists
        }
    } else {
        //[[mTokens objectAtIndex:argumentRange.location - 1] setMValue:@"FALSE"];
        resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
        [mTokens replaceObjectAtIndex:(argumentRange.location - 1) withObject:resultToken];
        [resultToken release];
    }
}
// END Unary function evaluation.

// BEGIN Binary function evaluation.
-(void)evaluateBinaryFunctionWith:(NSRange)leftArgRange and:(NSRange)rightArgRange
{
    if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_strcmp"] == 0) {
        [self evaluateEDLValidationStrcmpWith:leftArgRange 
                                          and:rightArgRange];
        
    } else if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_biggerThan"] == 0) {
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:LIT_BIGGERTHAN];
        
    } else if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_lowerThan"] == 0) {
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:LIT_LOWERTHAN];
    }
}
-(void)evaluateEDLValidationStrcmpWith:(NSRange)leftArgRange and:(NSRange)rightArgRange
{
    if (leftArgRange.length == 1
        && rightArgRange.length == 1) {
        COEDLValidatorToken* leftToken  = [mTokens objectAtIndex:leftArgRange.location];
        COEDLValidatorToken* rightToken = [mTokens objectAtIndex:rightArgRange.location];
        if (([leftToken mKind] == PARAMETER_TOKEN || [leftToken mKind] == STRING_TOKEN)
            && ([rightToken mKind] == PARAMETER_TOKEN || [rightToken mKind] == STRING_TOKEN)) {
            // Both function parameters are either a string or a rule parameter.
            
            COEDLValidatorToken* resultToken;
            
            if ([[leftToken mValue] compare:[rightToken mValue]] == 0) {
                resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"TRUE"];
            } else {
                resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
            }
            [mTokens replaceObjectAtIndex:(leftArgRange.location - 1) withObject:resultToken];
            [resultToken release];
            [self removePair:leftArgRange.location and:rightArgRange.location];
            
        } else {
            // TODO: Error: wrong type for strcmp - or just return false?
        }
    } else {
        // TODO: Error or/and false?
    }
}
-(void)evaluateEDLValidationCompare:(NSRange)leftArgRange 
                                and:(NSRange)rightArgRange 
                       withOperator:(enum COLiteralComparisonOperator)op
{
    if (leftArgRange.length == 1
        || rightArgRange.length == 1) {
        COEDLValidatorToken* leftToken  = [mTokens objectAtIndex:leftArgRange.location];
        COEDLValidatorToken* rightToken = [mTokens objectAtIndex:rightArgRange.location];
        if (([leftToken mKind] == PARAMETER_TOKEN || [leftToken mKind] == NUMBER_TOKEN)
            && ([rightToken mKind] == PARAMETER_TOKEN || [rightToken mKind] == NUMBER_TOKEN)) {
            // Both function parameters are either a number or a rule parameter.
            
            COEDLValidatorToken* resultToken;
            
            double leftValue  = [[leftToken mValue] doubleValue];
            double rightValue = [[rightToken mValue] doubleValue];
            if ((leftValue > rightValue && op == LIT_BIGGERTHAN)
                || (leftValue < rightValue && op == LIT_LOWERTHAN)) {
                resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"TRUE"];
            } else {
                resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
            }
            [mTokens replaceObjectAtIndex:(leftArgRange.location - 1) withObject:resultToken];
            [resultToken release];
            [self removePair:leftArgRange.location and:rightArgRange.location];
        }
        
    } else {
        // Evaluate arith. terms and try again.
        [self evaluateTokensOver:leftArgRange];
        
        rightArgRange.location = leftArgRange.location + 1;
        [self evaluateTokensOver:rightArgRange];
        
        leftArgRange.length  = 1;
        rightArgRange.length = 1;
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:op];
    }

}
// END Binary function evaluation.

// BEGIN Arithmetic term evaluation.
-(void)evaluateBinaryOperation:(enum COLiteralArithmeticOperation)op at:(NSUInteger)index
{
    if (index > 0 && index < ([mTokens count] - 1)) {
        
        double leftValue  = [[[mTokens objectAtIndex:index - 1] mValue] doubleValue];
        double rightValue = [[[mTokens objectAtIndex:index + 1] mValue] doubleValue];

        
        if (op == LIT_MULTIPLICATION) {
            leftValue *= rightValue;
        } else if (op == LIT_DIVISION) {
            leftValue /= rightValue;
        } else if (op == LIT_ADDITION) {
            leftValue += rightValue;
        } else  if (op == LIT_SUBTRACTION) {
            leftValue -= rightValue;
        }
        
        COEDLValidatorToken* resultToken = [[COEDLValidatorToken alloc] initWithKind:NUMBER_TOKEN 
                                                                            andValue:[[NSNumber numberWithDouble:leftValue] stringValue]];

        [mTokens replaceObjectAtIndex:(index - 1) withObject:resultToken];
        [resultToken release];
        [self removePair:index and:(index + 1)];
    } else {
        // TODO: syntax error
    }
}
// END Arithmetic term evaluation.


-(void)dealloc
{
    //[literalString release];
    //[mParameters release];
    [mTokens release];
    
    [super dealloc];
}

@end
