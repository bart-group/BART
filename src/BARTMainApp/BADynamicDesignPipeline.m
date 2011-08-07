//
//  BADynamicDesignPipeline.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/6/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

/*
 * This class is intended to deal with all the stuff needed dor dynamic designs
 * * deal with external sources
 * * ask stimulus what's going on and on what the actual stimuli depend on
 * * ask externaö sources if everything is fine
 * * know what to do otherwise from the config
 * * and setup all this in a valid design immediately that can then directly used by ProcedureController
 */

#import "BADynamicDesignPipeline.h"
#import "../CLETUS/COExperimentContext.h"
#import "BARTSerialIOFramework/BARTSerialPortIONotifications.h"

@interface BADynamicDesignPipeline (PrivateMethods)

@end



@implementation BADynamicDesignPipeline

@synthesize designElement;

COSystemConfig *config;


//NSString* const kPrefixBundleIDStr = @"de.mpg.cbs.BARTSerialIO";
//NSArray* loadPluginsSerialIO();

-(id)init
{
	
	if ((self = [super init])){
		
		
		config = [[COExperimentContext getInstance] systemConfig];
		
		
		
		

		
	}
	return self;
}

-(BOOL) initDesign
{
	if (nil != designElement){
		[designElement release];
		designElement = nil;}
	
	designElement = [[NEDesignElement alloc] initWithDynamicData];
	if (nil == designElement){
		return FALSE;}
	
	return TRUE;
}



-(void)dealloc
{

	[designElement release];
	
	[super dealloc];
}



@end
