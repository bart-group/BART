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

@synthesize currentSession = _currentSession;
@synthesize sessionArray;

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSLog(@"[BASessionContext keyPathsForValuesAffectingValueForKey]: %@", key);
    
    if([key compare:@"sessionArray"] == NSOrderedSame) {
        return [NSSet setWithObjects:@"currentSession", nil];
    }
    
    return nil;
}


#pragma mark -
#pragma mark Property Methods 'currentSession'

- (BASession2*)currentSession
{
    return _currentSession;
}


- (void)setCurrentSession:(BASession2 *)newCurrentSession
{
    if(newCurrentSession != _currentSession) {
        [self willChangeValueForKey:@"currentSession"];
        [newCurrentSession retain];
        if(_currentSession != nil) {
            [_currentSession release];
        }
        _currentSession = newCurrentSession;
        NSLog(@"[BASessionContext setCurrentSession] currentSession changed to: %@", _currentSession);
        NSLog(@"[currentSession retainCount] %lu", [_currentSession retainCount]);
        // [self buildTreeForView];
        [self willChangeValueForKey:@"currentSession"];
    }
}


- (NSArray*)sessionArray
{
    if(_currentSession == nil) {
        return [NSArray array];
    } else {
        return [NSArray arrayWithObject:_currentSession];
    }
}



#pragma mark -
#pragma mark Property Methods 'currentSession'



#pragma mark -
#pragma mark Session Tree Related


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

            COSystemConfig *edl = [[COSystemConfig alloc] init];
            [edl fillWithContentsOfEDLFile:[[chooseEDLFilePanel URL] path]];
            
            BAExperiment2 *newExperiment = objc_msgSend((id)selectedExperimentClass,
                                                        @selector(experimentWithEDL:name:description:),
                                                        edl,
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

    BAExperiment2 *experiment001 = [[BAExperiment2 alloc] initWithEDL:nil
                                                                 name:@"Experiment 001"
                                                          description:@"Description of Experiment 001"];

    BAStep2 *step001 = [[BAStep2 alloc] initWithName:@"Step 001" description:@"Description of Step 001"]; 
    BAStep2 *step002 = [[BAStep2 alloc] initWithName:@"Step 002" description:@"Description of Step 002"]; 
    BAStep2 *step003 = [[BAStep2 alloc] initWithName:@"Step 003" description:@"Description of Step 003"]; 
    BAStep2 *step004 = [[BAStep2 alloc] initWithName:@"Step 004" description:@"Description of Step 004"]; 
    BAStep2 *step005 = [[BAStep2 alloc] initWithName:@"Step 005" description:@"Description of Step 005"]; 

    [experiment001 appendStep:step001];
    [experiment001 appendStep:step002];
    [experiment001 appendStep:step003];
    [experiment001 appendStep:step004];

    [experiment001 dump];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"waiting to add another step ...");
        [NSThread sleepForTimeInterval:10];
        NSLog(@"adding another step ...");
        [experiment001 appendStep:step005];
        [experiment001 dump];
    });
    

    
    
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
