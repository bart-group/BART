//
//  COExperimentContext.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COSystemConfig.h"

extern NSString * const BARTDidResetExperimentContextNotification;

@interface COExperimentContext : NSObject <NSCopying> {
    COSystemConfig *systemConfig; 
}

@property (readonly) COSystemConfig *systemConfig; 


/**
 * Return the singleton COExperimentContext object.
 *
 * \return COExperimentContext object.
 */
+ (COExperimentContext*)getInstance;

-(NSError*)resetWithEDLFile:(NSString*)edlPath;


@end
