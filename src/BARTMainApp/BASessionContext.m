//
//  BASessionContext.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/26/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionContext.h"
#import "BAAddExperimentAccessoryViewController.h"


#import <dispatch/once.h>
#import <objc/objc-runtime.h>


@interface BASessionContext ()

- (void)buildTreeForView;

@end


@implementation BASessionContext 
    

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
        NSLog(@"[BASessionContext setCurrentSession] currentSession changed to: %@", currentSession);
        NSLog(@"[currentSession retainCount] %lu", [currentSession retainCount]);
        [self buildTreeForView];
        NSLog(@"[BASessionContext setCurrentSession] after building tree: _sessionTreeContent = %@", sessionTreeContent);
        [self willChangeValueForKey:@"currentSession"];
    }
}

#pragma mark -
#pragma mark Property Methods 'currentSession'

 - (NSArray*)sessionTreeContent
{
    NSLog(@"[BASessionContext sessionTreeContent] called ... returning %@", sessionTreeContent);
    return sessionTreeContent;
}


#pragma mark -
#pragma mark Session Tree Related

- (void)buildTreeForView
{
    NSLog(@"[BASessionContext buildTreeForView] called");
    NSMutableArray *experiments = [NSMutableArray arrayWithObjects: nil];
    for (BAExperiment2 *experiment in [currentSession experiments]) {
        NSMutableArray *steps = [NSMutableArray arrayWithObjects: nil];
        for(BAStep2 *step in [experiment steps]) {
            [steps addObject:[[BASessionTreeNode alloc] initWithObject:step children:nil]];
            NSLog(@"[BASessionContext buildTreeForView] added step: %@", [steps lastObject]);
        }
        [experiments addObject:[[BASessionTreeNode alloc] initWithObject:experiment children:steps]];
        NSLog(@"[BASessionContext buildTreeForView] added experiment: %@", [experiments lastObject]);
    }
    BASessionTreeNode *sessionNode = [[BASessionTreeNode alloc] initWithObject:currentSession children:experiments];
    NSLog(@"[BASessionContext buildTreeForView] added session: %@", sessionNode);
    sessionTreeContent = [NSArray arrayWithObjects:sessionNode, nil];
    NSLog(@"[BASessionContext buildTreeForView] new sessionTreeContent: %@", sessionTreeContent);
}

- (IBAction)addExperiment:(id)sender
{
    NSOpenPanel *chooseEDLFilePanel = [[NSOpenPanel openPanel] retain];
    
    BAAddExperimentAccessoryViewController *accessoryViewController = [[BAAddExperimentAccessoryViewController alloc] initWithNibName:@"AddExperimentAccessoryView" bundle:nil];
    
    [chooseEDLFilePanel setCanChooseFiles:YES];
    [chooseEDLFilePanel setCanChooseDirectories:NO];
    [chooseEDLFilePanel setAllowsMultipleSelection:NO];
    [chooseEDLFilePanel setAllowedFileTypes:[NSArray arrayWithObject:@"edl"]];
    [chooseEDLFilePanel setAllowsOtherFileTypes:YES];
    [chooseEDLFilePanel setTitle:@"Add Experiment (with EDL File)"];
    
    [chooseEDLFilePanel setAccessoryView:[accessoryViewController view]];
    [chooseEDLFilePanel setDelegate:accessoryViewController];
    
     [chooseEDLFilePanel beginSheetModalForWindow:[sender window] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            
            Class *selectedExperimentClass = (Class*)[[accessoryViewController experimentTypeClasses] objectAtIndex:[[accessoryViewController experimentTypeInput] indexOfSelectedItem]];
            
            NSLog(@"[BASessionContext addExperiment] EDL File URL: %@", [chooseEDLFilePanel URL]);
            NSLog(@"[BASessionContext addExperiment] Experiment Type: %@", selectedExperimentClass);
            NSLog(@"[BASessionContext addExperiment] Experiment Name: %@", [[accessoryViewController experimentNameInput] stringValue]);
            NSLog(@"[BASessionContext addExperiment] Create Session: %@", ([[accessoryViewController newSessionCheckbox] state] ? @"True" : @"False"));
            NSLog(@"[BASessionContext addExperiment] Session Name: %@", [[accessoryViewController sessionNameInput] stringValue]);

            BAExperiment2 *newExperiment = objc_msgSend((id)selectedExperimentClass,
                                                        @selector(experimentWithEDL:name:description:),
                                                        nil,
                                                        [[accessoryViewController experimentNameInput] stringValue],
                                                        [[accessoryViewController experimentNameInput] stringValue]);

            NSLog(@"[BASessionContext] newly created experiment: %@", newExperiment);
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
    NSLog(@"[BASessionContext createExampleSession] called");

    BAStep2 *step001 = [[BAStep2 alloc] initWithName:@"Step 001" description:@"Description of Step 001"]; 
    BAStep2 *step002 = [[BAStep2 alloc] initWithName:@"Step 002" description:@"Description of Step 002"]; 
    BAStep2 *step003 = [[BAStep2 alloc] initWithName:@"Step 003" description:@"Description of Step 003"]; 
    BAStep2 *step004 = [[BAStep2 alloc] initWithName:@"Step 004" description:@"Description of Step 004"]; 
    BAStep2 *step005 = [[BAStep2 alloc] initWithName:@"Step 005" description:@"Description of Step 005"]; 

    BAExperiment2 *experiment001 = [[BAExperiment2 alloc] initWithEDL:nil
                                                                 name:@"Experiment 001"
                                                          description:@"Description of Experiment 001"
                                                                steps:[NSMutableArray arrayWithObjects:step001, step002, step003, step004, step005, nil]];
    
    BASession2 *session001 = [[BASession2 alloc] initWithName:@"Session 001" description:@"Description of Session 001" experiments:[NSMutableArray arrayWithObjects:experiment001, nil]];
    
    NSLog(@"[BASessionContext createExampleSession] setting currentSession to: %@", session001);
    [self setCurrentSession:session001];
}

#pragma mark -
#pragma mark Singleton Implementation

+ (BASessionContext*)sharedBASessionContext {
    NSLog(@"[BASessionContext sharedBASessionContext] called");
	static dispatch_once_t predicate;
	static BASessionContext *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (BASessionContext*)instance
{
    NSLog(@"[BASessionContext instance] called");
    return [BASessionContext sharedBASessionContext];
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
