//
//  COEDLValidatorRule.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface COEDLValidatorRule : NSObject {
    
    NSArray* params;
    NSArray* premises;
    NSArray* conclusions;
    NSString* errorMessage;

}

-(BOOL)satisfied;

@end
