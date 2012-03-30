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
extern NSString * const BARTTriggerArrivedNotification;
//extern NSString * const BARTNextDataIncomeNotification;

@class EDDataElement;
@class NEDesignElement;

@protocol BARTScannerTriggerProtocol <NSObject>

-(void)terminusFromScannerArrived:(NSNotification*)aNotification;
-(void)triggerArrived:(NSNotification*)aNotification;

@end

@protocol BARTDataIncomeProtocol <NSObject>

-(void)dataArrived:(NSUInteger)tr;

@end

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

/**
 * load a new experiment configuration
 * \param edlPath the full path to an edl file containing the configuration for the experiment
 * \returns nil if it works correctly, an error object otherwise
 */
-(NSError*)resetWithEDLFile:(NSString*)edlPath;


/*
 * register as an observer for a special kind of protocol
 * \param object the one who wants to be the observer, mostly the calling object itself
 * \param protocolName the name of the protocol 
 * \returns YES, if everything works correctly, NO otherwise
 */
-(BOOL)addOberserver:(id)object forProtocol:(NSString*)protocolName;

/**
 * starts all components necessary to run the experiment
 * \returns nil if it works correctly, an error object otherwise
 */
-(NSError*)startExperiment;

/**
 * stops properly all components before ending the application
 * \returns nil if it works correctly, an error object otherwise
 */

-(NSError*)stopExperiment;



@end
