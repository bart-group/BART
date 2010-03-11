//
//  COEDLValidatorRule.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Represents a rule used for validating the logical consistency
 * of an EDL file/configuration.
 */
@interface COEDLValidatorRule : NSObject {
    
    /** Rule identifier (should be unique). */
    NSString* mRuleID;
    /** Rule parameters with values from an EDL file/configuration. */
    NSDictionary* mRarameters;
    /** An array of COEDLValidatorLiteral objects that represents 
     *  all premises of the rule.
     */
    NSArray* mPremises;
    /** An array of COEDLValidatorLiteral objects that represents 
     *  all conclusions of the rule.
     */
    NSArray* mConclusions;
    /** A message providing detailed information why the rule is violated. */
    NSString* mMessage;
    
    /** Stores error information that occured while checking the rule. */
    NSError* mError;

}

/**
 * Initializes an allocated COEDLValidatorRule object.
 */
-(id)initWithRuleID:(NSString*)rID
         Parameters:(NSDictionary*)par 
           Premises:(NSArray*)pre 
        Conclusions:(NSArray*)con 
         AndMessage:(NSString*)msg;

/**
 * Evaluates the rule and checks.
 *
 * \return Boolean indicating whether the rule is 
 *         satisfied or not. If NO you might want
 *         to check mError.
 */
-(BOOL)isSatisfied;

@property (readonly) NSString* mRuleID;
@property (readonly) NSDictionary* mParameters;
@property (readonly) NSArray* mPremises;
@property (readonly) NSArray* mConclusions;
@property (readonly) NSString* mMessage;
@property (readonly) NSError* mError;

@end
