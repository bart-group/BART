//
//  COEDLValidatorLiteral.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "COEDLValidatorLiteral.h"
#import "COEDLValidatorToken.h"


enum COLiteralComparisonOperator {
    LIT_BIGGERTHAN,
    LIT_EQUAL_OR_BIGGERTHAN,
    LIT_LOWERTHAN,
    LIT_EQUAL_OR_LOWERTHAN
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
-(void)tokenize:(NSUInteger*)cur;

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
-(void)parseSymbol:(NSUInteger*)cur;
-(void)parseWord:(NSUInteger*)cur;
-(void)parseString:(NSUInteger*)cur;
/* Numbers have to match the reg. expr.: [0-9]{1,*}[[\.[0-9]{1,*}]?    
 *                                 e.g.: 2, 90.02, 100.100, 5.0 */
-(void)parseNumber:(NSUInteger*)cur;

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

/*###### Evaluation functions. ######*/
/**
 * Recursively evaluates the array parsedTokens
 * (Terms enclosed in brackets and arithmetic
 *  expressions).
 *
 * \param range Defines the subsequence of parsedTokens
 *              that should be evaluated.
 */
-(void)evaluateTokensOver:(NSRange)range;
/**
 * Recursively evaluates terms enclosed in bracket.
 * The given range can be wider than the actual term.
 *
 * \param range Defines the subsequence of parsedTokens
 *              that should be evaluated.
 */
-(void)evaluateBracketsOver:(NSRange)range;
/**
 * Recursively evaluates an arithmetic term without
 * brackets.
 *
 * \param range Defines the subsequence of parsedTokens
 *              that should be evaluated.
 */
-(void)evaluateArithmeticTermOver:(NSRange)range;

/*###### Utility functions. ######*/
/**
 * Removes 2 tokens in one step. 
 *
 * \param leftIndex  Index of the left token that should be removed.
 * \param rightIndex Index of the right token that should be removed.
 */
-(void)removePair:(NSUInteger)leftIndex and:(NSUInteger)rightIndex;
/**
 * Returns the index of a given symbol token contained in 
 * instance variable mTokens.
 * 
 * \param symbol The symbol to search for.
 * \param range  The range to search within mTokens for symbol.
 * \return       The index of the symbol in mTokens (lies within range)
 *               Returns [mTokens count] in case the symbol is not 
 *               found/outside the range.
 */
-(NSUInteger)indexOfSymbol:(NSString*)symbol inRange:(NSRange)range;
/**
 * Returns the range of the first innermost bracket pair in a
 * possibly wider term (that can contain additional bracket pairs)
 * specified by range.
 * 
 * \param range Subsequence of mTokens that should be search for
 *              an innermost bracket pair.
 * \return      Range of the bracket pair (including both brackets).
 *              Returns range of location = 0 and length = 0 if no
 *              pair is found.
 */
-(NSRange)rangeOfInnermostBracketPairIn:(NSRange)range;
/**
 * Checks whether an opening bracket specified by bracketIndex
 * is a parameter delimiter of a predefined function.
 *
 * \param bracketIndex Index of the opening bracket in mTokens.
 * \return             YES if bracket is part of a function body.
 */
-(BOOL)isFunctionOpeningBracket:(NSUInteger)bracketIndex;
/**
 * Checks wether the symbol minus is an unary minus (sign) relative
 * to the subsequence of mTokens specified by range.
 *
 * \param minusIndex Index of the minus symbol token in mTokens that
 *                   could be an unary minus. Should be within range -
 *                   otherwise returns NO.
 * \param range      Range in mTokens.
 * \return           YES if minusIndex is beginning of range.
 *                   Also YES if it is followed by a number/parameter token and
 *                             preceded by <b>no</b> number/parameter token!
 *                   No otherwise or minusIndex out of range.
 */
-(BOOL)isUnaryMinus:(NSUInteger)minusIndex inRange:(NSRange)range;
/**
 * Checks whether a given word represents an EDL
 * function. Predefined EDL functions are:
 *
 * - edlValidation_biggerThan
 * - edlValidation_equalOrBiggerThan
 * - edlValidation_lowerThan
 * - edlValidation_equalOrLowerThan
 * - edlValidation_exists
 * - edlValidation_strIsEqual
 *
 * \param word Word token that might represent an EDL function.
 * \return     YES if word is EDL function, NO otherwise.
 */
-(BOOL)isPredefinedEDLFunction:(NSString*)word;

/*###### Evaluation of predefined unary functions. ######*/
/**
 * Chooses the right predefined unary function that precedes the 
 * parameter given by argumentRange.
 *
 * \param argumentRange Range of the function parameter.
 */
-(void)evaluateUnaryFunctionWith:(NSRange)argumentRange;
/**
 * Evaluates the predefined EDL function edlValidation_exists
 * for the parameter given by argumentRange.
 *
 * \param argumentRange Range of the function parameter.
 */
-(void)evaluateEDLValidationExistsWith:(NSRange)argumentRange;

/*###### Evaluation of predefined binary functions. ######*/
/**
 * Chooses the right predefined binary function that precedes the left
 * parameter given by leftArgRange.
 *
 * \param leftArgRange  Range of the left/first function parameter.
 * \param rightArgRange Range of the right/second function parameter.
 */
-(void)evaluateBinaryFunctionWith:(NSRange)leftArgRange and:(NSRange)rightArgRange;
/**
 * Evaluates the predefined EDL function edlValidation_strIsEqual for the 
 * parameters given by leftArgRange and rightArgRange.
 * (Checks wether both strings are equal by characters)
 *
 * \param leftArgRange  Range of the left/first argument.
 * \param rightArgRange Range of the right/second argument.
 */
-(void)evaluateEDLValidationStrcmpWith:(NSRange)leftArgRange and:(NSRange)rightArgRange;
/**
 * Evaluates the predefined EDL functions edlValidation_biggerThan,
 * edlValidation_lowerThan (decision based on parameter op).
 *
 * \param leftArgRange  Range of the left/first argument for comparison.
 * \param rightArgRange Range of the right/second argument for comparison.
 * \param op            The EDL comparison function that should be chosen.
 */
-(void)evaluateEDLValidationCompare:(NSRange)leftArgRange 
                                and:(NSRange)rightArgRange 
                       withOperator:(enum COLiteralComparisonOperator)op;

/*###### Evaluation of arithmetic terms and predefined equals functions (for numbers) ######*/
/**
 * Evaluates the unary minus operator.
 *
 * \param minusIndex Index of the unary minus operator in instance variable mTokens.
 */
-(void)evaluateUnaryMinus:(NSUInteger)minusIndex;
/**
 * Evaluates a binary arithmetic operation (multiplication, division, additon and
 * subtraction).
 *
 * \param op    The operation to perform.
 * \param index The index of the arithmetic operator in instance variable mTokens.
 */
// TODO: op information redundant ---> exists in the symbol token string
-(void)evaluateBinaryOperation:(enum COLiteralArithmeticOperation)op at:(NSUInteger)index;
/**
 * Evaluates an equals expression for numbers.
 *
 * \param equalsIndex Index of the equals sign in mTokens.
 */
-(void)evaluateEquals:(NSUInteger)equalsIndex;

@end


@implementation COEDLValidatorLiteral

@synthesize literalString;

-(id)initWithLiteralString:(NSString*)literal 
             andParameters:(NSDictionary*)params
{
    if ((self = [super init]))
    {
        literalString = literal;//[literal copy];
        if (params) {
            mParameters = params;
        } else {
            mParameters = [NSDictionary dictionary];
        }
        
        mTokens = [[NSMutableArray alloc] initWithCapacity:0];
        litValue = LIT_FALSE;
    }
    return self;
}

-(enum COLiteralValue)getValue 
{    
    if ([mTokens count] == 0) {
        // Tokenize...
        NSUInteger cur = 0;
        while (cur < [literalString length] && litValue != LIT_ERROR) {
            [self tokenize:&cur];
        }
        
        // Evaluate...
        if ([mTokens count] > 0 && litValue != LIT_ERROR) {
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
        }
        
        // Get value from last token that is left after
        // evaluation.
        if ([mTokens count] == 1 && litValue != LIT_ERROR) {
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

-(void)tokenize:(NSUInteger*)cur
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

-(void)parseSymbol:(NSUInteger*)cur
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
                }
                
            }
            @catch (NSException * e) {
                litValue = LIT_ERROR;
            }
            break;

        default:
            litValue = LIT_ERROR;
            break;
    }
    
    [mTokens addObject:token];
    [token release];
}

-(void)parseWord:(NSUInteger*)cur
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

-(void)parseString:(NSUInteger*)cur
{
    if ((*cur) >= [literalString length] - 1) {
        litValue = LIT_ERROR;
        return;
    }
    
    (*cur)++; // Skip string beginning.
    
    NSMutableString* buffer = [[NSMutableString alloc] initWithString:@""];
    unichar character;
    BOOL stringEndFound = NO;
    
    while (!stringEndFound
           && ((*cur) < [literalString length])
           && litValue != LIT_ERROR) {
        
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
    
    if (!stringEndFound || litValue == LIT_ERROR) {
        litValue = LIT_ERROR;
    } else {
        COEDLValidatorToken* token = [[COEDLValidatorToken alloc] initWithKind:STRING_TOKEN 
                                                                      andValue:buffer];
        [mTokens addObject:token];
        [token release];
    }
    
    [buffer release];
}

-(void)parseNumber:(NSUInteger*)cur
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
            }

        } else {
            litValue = LIT_ERROR;
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

-(void)evaluateTokensOver:(NSRange)range
{
    [self evaluateBracketsOver:range];
    [self evaluateArithmeticTermOver:range];
}
-(void)evaluateBracketsOver:(NSRange)range
{
    if (litValue == LIT_ERROR) {
        return;
    }
//    // TODO: remove output
//    FILE* fp = fopen("/tmp/cletusTest.txt", "a");
//    fputc('\n', fp);
//    fputc('B', fp);
//    fputc(' ', fp);
//    for (COEDLValidatorToken* token in mTokens) {
//        fputs([[token mValue] cStringUsingEncoding:NSUTF8StringEncoding], fp);
//    }
//    fclose(fp);
//    // END output
    
    NSRange bracketRange = [self rangeOfInnermostBracketPairIn:range];
    if (bracketRange.length != 0) {
        NSUInteger openingBracketIndex = bracketRange.location;
        NSUInteger closingBracketIndex = bracketRange.location + bracketRange.length - 1;
        NSUInteger seperatorIndex = [self indexOfSymbol:@"," inRange:bracketRange];
        
        if ([self isFunctionOpeningBracket:openingBracketIndex]) {
            if (seperatorIndex < [mTokens count]) {
                // Binary function
                [self removePair:openingBracketIndex and:closingBracketIndex];
                [mTokens removeObjectAtIndex:seperatorIndex - 1];
                
                NSRange leftArgRange;
                leftArgRange.location  = openingBracketIndex;
                leftArgRange.length    = seperatorIndex - openingBracketIndex - 1;
                [self evaluateTokensOver:leftArgRange];
                
                NSRange rightArgRange;
                rightArgRange.location = openingBracketIndex + 1;
                rightArgRange.length   = closingBracketIndex - seperatorIndex - 1;
                [self evaluateTokensOver:rightArgRange];
                
                if (leftArgRange.length != 0
                    && rightArgRange.length != 0) {
                    leftArgRange.length  = 1;
                    rightArgRange.length = 1;
                    // TODO: argRanges redundant
                    
                } else {
                    leftArgRange.length  = 0;
                    rightArgRange.length = 0;
                }
                [self evaluateBinaryFunctionWith:leftArgRange and:rightArgRange];
            } else {
                // Unary function
                [self removePair:openingBracketIndex and:closingBracketIndex];
                
                NSRange argumentRange;
                argumentRange.location = openingBracketIndex;
                argumentRange.length   = closingBracketIndex - openingBracketIndex - 1;

                [self evaluateUnaryFunctionWith:argumentRange];
            }
        } else {
            if (seperatorIndex == [mTokens count]) {
                // Encapsulation
                [self removePair:openingBracketIndex and:closingBracketIndex];
                NSRange evalRange;
                evalRange.location = bracketRange.location;
                evalRange.length   = bracketRange.length - 2;
                [self evaluateTokensOver:evalRange];
            } else {
                litValue = LIT_ERROR;
            }
        }
        NSRange recursionRange;
        recursionRange.location = range.location;
        recursionRange.length   = range.length - bracketRange.length + 1;
        [self evaluateBracketsOver:recursionRange];
    }
}
-(void)evaluateArithmeticTermOver:(NSRange)range
{     
    if (litValue == LIT_ERROR) {
        return;
    }
//    // TODO: remove output
//    FILE* fp = fopen("/tmp/cletusTest.txt", "a");
//    fputc('\n', fp);
//    fputc('A', fp);
//    fputc(' ', fp);
//    for (COEDLValidatorToken* token in mTokens) {
//        fputs([[token mValue] cStringUsingEncoding:NSUTF8StringEncoding], fp);
//    }
//    fclose(fp);
//    // END output

    // Unary minus
    NSUInteger symbolIndex    = [self indexOfSymbol:@"-" inRange:range];
    if (symbolIndex < [mTokens count]) {
        if ([self isUnaryMinus:symbolIndex inRange:range]) {
            [self evaluateUnaryMinus:symbolIndex];
            NSRange newRange;
            newRange.location = range.location;
            newRange.length   = range.length - 1;
            [self evaluateArithmeticTermOver:newRange];
            return;
        }
    }
    
    // Multiplication, division
    symbolIndex               = [self indexOfSymbol:@"*" inRange:range];
    NSUInteger altSymbolIndex = [self indexOfSymbol:@"/" inRange:range];
    if (symbolIndex != altSymbolIndex) {
        if (symbolIndex < altSymbolIndex) {
            [self evaluateBinaryOperation:LIT_MULTIPLICATION at:symbolIndex];
        } else if (symbolIndex > altSymbolIndex) {
            [self evaluateBinaryOperation:LIT_DIVISION at:altSymbolIndex];
        }
        NSRange newRange;
        newRange.location = range.location;
        newRange.length   = range.length - 2;
        [self evaluateArithmeticTermOver:newRange];
        return;
    } 
    
    // Addition, subtraction
    symbolIndex               = [self indexOfSymbol:@"+" inRange:range];
    altSymbolIndex            = [self indexOfSymbol:@"-" inRange:range];
    if (symbolIndex != altSymbolIndex) {
        if (symbolIndex < altSymbolIndex) {
            [self evaluateBinaryOperation:LIT_ADDITION at:symbolIndex];
        } else if (symbolIndex > altSymbolIndex) {
            [self evaluateBinaryOperation:LIT_SUBTRACTION at:altSymbolIndex];
        }
        NSRange newRange;
        newRange.location = range.location;
        newRange.length   = range.length - 2;
        [self evaluateArithmeticTermOver:newRange];
        return;
    }
    
    // Equals
    symbolIndex               = [self indexOfSymbol:@"==" inRange:range];
    if (symbolIndex < [mTokens count]) {
        [self evaluateEquals:symbolIndex];
    }
}

-(void)removePair:(NSUInteger)leftIndex and:(NSUInteger)rightIndex
{
    [mTokens removeObjectAtIndex:leftIndex];
    [mTokens removeObjectAtIndex:rightIndex - 1];
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
-(NSRange)rangeOfInnermostBracketPairIn:(NSRange)range
{
    NSUInteger openingBracketIndex = 0;
    NSUInteger closingBracketIndex = 0;
    int bracketPairNr = 0;
    int maxBracketPairNr = 0;
    BOOL openingBracketFound = NO;
    BOOL closingBracketFound = NO;

    NSUInteger lookupIndex = range.location;
    while (!closingBracketFound
           && (lookupIndex < (range.location + range.length))
           && (lookupIndex < [mTokens count])) {
        
        COEDLValidatorToken* lookupToken = [mTokens objectAtIndex:lookupIndex];
        
        if ([lookupToken mKind] == SYMBOL_TOKEN) {
            NSString* lookupTokenValue = [lookupToken mValue];
            
            if ([lookupTokenValue compare:@"("] == 0) {
                bracketPairNr++;
                if (bracketPairNr > maxBracketPairNr) {
                    maxBracketPairNr = bracketPairNr;
                    openingBracketIndex = lookupIndex;
                    openingBracketFound = YES;
                }
            } else if ([lookupTokenValue compare:@")"] == 0) {
                bracketPairNr--;
                if (bracketPairNr == maxBracketPairNr - 1
                    || bracketPairNr == 0) {
                    closingBracketIndex = lookupIndex;
                    closingBracketFound = YES;
                }
            }
        }
        lookupIndex++;
    }
    
    NSRange bracketPairRange;
    if (closingBracketFound && openingBracketFound) {
        bracketPairRange.location = openingBracketIndex;
        bracketPairRange.length   = closingBracketIndex - openingBracketIndex + 1;
    } else {
        bracketPairRange.location = 0;
        bracketPairRange.length   = 0;
    }
    return bracketPairRange;
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
-(BOOL)isUnaryMinus:(NSUInteger)minusIndex inRange:(NSRange)range
{
    if (minusIndex == range.location) {
        return YES;
    } else if (minusIndex > range.location
               && minusIndex < (range.location + range.length - 1)
               && minusIndex < ([mTokens count] - 1)) {
        enum COTokenKind possibleLeftOperandKind = [[mTokens objectAtIndex:minusIndex - 1] mKind];
        enum COTokenKind rightOperandKind        = [[mTokens objectAtIndex:minusIndex + 1] mKind];
        
        // Left operand is no number/parameter, right operand is number/parameter
        if ((possibleLeftOperandKind != NUMBER_TOKEN
             && possibleLeftOperandKind != PARAMETER_TOKEN)
            && (rightOperandKind == NUMBER_TOKEN
                || rightOperandKind == PARAMETER_TOKEN)) {
            return YES;
        }
    } 
               
    return NO;
}
-(BOOL)isPredefinedEDLFunction:(NSString*)word
{
    if ([word compare:@"edlValidation_biggerThan"] == 0
        || [word compare:@"edlValidation_lowerThan"] == 0
        || [word compare:@"edlValidation_equalOrBiggerThan"] == 0
        || [word compare:@"edlValidation_lowerThan"] == 0
        || [word compare:@"edlValidation_equalOrLowerThan"] == 0
        || [word compare:@"edlValidation_exists"] == 0
        || [word compare:@"edlValidation_strIsEqual"] == 0) {
        return YES;
    }
    
    return NO;
}

-(void)evaluateUnaryFunctionWith:(NSRange)argumentRange
{
    if ([[[mTokens objectAtIndex:argumentRange.location - 1] mValue] compare:@"edlValidation_exists"] == 0) {
        [self evaluateEDLValidationExistsWith:argumentRange];
    }
}
-(void)evaluateEDLValidationExistsWith:(NSRange)argumentRange
{
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
            litValue = LIT_ERROR;
        }
    } else {
        resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
        [mTokens replaceObjectAtIndex:(argumentRange.location - 1) withObject:resultToken];
        [resultToken release];
    }
}

-(void)evaluateBinaryFunctionWith:(NSRange)leftArgRange and:(NSRange)rightArgRange
{
    if (leftArgRange.length == 0 || rightArgRange.length == 0) {
        [mTokens removeAllObjects];
        litValue = LIT_FALSE;
        COEDLValidatorToken* resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
        [mTokens addObject:resultToken];
        [resultToken release];
        return;
    }
    
    if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_strIsEqual"] == 0) {
        [self evaluateEDLValidationStrcmpWith:leftArgRange 
                                          and:rightArgRange];
        
    } else if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_biggerThan"] == 0) {
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:LIT_BIGGERTHAN];
        
    } else if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_equalOrBiggerThan"] == 0) {
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:LIT_EQUAL_OR_BIGGERTHAN];
    } else if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_lowerThan"] == 0) {
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:LIT_LOWERTHAN];
    } else if ([[[mTokens objectAtIndex:leftArgRange.location - 1] mValue] compare:@"edlValidation_equalOrLowerThan"] == 0) {
        [self evaluateEDLValidationCompare:leftArgRange 
                                       and:rightArgRange 
                              withOperator:LIT_EQUAL_OR_LOWERTHAN];
    }
}
-(void)evaluateEDLValidationStrcmpWith:(NSRange)leftArgRange and:(NSRange)rightArgRange
{
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
        litValue = LIT_ERROR;
    }
}
-(void)evaluateEDLValidationCompare:(NSRange)leftArgRange 
                                and:(NSRange)rightArgRange 
                       withOperator:(enum COLiteralComparisonOperator)op
{
    COEDLValidatorToken* leftToken  = [mTokens objectAtIndex:leftArgRange.location];
    COEDLValidatorToken* rightToken = [mTokens objectAtIndex:rightArgRange.location];
    if (([leftToken mKind] == PARAMETER_TOKEN || [leftToken mKind] == NUMBER_TOKEN)
        && ([rightToken mKind] == PARAMETER_TOKEN || [rightToken mKind] == NUMBER_TOKEN)) {
        // Both function parameters are either a number or a rule parameter.
        
        COEDLValidatorToken* resultToken;
        
        double leftValue  = [[leftToken mValue] doubleValue];
        double rightValue = [[rightToken mValue] doubleValue];
        if ((leftValue > rightValue && op == LIT_BIGGERTHAN)
            || (leftValue >= rightValue && op == LIT_EQUAL_OR_BIGGERTHAN)
            || (leftValue < rightValue && op == LIT_LOWERTHAN)
            || (leftValue <= rightValue && op == LIT_EQUAL_OR_LOWERTHAN)) {
            resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"TRUE"];
        } else {
            resultToken = [[COEDLValidatorToken alloc] initWithKind:BOOLEAN_TOKEN andValue:@"FALSE"];
        }
        [mTokens replaceObjectAtIndex:(leftArgRange.location - 1) withObject:resultToken];
        [resultToken release];
        [self removePair:leftArgRange.location and:rightArgRange.location];
    }
}

-(void)evaluateUnaryMinus:(NSUInteger)minusIndex
{
    if (minusIndex < ([mTokens count] - 1)) {
        COEDLValidatorToken* operandToken = [mTokens objectAtIndex:minusIndex + 1];
        if ([operandToken mKind] == NUMBER_TOKEN
            || [operandToken mKind] == PARAMETER_TOKEN) {
            double operandValue = [[operandToken mValue] doubleValue];
            operandValue *= -1.0;
            COEDLValidatorToken* resultToken = [[COEDLValidatorToken alloc] initWithKind:NUMBER_TOKEN 
                                                                                andValue:[[NSNumber numberWithDouble:operandValue] stringValue]];
            
            [mTokens replaceObjectAtIndex:minusIndex withObject:resultToken];
            [resultToken release];
            [mTokens removeObjectAtIndex:minusIndex + 1];
        } else {
            litValue = LIT_ERROR;
        }
    } else {
        litValue = LIT_ERROR;
    }
}
-(void)evaluateBinaryOperation:(enum COLiteralArithmeticOperation)op 
                            at:(NSUInteger)index
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
        litValue = LIT_ERROR;
    }
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
            litValue = LIT_ERROR;
        }
    } else {
        litValue = LIT_ERROR;
    }
}

-(void)dealloc
{
    [mTokens release];
    
    [super dealloc];
}

@end
