//
//  COEDLValidatorRule.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "COEDLValidatorRule.h"
#import "COEDLValidatorLiteral.h"
#import "COErrorCode.h"


@interface COEDLValidatorRule (PrivateStuff) 
    
/**
 * Returns the value of an literal array when each
 * literal is AND-associated.
 *
 * \param literals An array of COEDLValidatorLiteral objects.
 * \return         The AND-associated value of those literals.
 */
-(BOOL)valueOfConjunctedLiterals:(NSArray*)literals;

@end


@implementation COEDLValidatorRule

@synthesize mRuleID;
@synthesize mParameters;
@synthesize mPremises;
@synthesize mConclusions;
@synthesize mMessage;

@synthesize mError;

-(id)initWithRuleID:(NSString*)rID
         Parameters:(NSDictionary*)par 
           Premises:(NSArray*)pre 
        Conclusions:(NSArray*)con 
         AndMessage:(NSString*)msg
{
    if (self = [super init]) {
        mRuleID       = [rID retain];
        mParameters   = [par retain];
        mPremises     = [pre retain];
        mConclusions  = [con retain];
        mMessage      = [msg retain];
        
        mError = nil;
    }
    
    return self;
}

-(BOOL)isSatisfied
{
//    BOOL premisesSatisfied = [self valueOfConjunctedLiterals:mPremises];
//    BOOL conclusionsSatisfied = [self valueOfConjunctedLiterals:mConclusions];
//    
//    // Return value of implication: premisesSatisfied ==> conclusionsSatisfied
//    //           which is equal to: NOT(premisesSatisfied) OR conclusionsSatisfied
//    return (!premisesSatisfied || conclusionsSatisfied);
    
    if ([self valueOfConjunctedLiterals:mPremises]) {
        return [self valueOfConjunctedLiterals:mConclusions];
    } else {
        return YES;
    }
}

-(BOOL)valueOfConjunctedLiterals:(NSArray*)literals
{
    BOOL conjunctedValue = YES;
    for (COEDLValidatorLiteral* literal in literals) {
        enum COLiteralValue literalValue = [literal getValue];
        
        if (literalValue == LIT_FALSE) {
            conjunctedValue = NO;
        }
        if (literalValue == LIT_ERROR) {
            conjunctedValue = NO;
            mError = [NSError errorWithDomain:@"Incorrect syntax in literal." 
                                         code:INCORRECT_SYNTAX
                                     userInfo:nil];
        }
    }
    
    return conjunctedValue;
}

-(void)dealloc
{
    [mRuleID release];
    [mParameters release];
    [mPremises release];
    [mConclusions release];
    [mMessage release];
    
    [super dealloc];
}

@end
