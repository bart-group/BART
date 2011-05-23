//
//  BADynamicDesignController.m
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

#import "BADynamicDesignController.h"
#import "../CLETUS/COSystemConfig.h"
#import "../../../BARTSerialIOFramework/BARTSerialPortIONotifications.h"

@interface BADynamicDesignController (PrivateMethods)

-(void)setupSerialPortEyeTrac;
-(void)setupSerialPortTriggerAndButtonBox;
-(BOOL) pluginClassIsValid:(Class)pluginClass;
-(NSArray*) loadPluginWithID:(NSString*)bundleIDStr;

-(void)triggerArrived:(NSNotification*)aNotification;
-(void)buttonWasPressed:(NSNotification*)aNotification;
@end



@implementation BADynamicDesignController

@synthesize designElement;
@synthesize serialPortEyeTrac;
@synthesize serialPortTriggerAndButtonBox;

COSystemConfig *config;

BOOL useSerialPortEyeTrac;
BOOL useSerialPortTriggerAndButtonBox;
NSError *err;
NSThread *eyeTracThread;
NSThread *triggerThread;


//NSString* const kPrefixBundleIDStr = @"de.mpg.cbs.BARTSerialIO";
//NSArray* loadPluginsSerialIO();

-(id)init
{
	
	if (self = [super init]){
		
		
		config = [COSystemConfig getInstance];
		
		
		
		// setup the serial port for the eye tracker device
		//TODO get from config:
		useSerialPortEyeTrac = NO;
		if (YES == useSerialPortEyeTrac){
			[self setupSerialPortEyeTrac];
		}

		// setup the serial port for the eye tracker device
		//TODO get from config
		useSerialPortTriggerAndButtonBox = YES;
		if (YES == useSerialPortTriggerAndButtonBox){
			[self setupSerialPortTriggerAndButtonBox];
		}
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(triggerArrived:)
													 name:BARTSerialIOScannerTriggerArrived object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(triggerArrived:)
													 name:BARTSerialIOButtonBoxPressedKey object:nil];
		
	}
	return self;
}

-(BOOL) initDesign
{
	if (nil != designElement){
		[designElement release];
		designElement = nil;}
	
	designElement = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	if (nil == designElement){
		return FALSE;}
	
	return TRUE;
}

-(void)setupSerialPortEyeTrac
{
	//TODO: get from config
	NSString *devPath = [[NSString alloc] initWithString:@"cu.usbserial"];
	NSString *descr = @"ASLEyeTrac";
	
	serialPortEyeTrac = [[SerialPort alloc] initSerialPortWithDevicePath:devPath deviceDescript:descr
															  symbolrate:57600 parity:PARNON andBits:CS8];
	
	//TODO: get from config
	NSString* const bundleIDStr = @"de.mpg.cbs.BARTSerialIO.BARTSerialIOPluginEyeTrac";
	NSArray *bundleArray = [self loadPluginWithID:bundleIDStr];
	
	//NSBundle *curBundle = nil;
	NSEnumerator *instanceEnum = [bundleArray objectEnumerator];
	size_t i = 0;
	while ([instanceEnum nextObject]) {
		
		id interpretSerialIO = [bundleArray objectAtIndex:i];
		NSLog(@"%@", interpretSerialIO);
		if (YES == [self pluginClassIsValid:interpretSerialIO])
		{
			[serialPortEyeTrac addObserver: interpretSerialIO];
		}
		i++;
	}
	
	err = [[NSError alloc] init];
	eyeTracThread = [[NSThread alloc] initWithTarget:serialPortEyeTrac selector:@selector(start:) object:err]; //TODO error object    
	[eyeTracThread start];
}

-(void)setupSerialPortTriggerAndButtonBox
{
	//TODO: get from config
	NSString *devPath = [[NSString alloc] initWithString:@"cu.usbserial-FTDWH1DI"];
	NSString *descr = @"TriggerAndButtonBox";
	
	serialPortTriggerAndButtonBox = [[SerialPort alloc] initSerialPortWithDevicePath:devPath deviceDescript:descr
															  symbolrate:19200 parity:PARNON andBits:CS8];
	
	//TODO: get from config
	NSString* const bundleIDStr = @"de.mpg.cbs.BARTSerialIO.BARTSerialIOPluginFTDITriggerButton";
	NSArray *bundleArray = [self loadPluginWithID:bundleIDStr];
	NSLog(@"bundleArray size: %d", [bundleArray count]);
	
	//NSBundle *curBundle = nil;
	NSEnumerator *instanceEnum = [bundleArray objectEnumerator];
	size_t i = 0;
	while ([instanceEnum nextObject]) {
		
		id interpretSerialIO = [bundleArray objectAtIndex:i];
		NSLog(@"%@", interpretSerialIO);
		if (YES == [self pluginClassIsValid:interpretSerialIO])
		{
			[serialPortTriggerAndButtonBox addObserver: interpretSerialIO];
		}
		i++;
	}
	
	err = [[NSError alloc] init];
	triggerThread = [[NSThread alloc] initWithTarget:serialPortTriggerAndButtonBox selector:@selector(start:) object:err]; //TODO error object    
	[triggerThread start];
}


// -------------------------------------------------------------------------------
//	loadPlugins:
// -------------------------------------------------------------------------------
-(NSArray*) loadPluginWithID:(NSString*)bundleIDString
//NSArray* loadPluginsSerialIO()
{
	NSMutableArray* bundleInstanceList = [[NSMutableArray alloc] init];
	
	NSMutableArray* bundlePaths = [NSMutableArray array];
	
	// our built bundles are found inside the app's "PlugIns" folder -
	NSMutableArray*	bundleSearchPaths = [NSMutableArray array];
	NSString* folderPath = [[NSBundle mainBundle] builtInPlugInsPath];
	[bundleSearchPaths addObject: folderPath];
	
	// to search other locations for bundles
	// (i.e. $(HOME)/Library/Application Support/BundleLoader
	
	NSString* currPath;
	NSArray* librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSEnumerator* searchPathEnum = [librarySearchPaths objectEnumerator];
    while (currPath = [searchPathEnum nextObject])
    {
		[bundleSearchPaths addObject: currPath];
    }
	
	
    searchPathEnum = [bundleSearchPaths objectEnumerator];
	while (currPath = [searchPathEnum nextObject])
    {
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        if (bundleEnum)
        {
            while (currBundlePath = [bundleEnum nextObject])
            {
                if ([[currBundlePath pathExtension] isEqualToString:@"bundle"])
                {
					// we found a bundle, add it to the list
					[bundlePaths addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
                }
            }
        }
    }
	
	// now that we have all bundle paths, start finding the ones we really want to load -
	//NSRange searchRange = NSMakeRange(0, [kPrefixBundleIDStr length]);
	NSRange searchRange = NSMakeRange(0, [bundleIDString length]);
	
	NSEnumerator* pathEnum = [bundlePaths objectEnumerator];
    while (currPath = [pathEnum nextObject])
    {
        NSBundle* currBundle = [NSBundle bundleWithPath:currPath];
        if (currBundle)
        {
			NSString* tbundleID = [currBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
			
			// check the bundle ID to see if it starts with our known ID string (bundleIDString)
			// we want to only load the bundles we care about:
			//
			//if ([bundleIDStr compare:kPrefixBundleIDStr options:NSLiteralSearch range:searchRange] == NSOrderedSame)
			if ([tbundleID compare:bundleIDString options:NSLiteralSearch range:searchRange] == NSOrderedSame)
					
			{
				//TODO: VALIDATE THE PROTOCOL HERE
				// load and startup our bundle
				//
				// note: principleClass method actually loads the bundle for us,
				// or we can call [currBundle load] directly.
				//
				
				Class currPrincipalClass = [currBundle principalClass];
				if (currPrincipalClass)
				{
					id currInstance = [[currPrincipalClass alloc] init];
					if (currInstance)
					{
						[bundleInstanceList addObject:[currInstance autorelease]];
					}
				}
			}
        }
    }
	
	NSArray *finalBundleArray = [[NSArray alloc] initWithArray: bundleInstanceList] ;
	[bundleInstanceList release];
	
	return finalBundleArray;
	
}

//BOOL pluginClassIsValid(Class pluginClass)
-(BOOL) pluginClassIsValid:(Class)pluginClass
{
	
	if ([pluginClass conformsToProtocol:@protocol(BARTSerialIOProtocol)])
	{//
		//		if ([pluginClass instancesRespondToSelector:@selector(valueArrived:)] &&
		//			[pluginClass instancesRespondToSelector:@selector(pluginTitle)] &&
		//			[pluginClass instancesRespondToSelector:@selector(pluginDescription)] &&
		//			[pluginClass instancesRespondToSelector:@selector(pluginIcon)] )
		{
			NSLog(@"Descr: %@", [pluginClass pluginDescription]);
			return YES;
		}
	}
	
	//if ([pluginClass conformsToProtocol:@protocol(...)])
	//	{
	//		if ([pluginClass instancesRespondToSelector:@selector(...)] &&
	//			[pluginClass instancesRespondToSelector:@selector(...)] &&
	//			[pluginClass instancesRespondToSelector:@selector(...)] &&
	//			[pluginClass instancesRespondToSelector:@selector(...)] )
	//		{
	//			return YES;
	//		}
	//	}
	
	return NO;
	
	
	
	
}

-(void)triggerArrived:(NSNotification*)aNotification
{
	NSLog(@"The arrived trigger is: %@", [aNotification object]);
}

-(void)buttonWasPressed:(NSNotification*)aNotification
{
	NSLog(@"The button pressed was: %@", [aNotification object]);
}


-(void)dealloc
{

	[designElement release];
	[serialPortEyeTrac release];
	[serialPortTriggerAndButtonBox release];
	[super dealloc];
}



@end
