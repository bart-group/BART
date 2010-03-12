//
//  COEDLValidatorRule.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COEDLValidatorRule.h"
#import "COEDLValidatorLiteral.h"


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
    mRuleID       = [rID retain];
    mParameters   = [par retain];
    mPremises     = [pre retain];
    mConclusions  = [con retain];
    mMessage      = [msg retain];
    
    mError = nil;
    
    return self;
}

-(BOOL)isSatisfied
{
    BOOL premisesSatisfied = [self valueOfConjunctedLiterals:mPremises];
    BOOL conclusionsSatisfied = [self valueOfConjunctedLiterals:mConclusions];
    
    // Return value of implication: premisesSatisfied ==> conclusionsSatisfied
    //           which is equal to: NOT(premisesSatisfied) OR conclusionsSatisfied
    return (!premisesSatisfied || conclusionsSatisfied);
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
            // TODO: handle error!
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
    
    [mError release];
    
    [super dealloc];
}

@end