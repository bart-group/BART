//
//  COExperimentContext.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COSystemConfig.h"
#import "NED/NEDesignElement.h"
#import "EDNA/EDDataElement.h"


extern NSString * const BARTDidResetExperimentContextNotification;

@interface COExperimentContext : NSObject <NSCopying> {
    COSystemConfig *systemConfig; 
    NSDictionary *dictSerialIOPlugins;
    NEDesignElement *designElemRef;
    EDDataElement *anatomyElemRef;
    EDDataElement *functionalOrigDataRef;

}

@property (readonly) COSystemConfig *systemConfig; 
@property (readonly) NSDictionary *dictSerialIOPlugins;
@property (readwrite, retain) NEDesignElement *designElemRef;
@property (readwrite, retain) EDDataElement *anatomyElemRef;
@property (readwrite, retain) EDDataElement *functionalOrigDataRef;;


/**
 * Return the singleton COExperimentContext object.
 *
 * \return COExperimentContext object.
 */
+ (COExperimentContext*)getInstance;

-(NSError*)resetWithEDLFile:(NSString*)edlPath;


@end
