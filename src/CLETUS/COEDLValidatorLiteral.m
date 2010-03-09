//
//  COEDLValidatorLiteral.m
//  BARTApplication
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

NSString*           literalString = nil;
NSMutableArray*     parsedTokens;
enum COLiteralValue value;
NSError*            error;

-(void)tokenize:(int*)cur;

-(BOOL)isBeginOfSymbol:(unichar)character;
-(BOOL)isBeginOfWord:(unichar)character;
-(BOOL)isBeginOfString:(unichar)character;
-(BOOL)isDigit:(unichar)character;

-(void)parseSymbol:(int*)cur;
-(void)parseWord:(int*)cur;
-(void)parseString:(int*)cur;
-(void)parseNumber:(int*)cur;

-(void)evaluateTokens;

@end

@implementation COEDLValidatorLiteral

-(id)initWithLiteralString:(NSString*)literal
{
    literalString = [literal copy];
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
            cur++;
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
    }
    
    if ([self isBeginOfWord:character]) {
        [self parseWord:cur];
    }
    
    if ([self isBeginOfString:character]) {
        [self parseString:cur];
    }
    
    if ([self isDigit:character]) {
        [self parseNumber:cur];
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
            token = [[COEDLValidatorToken alloc] initWithKind:SYMBOL_TOKEN 
                                                     andValue:[NSString stringWithFormat:@"%c", [literalString characterAtIndex:*cur]]];
            (*cur)++;
            break;
        case '=':
            @try {
                if ('=' == [literalString characterAtIndex:(*cur) + 1]) {
                    token = [[COEDLValidatorToken alloc] initWithKind:SYMBOL_TOKEN 
                                                             andValue:[NSString stringWithString:@"=="]];
                    
                    (*cur) += 2;
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
    unichar character;
    
    /* While cur is in the boundaries of literalString and the
     * character is either a letter, a number or the underscore
     * fill buffer.                                            
     */
    while (([self isDigit:character]
           || [self isBeginOfWord:character]
           || character == '_')
           && ((*cur) < [literalString length])) {
        
        character = [literalString characterAtIndex:(*cur)];
        [buffer appendFormat:@"%c", character];
        
        (*cur)++;
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
            (*cur)++;
        
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
    
}

-(void)evaluateTokens
{
}

-(void)dealloc
{
    [literalString release];
    [parsedTokens release];
    [error release];
    
    [super dealloc];
}

@end
