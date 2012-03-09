//
//  BAProcedureStep_Paradigm.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/4/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAProcedureStep_Paradigm.h"
#import "CLETUS/COExperimentContext.h"
#import "NED/NEDesignElement.h"
#import "NED/NEPresentationController.h"
#import "NED/NEPresentationExternalConditionController.h"
#import "NEPresentationLogger.h"
#import "NED/NEViewManager.h"
#import "../NED/NEConstraint.h"

@interface BAProcedureStep_Paradigm (PrivatMethods)

/**
 * Builds an autoreleased array of NEMediaObject-s
 * by querying the configuration (EDL).
 *
 * \return An array of NEMediaObjects.
 */
-(NSArray*)buildMediaObjects;

/**
 * Builds an autoreleased array of NEConstraints
 * by querying the configuration (EDL).
 *
 * \return An array of NEConstraints.
 */
-(NSArray*)buildConstraints;

///**
// * Builds an autoreleased dictionary of NEPresentationEvent objects
// * by querying the configuration (EDL).
// *
// * \param mediaObjects All media objects that were already build
// *                     on configuration data.
// * \return             An dictionary with media object IDs as keys
// *                     and NSArrays containing all NEPresentationEvent 
// *                     objects for one media object as values.
// */
//-(NSDictionary*)buildEventListWithMediaObjects:(NSArray*)mediaObjects;
//

@end



@implementation BAProcedureStep_Paradigm

//private members
COExperimentContext *expConfig;
NEPresentationController *presentationController;
NEPresentationExternalConditionController *externalCondition;
NEViewManager* viewManager;

- (id)init
{
    self = [super init];
    if (self) {
        expConfig = [COExperimentContext getInstance];
        
        
     //  designElement = [[NEDesignElement alloc] initWithDynamicData];
                
        //TODO : ask if Presentation is needed!!
        [NEPresentationLogger getInstance];
        
        //load mediaObjects and timetable
        
        NSArray* mediaObjects = nil;
        NETimetable* timetable = nil;
        NSArray* constraintsArray = nil;
        
        if ([[expConfig systemConfig] getProp:@"/rtExperiment/stimulusData"]) {
            mediaObjects = [self buildMediaObjects];
            timetable = [[NETimetable alloc] initWithConfigEntry:@"$timeTable" 
                                                 andMediaObjects:mediaObjects];
            constraintsArray = [self buildConstraints];
        }
        
        if (timetable) {
            viewManager = [[NEViewManager alloc] init];
            
            presentationController = [[NEPresentationController alloc] initWithView:viewManager
                                                                       andTimetable:timetable];
            
            //TODO: ask if it's a dynamic design
            //if(dynamicDesign)
            externalCondition = [[NEPresentationExternalConditionController alloc] initWithConstraints:constraintsArray];
            [presentationController setMExternalConditionController:externalCondition];
            
            [viewManager showAllWindows:nil];
            [timetable release];
        }
        
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [presentationController release];
    [externalCondition release];
    [viewManager release];
    [super dealloc];
}


-(void)doWhatIWant
{
   // presentationController 

}

-(NSError*)configureStep
{
    NSError *err = nil;
    
    
    
    
    
    return err;
}

-(NSError*)runStep
{
    NSError *err = nil;
    return err;
}

-(NSArray*)buildMediaObjects
{
    NSMutableArray* mediaObjects = [NSMutableArray arrayWithCapacity:0];
    
    NSUInteger mediaObjectCounter = 1;
    NSString* mediaObjectProp = [[expConfig systemConfig] getProp:@"$mediaObjects/mediaObject[1]"];
    
    while (mediaObjectProp) {
        NEMediaObject* obj = [[NEMediaObject alloc] 
                              initWithConfigEntry:[NSString stringWithFormat:@"$mediaObjects/mediaObject[%d]", mediaObjectCounter]];
        if (obj) {
            [mediaObjects addObject:obj];
        } else {
            NSLog(@"Could not build media object!");
            // TODO: error!
        }
        
        [obj release];
        
        mediaObjectCounter++;
        mediaObjectProp = [[expConfig systemConfig]  getProp:[NSString stringWithFormat:@"$mediaObjects/mediaObject[%d]", mediaObjectCounter]];
    }
    
    return mediaObjects;
}

-(NSArray*)buildConstraints
{
    NSMutableArray* constraints = [NSMutableArray arrayWithCapacity:0];
    
    NSUInteger constraintCounter = 1;
    NSString* constraintProp = [[expConfig systemConfig] getProp:@"$constraints/constraint[1]"];
    
    while (constraintProp) {
        NEConstraint* constraint = [[NEConstraint alloc] 
                                    initWithConfigEntry:[NSString stringWithFormat:@"$constraints/constraint[%d]", constraintCounter]];
        if (constraint) {
            [constraints addObject:constraint];
        } else {
            NSLog(@"Could not build constraint list!");
            // TODO: error!
        }
        
        [constraint release];
        
        constraintCounter++;
        constraintProp = [[expConfig systemConfig]  getProp:[NSString stringWithFormat:@"$constraints/constraint[%d]", constraintCounter]];
    }
    
    return constraints;
}


@end
