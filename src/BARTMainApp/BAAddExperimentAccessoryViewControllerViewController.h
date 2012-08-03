//
//  BAAddExperimentAccessoryViewControllerViewController.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/30/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BAAddExperimentAccessoryViewControllerViewController : NSViewController

@property (readonly) NSAttributedString *helpText;

@property (readonly) NSArray *experimentTypes;

@property (assign) IBOutlet NSTextField *experimentTypeLabel;
@property (assign) IBOutlet NSComboBox  *experimentTypeInput;

@property (assign) IBOutlet NSTextField *experimentNameLabel;
@property (assign) IBOutlet NSTextField *experimentNameInput;

@property (assign) IBOutlet NSTextField *newSessionLabel;
@property (assign) IBOutlet NSButton    *newSessionCheckbox;

@property (assign) IBOutlet NSTextField *sessionNameLabel;
@property (assign) IBOutlet NSTextField *sessionNameInput;


- (IBAction)newSessionCheckboxSelector:(id)sender;


@end
