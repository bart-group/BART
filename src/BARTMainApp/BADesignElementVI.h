//
//  BADesignElementVI.h
//  BARTCommandLine
//
//  Created by First Last on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADesignElement.h"
#include <viaio/Vlib.h>
#include <viaio/VImage.h>
#include <viaio/mu.h>
#include <viaio/option.h>

#include "BlockIO.h"

@interface BADesignElementVI : BADesignElement
{
    VImage mDesign;
}

-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;
-(void)LoadDesignFromFile:(NSString*)path; 

@end

