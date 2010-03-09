//
//  COEDLValidatorToken.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COEDLValidatorToken.h"


@implementation COEDLValidatorToken

@synthesize kind;
@synthesize value;

-(id)init
{
    kind  = EMPTY_TOKEN;
    value = @"";
    
    return self;
}

-(id)initWithKind:(enum COTokenKind)aKind 
         andValue:(NSString*)aValue
{
    kind  = aKind;
    value = [aValue copy];
    
    return self;
}

-(void)dealloc
{
    [value release];
    
    [super dealloc];
}


@end
