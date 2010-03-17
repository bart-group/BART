//
//  COEDLValidatorLiteralTest.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/10/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "COEDLValidatorLiteralTest.h"
#import "COEDLValidatorLiteral.h"


@implementation COEDLValidatorLiteralTest

-(void)setUp
{
}

-(void)testGetValue
{
    COEDLValidatorLiteral* literal1 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"42 * 1 == 42" 
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal2 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_exists(foobar)"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal3 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_strIsEqual('foo', 'bar')"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal4 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_strIsEqual('foo', 'foo')"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal5 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_biggerThan(1, 42)"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal6 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_biggerThan(53 - 11, 2 * 3)"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal7 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"((edlValidation_lowerThan(1, 42)))"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal8 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"((0 + 1) * 2) == 5"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal9 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"((((((2 * (3 + (4 + 5))))) == ((2 + 2) * 5) + 4)))"
                                                                             andParameters:nil];
    COEDLValidatorLiteral* literal10 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"-2 * 4 == 1 * -8"
                                                                              andParameters:nil];
    COEDLValidatorLiteral* literal11 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"-2 * 4 == 1 * (-8)"
                                                                              andParameters:nil];
    COEDLValidatorLiteral* literal12 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_equalOrBiggerThan(42, 42 * 1 - 1);"
                                                                              andParameters:nil];
    COEDLValidatorLiteral* literal13 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_equalOrLowerThan(-42 * -1, 42);"
                                                                              andParameters:nil];
    COEDLValidatorLiteral* literal14 = [[COEDLValidatorLiteral alloc] initWithLiteralString:@"edlValidation_equalOrLowerThan(9001, -3);"
                                                                              andParameters:nil];
    
    enum COLiteralValue literalValue1 = [literal1 getValue];
    enum COLiteralValue literalValue2 = [literal2 getValue];
    enum COLiteralValue literalValue3 = [literal3 getValue];
    enum COLiteralValue literalValue4 = [literal4 getValue];
    enum COLiteralValue literalValue5 = [literal5 getValue];
    enum COLiteralValue literalValue6 = [literal6 getValue];
    enum COLiteralValue literalValue7 = [literal7 getValue];
    enum COLiteralValue literalValue8 = [literal8 getValue];
    enum COLiteralValue literalValue9 = [literal9 getValue];
    enum COLiteralValue literalValue10 = [literal10 getValue];
    enum COLiteralValue literalValue11 = [literal11 getValue];
    enum COLiteralValue literalValue12 = [literal12 getValue];
    enum COLiteralValue literalValue13 = [literal13 getValue];
    enum COLiteralValue literalValue14 = [literal14 getValue];
    
    STAssertEquals(LIT_TRUE, literalValue1, @"literalValue1 not as expected!");
    STAssertEquals(LIT_FALSE, literalValue2, @"literalValue2 not as expected!");
    STAssertEquals(LIT_FALSE, literalValue3, @"literalValue3 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue4, @"literalValue4 not as expected!");
    STAssertEquals(LIT_FALSE, literalValue5, @"literalValue5 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue6, @"literalValue6 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue7, @"literalValue7 not as expected!");
    STAssertEquals(LIT_FALSE, literalValue8, @"literalValue8 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue9, @"literalValue9 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue10, @"literalValue10 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue11, @"literalValue11 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue12, @"literalValue12 not as expected!");
    STAssertEquals(LIT_TRUE, literalValue13, @"literalValue13 not as expected!");
    STAssertEquals(LIT_FALSE, literalValue14, @"literalValue14 not as expected!");
}

-(void)tearDown
{
}


@end
