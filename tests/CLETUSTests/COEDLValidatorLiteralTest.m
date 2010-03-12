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
//    COEDLValidatorLiteral* literal1 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"(4 * (3 + (1 + 1) * 2) + 5)" //@"strc('hehe','hey')+foo(abc==cde) + -1 + 2.0" 
//                                                                             andParameters:nil];
//    COEDLValidatorLiteral* literal2 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_exists(foobar)"
//                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal3 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_strcmp('foo', 'bar')"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal4 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_strcmp('foo', 'foo')"
                                                                             andParameters:nil];
    
//    enum COLiteralValue literalValue1 = [literal1 getValue];
//    enum COLiteralValue literalValue2 = [literal2 getValue];
//    enum COLiteralValue literalValue3 = [literal3 getValue];
    enum COLiteralValue literalValue4 = [literal4 getValue];
    
    //STAssertEquals(LIT_FALSE, literalValue1, @"literalValue1 not as expected!");
    //STAssertEquals(LIT_FALSE, literalValue2, @"literalValue2 not as expected!");
//    STAssertEquals(LIT_FALSE, literalValue3, @"literalValue3 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue4, @"literalValue4 not as expected!");
}

-(void)tearDown
{
}


@end
