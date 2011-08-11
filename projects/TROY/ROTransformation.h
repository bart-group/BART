//
//  ROTransformation.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/11/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDDataElement;

@interface ROTransformation : NSObject {
    
}

-(EDDataElement*)transform:(EDDataElement*)element;

@end
