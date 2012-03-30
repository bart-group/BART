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
NEPresentationExternalConditionController *externalConditions;
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
            externalConditions = [[NEPresentationExternalConditionController alloc] initWithConstraints:constraintsArray];
            [presentationController setExternalConditions:externalConditions];
            
            [viewManager showAllWindows:nil];
            [timetable release];
        }
        
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [presentationController release];
    [externalConditions release];
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
    NSMutableArray* mediaObjects = [NSMutableArray arrayWithCapacity:[[expConfig systemConfig] countNodes:@"$mediaObjects/mediaObject"]];
    
    for (NSUInteger moCounter = 0; moCounter < [[expConfig systemConfig] countNodes:@"$mediaObjects/mediaObject"]; moCounter++ ) 
    {    
        NEMediaObject* obj = [[NEMediaObject alloc] 
                              initWithConfigEntry:[NSString stringWithFormat:@"$mediaObjects/mediaObject[%d]", moCounter+1]];
        if (obj) {
            [mediaObjects addObject:obj];
        } else {
            NSLog(@"Could not build media object!");
            // TODO: error!
        }
        [obj release];
    }
    
    return mediaObjects;
}

-(NSArray*)buildConstraints
{
    NSMutableArray* constraints = [NSMutableArray arrayWithCapacity:[[expConfig systemConfig] countNodes:@"$constraints/constraint"]];
    NSLog(@"count nodes constraints: %lu", [[expConfig systemConfig] countNodes:@"$constraints/constraint"]);
    
    for (NSUInteger constraintCounter = 0; constraintCounter < [[expConfig systemConfig] countNodes:@"$constraints/constraint"]; constraintCounter++ ) {
        NEConstraint* constraint = [[NEConstraint alloc] 
                                    initWithConfigEntry:[NSString stringWithFormat:@"$constraints/constraint[%d]", constraintCounter+1]];
        if (constraint) {
            [constraints addObject:constraint];
        } else {
            NSLog(@"Could not build constraint list!");
            // TODO: error!
        }
        
        [constraint release];
        
    }
    
    return constraints;
}


@end
