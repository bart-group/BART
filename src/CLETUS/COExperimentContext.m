//
//  COExperimentContext.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

// This class holds all the information about an experiment - the static configuration stuff as well as runtime information about currently loaded plugins and stuff like that.
// It's a Singleton so everybody in the application can use it.
// TODO: Add the COSystemConfig here and let's everybody ask this one about it - a lot of small changes to do :-)!

#import "COExperimentContext.h"
#import "COSystemConfig.h"
#import "BARTSerialIOFramework/BARTSerialPortIONotifications.h"
#import "BARTSerialIOFramework/SerialPort.h"

NSString * const BARTDidResetExperimentContextNotification = @"BARTDidResetExperimentContextNotification";



@interface COExperimentContext (PrivateMethods)

-(void)setupSerialPortEyeTrac;
-(void)setupSerialPortTriggerAndButtonBox;
-(BOOL) pluginClassIsValid:(Class)pluginClass;
-(NSArray*) loadPluginWithID:(NSString*)bundleIDStr;

-(void)triggerArrived:(NSNotification*)aNotification;
-(void)buttonWasPressed:(NSNotification*)aNotification;
-(NSError*)fillSystemConfigWithContentsOfEDLFile:(NSString*)edlPath;
-(NSError*)reset;
-(NSError*)initExternalDevices;

@end

@implementation COExperimentContext

static COExperimentContext *sharedExperimentContext = nil;

@synthesize systemConfig;

COSystemConfig *config;
BOOL useSerialPortEyeTrac;
BOOL useSerialPortTriggerAndButtonBox;
NSError *err;
NSThread *eyeTracThread;
NSThread *triggerThread;
SerialPort *serialPortEyeTrac;
SerialPort *serialPortTriggerAndButtonBox;



+ (COExperimentContext*)getInstance
{
    @synchronized(self) {
        if (sharedExperimentContext == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedExperimentContext;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedExperimentContext == nil) {
            sharedExperimentContext = [super allocWithZone:zone];
            return sharedExperimentContext;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

-(id)init
{
    if ((self = [super init])){
        systemConfig = [COSystemConfig getInstance];
    }
    
    return self;
}

-(NSError*)reset 
{
    return nil;
}

-(NSError*)resetWithEDLFile:(NSString*)edlPath
{
    NSError *err = nil;
    
    if ( (err = [self reset]) != nil )
        return err;
    
    if ( (err = [self fillSystemConfigWithContentsOfEDLFile:edlPath]) != nil )
        return err;
    
    err = [self initExternalDevices];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTDidResetExperimentContextNotification object:nil];
    return err;

}

-(NSError*)fillSystemConfigWithContentsOfEDLFile:(NSString*)edlPath
{
    return [systemConfig fillWithContentsOfEDLFile:edlPath];
}


-(NSError*)initExternalDevices
{
    NSError *err = nil;
    // setup the serial port for the eye tracker device
    //TODO get from config
    useSerialPortTriggerAndButtonBox = NO;
    if (YES == useSerialPortTriggerAndButtonBox){
        [self setupSerialPortTriggerAndButtonBox];
    }
    // setup the serial port for the eye tracker device
    //TODO get from config:
    useSerialPortEyeTrac = NO;
    if (YES == useSerialPortEyeTrac){
        [self setupSerialPortEyeTrac];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(triggerArrived:)
                                                 name:BARTSerialIOScannerTriggerArrived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(buttonWasPressed:)
                                                 name:BARTSerialIOButtonBoxPressedKey object:nil];
    
    return err;
    
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

-(void)setupSerialPortEyeTrac
{
	//TODO: get from config
	NSString *devPath = [[NSString alloc] initWithString:@"cu.usbserial   "];
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
	eyeTracThread = [[NSThread alloc] initWithTarget:serialPortEyeTrac selector:@selector(startSerialPortThread:) object:err]; //TODO error object    
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
	NSLog(@"bundleArray size: %lu", [bundleArray count]);
	
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
	triggerThread = [[NSThread alloc] initWithTarget:serialPortTriggerAndButtonBox selector:@selector(startSerialPortThread:) object:err]; //TODO error object    
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
    while ((currPath = [searchPathEnum nextObject]))
    {
		[bundleSearchPaths addObject: currPath];
    }
	
	
    searchPathEnum = [bundleSearchPaths objectEnumerator];
	while ((currPath = [searchPathEnum nextObject]))
    {
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        if (bundleEnum)
        {
            while ((currBundlePath = [bundleEnum nextObject]))
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
    while ((currPath = [pathEnum nextObject]))
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


@end
