//
//  COEDLValidatorLiteral.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COEDLValidatorLiteral.h"
#import "COEDLValidatorToken.h"


//
//
// TODO: mit negativen Zahlen aufpassen - Vorzeichen wird als Symbol aufgefasst! 
//       Es werden immer nur positive Zahlen geparst!
// 
//


@interface COEDLValidatorLiteral (PrivateStuff)

/** String representing the whole literal. */ 
NSString*           literalString = nil;

/** Dictionary of all parameters that are in scope
 *  of the literal. */
NSDictionary*       mParameters;

/** Analysed literalString, split into tokens of type COEDLValidatorToken. */
NSMutableArray*     parsedTokens;

/** Storing the value of the literal if already evaluated. */
enum COLiteralValue value;

/** Error information if something went wrong during the parse process. */
NSError*            error;

/**
 * Splits the literalString into an array of COEDLValidatorToken objects
 * prepared for evaluation.
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
 * Evaluates the array parsedTokens and stores the result
 * in mValue.
 */
-(void)evaluateTokens;

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

    
    parsedTokens = [[NSMutableArray alloc] initWithCapacity:0];
    value = LIT_FALSE;
    error = nil;
    
    return self;
}

-(enum COLiteralValue)getValue 
{    
    if ([parsedTokens count] == 0) {
        int cur = 0;
        while (cur < [literalString length]) {
            [self tokenize:&cur];
        }
        
        [self evaluateTokens];
    }
    
    return value;
}

-(NSError*)getError
{
    return error;
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
                    value = LIT_ERROR;
                    error = [NSError errorWithDomain:@"Cannot parse '=' at the end of the literal string." code:INCORRECT_SYNTAX userInfo:nil];
                }
                
            }
            @catch (NSException * e) {
                value = LIT_ERROR;
                error = [NSError errorWithDomain:@"Cannot parse '=' at the end of the literal string." code:INCORRECT_SYNTAX userInfo:nil];
            }
            break;

        default:
            value = LIT_ERROR;
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"Unsupported symbol at position %d in literal string.", (*cur) + 1] 
                                        code:INCORRECT_SYNTAX 
                                    userInfo:nil];
            break;
    }
    
    [parsedTokens addObject:token];
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
    [parsedTokens addObject:token];
    [token release];
    [buffer release];
}

-(void)parseString:(int*)cur
{
    if ((*cur) >= [literalString length] - 1) {
        value = LIT_ERROR;
        error = [NSError errorWithDomain:@"Beginning string (character ') at the end of the literal string." code:INCORRECT_SYNTAX userInfo:nil];
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
                value = LIT_ERROR;
                error = [NSError errorWithDomain:@"Broken string at the end of the literal." code:INCORRECT_SYNTAX userInfo:nil];
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
        value = LIT_ERROR;
        error = [NSError errorWithDomain:@"Broken string (missing string terminator) at the end of the literal." 
                                    code:INCORRECT_SYNTAX userInfo:nil];
    } else {
        COEDLValidatorToken* token = [[COEDLValidatorToken alloc] initWithKind:STRING_TOKEN 
                                                                      andValue:buffer];
        [parsedTokens addObject:token];
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
                value = LIT_ERROR;
                NSString* errorString = 
                    [NSString stringWithFormat:@"Malformed decimal point number (no position after the decimal point) at position %d in literal.", (*cur) + 1];
                error = [NSError errorWithDomain:errorString 
                                            code:INCORRECT_SYNTAX userInfo:nil];
            }

        } else {
            value = LIT_ERROR;
            error = [NSError errorWithDomain:@"Broken number format at the end of the literal (number that dosn't have any position after the decimal point discovered)." 
                                        code:INCORRECT_SYNTAX userInfo:nil];
        }
    }
    
    if (value != LIT_ERROR) {
        COEDLValidatorToken* token = [[COEDLValidatorToken alloc] initWithKind:NUMBER_TOKEN 
                                                                      andValue:buffer];
        [parsedTokens addObject:token];
        [token release];
    }
    
    [buffer release];
}

-(void)evaluateTokens
{
    FILE* fp = fopen("/tmp/cletusTest.txt", "w");
    for (COEDLValidatorToken* token in parsedTokens) {
        fputc(48 + [token kind], fp);
        fputc(' ', fp);
        fputs([[token value] cStringUsingEncoding:NSUTF8StringEncoding], fp);
        fputc('\n', fp);
    }
    fclose(fp);
}

-(void)dealloc
{
    //[literalString release];
    //[mParameters release];
    [parsedTokens release];
    
    [super dealloc];
}

@end
