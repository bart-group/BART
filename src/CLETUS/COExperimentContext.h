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

-(NSError*)resetWithEDLFile:(NSString*)edlPath;

-(BOOL)addOberserver:(id)object forProtocol:(NSString*)protocolName;


@end
