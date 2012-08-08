//
//  BAAddExperimentAccessoryViewControllerViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/30/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAAddExperimentAccessoryViewControllerViewController.h"

#import "BAContext.h"



@interface BAAddExperimentAccessoryViewControllerViewController ()

- (void)createHelpText;
- (void)fillExperimentTypeDictionaries;

@end

@implementation BAAddExperimentAccessoryViewControllerViewController

@synthesize experimentTypeLabel=_experimentTypeLabel;
@synthesize experimentTypeInput=_experimentTypeInput;

@synthesize experimentNameLabel=_experimentNameLabel;
@synthesize experimentNameInput=_experimentNameInput;

@synthesize newSessionLabel    =_newSessionLabel;
@synthesize newSessionCheckbox =_newSessionCheckbox;

@synthesize sessionNameLabel   =_sessionNameLabel;
@synthesize sessionNameInput   =_sessionNameInput;


@synthesize helpText=_helpText;

@synthesize experimentTypeClasses      =_experimentTypeClasses;
@synthesize experimentTypeNames        =_experimentTypeNames;
@synthesize experimentTypeDescriptions =_experimentTypeDescriptions;


- (IBAction)newSessionCheckboxSelector:(id)sender
{
    NSLog(@"[newSessionCheckboxSelector] %@", sender);
    if([sender state] == NSOffState) {
        [[self sessionNameLabel] setEnabled:FALSE];
        [[self sessionNameLabel] setTextColor:[NSColor disabledControlTextColor]];
        [[self sessionNameInput] setEnabled:FALSE];
    } else {
        [[self sessionNameLabel] setEnabled:TRUE];
        [[self sessionNameLabel] setTextColor:[NSColor controlTextColor]];
        [[self sessionNameInput] setEnabled:TRUE];
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self createHelpText];
        [self fillExperimentTypeDictionaries];
    }
    
    return self;
}

- (void)createHelpText
{
    unichar pSepChar = NSParagraphSeparatorCharacter;
    NSString *pSepString = [NSString stringWithCharacters:&pSepChar length:1];
    
    NSString *rawText = @"";
    rawText = [rawText stringByAppendingString:@"This dialog adds a new experiment to an existing or newly created session."];
    rawText = [rawText stringByAppendingString:pSepString];
    rawText = [rawText stringByAppendingString:@"Please choose your EDL file above and then select the desired experiment type and "];
    rawText = [rawText stringByAppendingString:@"wether you want to append the experiment to an existing session or create an entirely new session. "];
    rawText = [rawText stringByAppendingString:@"Note however that if you create a new session the old one including all containing experiments "];
    rawText = [rawText stringByAppendingString:@"will be deleted."];

    NSMutableDictionary *attributes = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSFont *systemFont = [NSFont labelFontOfSize:11.0];
    [attributes setValue:systemFont forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSJustifiedTextAlignment];
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    _helpText = [[[NSAttributedString alloc] initWithString:rawText attributes:attributes] autorelease];
    
}

- (void)fillExperimentTypeDictionaries
{
    NSArray *_experimentClasses = [[BAContext sharedBAContext] registeredExperimentTypes];
    
    NSLog(@"registeredExperimentTypes: %@", _experimentClasses);
    
    NSMutableArray *_classes      = [NSMutableArray array];
    NSMutableArray *_names        = [NSMutableArray array];
    NSMutableArray *_descriptions = [NSMutableArray array];

    for(Class typeClass in _experimentClasses) {
        [_classes      addObject:typeClass];
        [_names        addObject:[typeClass typeDisplayName]];
        [_descriptions addObject:[typeClass typeDescription]];
    }
    
//    [_types addObject:@"Experiment Type 1"];
//    [_types addObject:@"Experiment Type 2"];
//    [_types addObject:@"Experiment Type 3"];
//    [_types addObject:@"My Experiment Type"];
    
    _experimentTypeClasses      = [NSArray arrayWithArray:_classes];
    _experimentTypeNames        = [NSArray arrayWithArray:_names];
    _experimentTypeDescriptions = [NSArray arrayWithArray:_descriptions];
}



@end