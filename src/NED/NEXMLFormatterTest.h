//
//  NEXMLFormatterTest.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/10/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@class COSystemConfig;
@class NETimetable;


@interface NEXMLFormatterTest : SenTestCase {
    
    COSystemConfig* config;
    NSMutableArray* mediaObjects;
    NETimetable* timetable;
    
}

@end
