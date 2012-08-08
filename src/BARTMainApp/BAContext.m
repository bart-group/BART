//
//  BAContext.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/26/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAContext.h"
#import "BAAddExperimentAccessoryViewControllerViewController.h"


#import <dispatch/once.h>


@interface BAContext ()

- (void)buildTreeForView;

@end


@implementation BAContext 
    

#pragma mark -
#pragma mark Local Properties

@synthesize instance;

@synthesize currentSession;
@synthesize sessionTreeContent = sessionTreeContent;

#pragma mark -
#pragma mark Property Methods 'currentSession'

- (BASession2*)currentSession
{
    return currentSession;
}


- (void)setCurrentSession:(BASession2 *)newCurrentSession
{
    if(newCurrentSession != currentSession) {
        [self willChangeValueForKey:@"currentSession"];
        if(currentSession != nil) {
            [currentSession release];
        }
        currentSession = newCurrentSession;
        [currentSession retain];
        NSLog(@"[BAContext setCurrentSession] currentSession changed to: %@", currentSession);
        NSLog(@"[currentSession retainCount] %lu", [currentSession retainCount]);
        [self buildTreeForView];
        NSLog(@"[BAContext setCurrentSession] after building tree: _sessionTreeContent = %@", sessionTreeContent);
        [self willChangeValueForKey:@"currentSession"];
    }
}

#pragma mark -
#pragma mark Property Methods 'currentSession'

 - (NSArray*)sessionTreeContent
{
    NSLog(@"[BAContext sessionTreeContent] called ... returning %@", sessionTreeContent);
    return sessionTreeContent;
}


#pragma mark -
#pragma mark Session Tree Related

- (void)buildTreeForView
{
    NSLog(@"[BAContext buildTreeForView] called");
    NSMutableArray *experiments = [NSMutableArray arrayWithObjects: nil];
    for (BAExperiment2 *experiment in [currentSession experiments]) {
        NSMutableArray *steps = [NSMutableArray arrayWithObjects: nil];
        for(BAStep2 *step in [experiment steps]) {
            [steps addObject:[[BASessionTreeNode alloc] initWithObject:step children:nil]];
            NSLog(@"[BAContext buildTreeForView] added step: %@", [steps lastObject]);
        }
        [experiments addObject:[[BASessionTreeNode alloc] initWithObject:experiment children:steps]];
        NSLog(@"[BAContext buildTreeForView] added experiment: %@", [experiments lastObject]);
    }
    BASessionTreeNode *sessionNode = [[BASessionTreeNode alloc] initWithObject:currentSession children:experiments];
    NSLog(@"[BAContext buildTreeForView] added session: %@", sessionNode);
    sessionTreeContent = [NSArray arrayWithObjects:sessionNode, nil];
    NSLog(@"[BAContext buildTreeForView] new sessionTreeContent: %@", sessionTreeContent);
}

- (IBAction)addExperiment:(id)sender
{
    NSOpenPanel *chooseEDLFilePanel = [[NSOpenPanel openPanel] retain];
    
    BAAddExperimentAccessoryViewControllerViewController *accessoryViewController = [[BAAddExperimentAccessoryViewControllerViewController alloc] initWithNibName:@"AddExperimentAccessoryView" bundle:nil];
    
    [chooseEDLFilePanel setCanChooseFiles:YES];
    [chooseEDLFilePanel setCanChooseDirectories:NO];
    [chooseEDLFilePanel setAllowsMultipleSelection:NO];
    [chooseEDLFilePanel setAllowedFileTypes:[NSArray arrayWithObject:@"edl"]];
    [chooseEDLFilePanel setAllowsOtherFileTypes:YES];
    [chooseEDLFilePanel setTitle:@"Add Experiment (with EDL File)"];
    
    [chooseEDLFilePanel setAccessoryView:[accessoryViewController view]];

     [chooseEDLFilePanel beginSheetModalForWindow:[sender window] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            
            NSLog(@"[chooseEDLFilePanel beginSheetModalForWindow] selected URL: %@", [chooseEDLFilePanel URL]);
        }
        
        [chooseEDLFilePanel release];
    }];
}


- (NSArray*)registeredExperimentTypes
{
    NSLog(@"[BAExperiment2 subclasses]: %@", [BAExperiment2 subclasses]);
    
    return [BAExperiment2 subclasses];
}

#pragma mark -
#pragma mark Debug/Testing Related

- (void)createExampleSession
{
    NSLog(@"[BAContext createExampleSession] called");

    BAStep2 *step001 = [[BAStep2 alloc] initWithName:@"Step 001" description:@"Description of Step 001"]; 
    BAStep2 *step002 = [[BAStep2 alloc] initWithName:@"Step 002" description:@"Description of Step 002"]; 
    BAStep2 *step003 = [[BAStep2 alloc] initWithName:@"Step 003" description:@"Description of Step 003"]; 
    BAStep2 *step004 = [[BAStep2 alloc] initWithName:@"Step 004" description:@"Description of Step 004"]; 
    BAStep2 *step005 = [[BAStep2 alloc] initWithName:@"Step 005" description:@"Description of Step 005"]; 

    BAExperiment2 *experiment001 = [[BAExperiment2 alloc] initWithName:@"Experiment 001"
                                                           description:@"Description of Experiment 001"
                                                                 steps:[NSMutableArray arrayWithObjects:step001, step002, step003, step004, step005, nil]];
    
    BASession2 *session001 = [[BASession2 alloc] initWithName:@"Session 001" description:@"Description of Session 001" experiments:[NSMutableArray arrayWithObjects:experiment001, nil]];
    
    NSLog(@"[BAContext createExampleSession] setting currentSession to: %@", session001);
    [self setCurrentSession:session001];
}

#pragma mark -
#pragma mark Singleton Implementation

+ (BAContext*)sharedBAContext {
    NSLog(@"[BAContext sharedBAContext] called");
	static dispatch_once_t predicate;
	static BAContext *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (BAContext*)instance
{
    NSLog(@"[BAContext instance] called");
    return [BAContext sharedBAContext];
}


- (id) retain {
	return self;
}

- (oneway void) release {
	// Do nothing here.
}

- (id) autorelease {
	return self;
}

- (NSUInteger) retainCount {
    return INT32_MAX;
}

@end
