//
//  RORegistrationMethod.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistrationMethod.h"

@implementation RORegistrationMethod

-(id)initFindingTransform:(EDDataElement*)fun
                  anatomy:(EDDataElement*)ana
                reference:(EDDataElement*)ref
{
    if (self = [super init]) {
        
    }
    
    return self;
}

-(EDDataElement*)apply:(EDDataElement*)toAlign
{
    return nil;
}

@end
