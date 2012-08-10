//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/12/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"

#import "CLETUS/COExperimentContext.h"
#import "BAProcedurePipeline.h"
#import "BARTNotifications.h"
#import "CLETUS/COExperimentContext.h"

#import "BASessionContext.h"


@interface BARTApplicationAppDelegate ()

-(void)setGUIBackgroundImage:(NSNotification*)aNotification;
-(void)setGUIResultImage:(NSNotification*)aNotification;
-(void)stopExperiment:(NSNotification*)aNotification;

@end


@implementation BARTApplicationAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{  
    #pragma unused(aNotification)
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setGUIBackgroundImage:)
												 name:BARTDidLoadBackgroundImageNotification object:nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setGUIResultImage:)
												 name:BARTDidCalcNextResultNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stopExperiment:)
												 name:BARTStopExperimentNotification object:nil];
    
    
    COExperimentContext *experimentContext = [COExperimentContext getInstance];
    
    
    //(1) load the app own config file to read test configuration stuff
    NSString *errDescr = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"ConfigBARTApplication.plist"];
    NSBundle *thisBundle;
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        thisBundle = [NSBundle bundleForClass:[self class]]; 
        plistPath = [thisBundle pathForResource:@"ConfigBARTApplication" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *arrayFromPlist = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML
                                                                                     mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                               format:&format 
                                                                                     errorDescription:&errDescr];
    if (!arrayFromPlist)
    {
        NSLog(@"Error reading plist from ConfigBARTApplication: %@, format: %lu", errDescr, format);
        return;
    }
	
    NSString *useLuigi = (NSString*)[arrayFromPlist objectForKey:@"UseLuigi"];
    //NSLog(@"UseLuigi = %@", useLuigi);
    if(useLuigi != nil && [useLuigi caseInsensitiveCompare:@"YES"] == NSOrderedSame) {
        //// Initial Luigi Testing ////
        NSLog(@"Using Luigi");

        NSString *edlPath = [arrayFromPlist objectForKey:@"edlFile"];
        NSString *treePath = [arrayFromPlist objectForKey:@"treeFile"];
//        [[BAHierarchyTreeContext instance] loadSessionTree:treePath withEDL:edlPath];

        
        [[BASessionContext sharedBASessionContext] createExampleSession];

        NSLog(@"[BART] called [BAContext createExampleSession]: %@", [[BASessionContext sharedBASessionContext] sessionTreeContent]);
        
        [NSBundle loadNibNamed:@"BigLuigi" owner:self];
        
    } else {
        guiController = [guiController initWithDefault];
        
        NSString *testData = [arrayFromPlist objectForKey:@"dataSetForTest"];
        
        if (nil != testData){
            procedurePipe = [[BAProcedurePipeline alloc] initWithTestDataset:testData];}
        else{
            procedurePipe = [[BAProcedurePipeline alloc] init];}
        
        
        NSString *file = [arrayFromPlist objectForKey:@"edlFile"];
        
        NSError *err = [experimentContext resetWithEDLFile:file];
        if (err) {
            NSLog(@"%@", err);
        }
        
        [experimentContext startExperiment];
	}
	
	
  }

-(void)setGUIBackgroundImage:(NSNotification*)aNotification
{
	//set this as background for viewer
	EDDataElement *elem = (EDDataElement*) [aNotification object];
	[guiController setBackgroundImage:elem];
}

-(void)setGUIResultImage:(NSNotification*)aNotification
{
	
	[guiController setForegroundImage:[aNotification object]];
}

-(void)applicationWillTerminate:(NSNotification*)aNotification
{
    #pragma unused(aNotification)
    NSLog(@"applicationWillTerminate: %@", aNotification);
    [procedurePipe release];
    [super dealloc];
}

-(void)stopExperiment:(NSNotification *)aNotification
{
    #pragma unused(aNotification)
    [[COExperimentContext getInstance] stopExperiment];
}	


-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)sender
{
    NSLog(@"applicationShouldTerminate: %@", sender);
    return NSTerminateNow;
}

@end
