//
//  COEDLValidatorLiteralTest.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/10/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COEDLValidatorLiteralTest.h"
#import "COEDLValidatorLiteral.h"


@implementation COEDLValidatorLiteralTest

-(void)setUp
{
}

-(void)testGetValue
{
    COEDLValidatorLiteral* literal = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"strc('hehe','hey')+foo(abc==cde) + -1 + 2.0" 
                                                                            andParameters:nil];
    
    BOOL literalValue = [literal getValue];
}

-(void)tearDown
{
}


@end
