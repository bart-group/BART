//
//  COEDLValidatorToken.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "COEDLValidatorToken.h"


@implementation COEDLValidatorToken

@synthesize mKind;
@synthesize mValue;

-(id)init
{
    if (self = [super init]) {
        mKind  = EMPTY_TOKEN;
        mValue = [[NSString alloc] initWithString:@""];
    }
    
    return self;
}

-(id)initWithKind:(enum COTokenKind)aKind 
         andValue:(NSString*)aValue
{
    mKind  = aKind;
    mValue = [aValue retain];
    
    return self;
}

-(void)dealloc
{
    [mValue release];
    [super dealloc];
}


@end
