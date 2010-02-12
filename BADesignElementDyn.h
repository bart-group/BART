//
//  BADesignElementDyn.h
//  BARTApplication
//
//  Created by FirstLast on 1/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADesignElement.h"

typedef struct TrialStruct{
    int   id;
    float onset;
    float duration;         // in seconds
    float height;
} Trial;

typedef struct ComplexStruct {
    double re;
    double im;
} Complex;


@interface BADesignElementDyn : BADesignElement {

    Trial* trials;
    int numberTrials;
    int numberEvents;
    
}

-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;
-(void)generateDesign;

@end
