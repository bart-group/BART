//
//  BAProcedureController.h
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADataElement.h"
#import "BADesignElement.h"


@interface BAProcedureController : NSObject {
    
    BADataElement* mRawDataElement;
    
    BADesignElement* mDesignEl;
    
    unsigned int   mCurrentTimestep;

}

-(void)newDataDidArrive:(NSNotification*)aNotification;


@end
