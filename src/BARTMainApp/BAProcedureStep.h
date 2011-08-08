//
//  BAProcedureStep.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 7/28/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@interface BAProcedureStep : NSObject {
    
    BOOL configureComplete;
    BOOL workDone;
@private
    
}

@property (readonly, getter = isConfigureComplete) BOOL configureComplete;
@property (readonly, getter = isWorkDone ) BOOL workDone;

@end

#pragma mark -

@interface BAProcedureStep (AbstractMethods) 

-(NSError*)configureStep;
-(NSError*)runStep;

@end
