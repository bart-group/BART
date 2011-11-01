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
#import "NED/NEDesignElement.h"
#import "EDNA/EDDataElement.h"
#import "BARTNotifications.h"

NSString * const BARTDidResetExperimentContextNotification = @"de.mpg.cbs.BARTDidResetExperimentContextNotification";
NSString * const BARTTriggerArrivedNotification = @"de.mpg.cbs.BARTTriggerArrivedNotification";
//NSString * const BARTNextDataIncomeNotification = @"de.mpg.cbs.BARTNextDataIncomeNotification";


@interface COExperimentContext (PrivateMethods)

-(SerialPort*)setupSerialPortEyeTrac;
-(SerialPort*)setupSerialPortTriggerAndButtonBox;
-(BOOL) pluginClassIsValid:(Class)pluginClass;
-(NSArray*) loadPluginWithID:(NSString*)bundleIDStr;

-(void)triggerArrived:(NSNotification*)aNotification;
-(void)buttonWasPressed:(NSNotification*)aNotification;
-(NSError*)fillSystemConfigWithContentsOfEDLFile:(NSString*)edlPath;
-(NSError*)reset;
-(NSError*)configureExternalDevices;

@end

@implementation COExperimentContext

static COExperimentContext *sharedExperimentContext = nil;

@synthesize systemConfig;
@synthesize dictSerialIOPlugins;
@synthesize designElemRef;
@synthesize anatomyElemRef;
@synthesize functionalOrigDataRef;

COSystemConfig *config;
BOOL useSerialPortEyeTrac;
BOOL useSerialPortTriggerAndButtonBox;
//NSError *err;
NSThread *eyeTracThread;
NSThread *triggerThread;
//SerialPort *serialPortEyeTrac;
//SerialPort *serialPortTriggerAndButtonBox;


dispatch_queue_t serialDesignElementAccessQueue;


+ (COExperimentContext*)getInstance
{
    @synchronized(self) {
        if (sharedExperimentContext == nil) {
            sharedExperimentContext = [[self alloc] init]; 
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
        serialDesignElementAccessQueue = dispatch_queue_create("de.mpg.cbs.DesignElementAccesQueue", NULL);
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(NSError*)reset 
{
    if ([eyeTracThread isExecuting] ){
        [eyeTracThread cancel];
    }
    if ([triggerThread isExecuting]){
        [triggerThread cancel];}
    [dictSerialIOPlugins release];
    [designElemRef release];
    [anatomyElemRef release];
    [functionalOrigDataRef release];
    return nil;
}

-(NSError*)resetWithEDLFile:(NSString*)edlPath
{
    NSError *err = nil;
    
    if ( (err = [self reset]) != nil )
        return err;
    
    if ( (err = [self fillSystemConfigWithContentsOfEDLFile:edlPath]) != nil )
        return err;
    
    err = [self configureExternalDevices];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTDidResetExperimentContextNotification object:nil];
    return err;

}

-(NSError*)fillSystemConfigWithContentsOfEDLFile:(NSString*)edlPath
{
    return [systemConfig fillWithContentsOfEDLFile:edlPath];
}


-(NSError*)configureExternalDevices
{
    NSError *err = nil;
    NSMutableDictionary *mutableDictPlugins = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // setup the serial port for the eye tracker device
    //TODO get from config
    useSerialPortTriggerAndButtonBox = NO;
    if (YES == useSerialPortTriggerAndButtonBox){
        SerialPort *serialPortTriggerAndButtonBox = [[self setupSerialPortTriggerAndButtonBox] retain];
        if (nil != serialPortTriggerAndButtonBox){
            [mutableDictPlugins setObject:serialPortTriggerAndButtonBox forKey:[serialPortTriggerAndButtonBox deviceDescription]];
        }
        
    }
    // setup the serial port for the eye tracker device
    //TODO get from config:
    useSerialPortEyeTrac = NO;
    if (YES == useSerialPortEyeTrac){
        SerialPort* serialPortEyeTrac = [[self setupSerialPortEyeTrac] retain];
        if (nil != serialPortEyeTrac){
            [mutableDictPlugins setObject:serialPortEyeTrac forKey:[serialPortEyeTrac deviceDescription]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(triggerArrived:)
                                                 name:BARTSerialIOScannerTriggerArrived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(buttonWasPressed:)
                                                 name:BARTSerialIOButtonBoxPressedKey object:nil];
    
    dictSerialIOPlugins = [[NSDictionary alloc] initWithDictionary:mutableDictPlugins];
    [mutableDictPlugins removeAllObjects];
    [mutableDictPlugins release];
    return err;
    
}

-(BOOL)addOberserver:(id)object forProtocol:(NSString*)protocolName
{
    
    [object retain];
    
    
    if ( YES == [object conformsToProtocol:@protocol(BARTScannerTriggerProtocol)]  
        && (NSOrderedSame == [protocolName compare :@"BARTScannerTriggerProtocol"]) ) 
    {
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(triggerArrived:) name:BARTSerialIOScannerTriggerArrived object:nil];
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(triggerArrived:) name:BARTTriggerArrivedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(terminusFromScannerArrived:) name:BARTScannerSentTerminusNotification object:nil];
        
        return YES;
        
    }
    
    
    if ( YES == [object conformsToProtocol:@protocol(BARTDataIncomeProtocol)]  
        && (YES == [protocolName compare:@"BARTDataIncomeProtocol"]) )
    {
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(dataArrived:) name:BARTDidLoadNextDataNotification object:nil];
        
        return YES;
        
    }

    
    [object release];
    return NO;
    
    
}



- (id)copyWithZone:(NSZone *)zone
{
    #pragma unused(zone)
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

-(SerialPort*)setupSerialPortEyeTrac
{
	//TODO: get from config
	NSString *devPath = [[NSString alloc] initWithString:@"/dev/cu.usbserial"];
	NSString *descr = @"ASLEyeTrac";
	
	SerialPort *serialPortEyeTrac = [[SerialPort alloc] initSerialPortWithDevicePath:devPath deviceDescript:descr
															  symbolrate:57600 parity:PARNON andBits:CS8];
	
	//TODO: get from config
	NSString* const bundleIDStr = @"de.mpg.cbs.BARTSerialIO.BARTSerialIOPluginEyeTrac";
	NSArray *bundleArray = [[self loadPluginWithID:bundleIDStr] retain];
	
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
	
	NSError *err = [[NSError alloc] init];
	eyeTracThread = [[NSThread alloc] initWithTarget:serialPortEyeTrac selector:@selector(startSerialPortThread:) object:err]; //TODO error object    
	[eyeTracThread start];
    [devPath release];
    [err release];
    [bundleArray release];
    return [serialPortEyeTrac autorelease];
}

-(SerialPort*)setupSerialPortTriggerAndButtonBox
{
	//TODO: get from config
	NSString *devPath = [[NSString alloc] initWithString:@"/dev/cu.usbserial-FTDWFENV"];
	NSString *descr = @"TriggerAndButtonBox";
	
	SerialPort *serialPortTriggerAndButtonBox = [[SerialPort alloc] initSerialPortWithDevicePath:devPath deviceDescript:descr
                                                                          symbolrate:19200 parity:PARNON andBits:CS8];
	
	//TODO: get from config
	NSString* const bundleIDStr = @"de.mpg.cbs.BARTSerialIO.BARTSerialIOPluginFTDITriggerButton";
	NSArray *bundleArray = [[self loadPluginWithID:bundleIDStr] retain];
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
	
	NSError *err = [[NSError alloc] init];
	triggerThread = [[NSThread alloc] initWithTarget:serialPortTriggerAndButtonBox selector:@selector(startSerialPortThread:) object:err]; //TODO error object    
	[triggerThread start];
    [devPath release];
    [err release];
    [bundleArray release];
    return [serialPortTriggerAndButtonBox autorelease];
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
	
	return [finalBundleArray autorelease];
	
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

-(void)setDesign:(NEDesignElement*)newDesign
{
    dispatch_sync(serialDesignElementAccessQueue, ^{
        designElemRef = newDesign;
    });
    
}

-(NEDesignElement*)getDesign
{
    __block NEDesignElement *resDesign;
    dispatch_sync(serialDesignElementAccessQueue, ^{
        resDesign = [designElemRef copy];
    });
    
    return resDesign;
    
}

@end
