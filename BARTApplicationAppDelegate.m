//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by First Last on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"
#import "BAGUIPrototyp.h"

@implementation BARTApplicationAppDelegate

@synthesize window;
@synthesize gui;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
    gui = [[BAGUIProtoCGLayer alloc] initWithWindow:window];
    [gui initLayers];
	//[gui doPaint];

    dataEl = [[BADataElement alloc] initWithDatasetFile:@"/Users/user/Development/BR5T-functional.v" ofImageDataType:IMAGE_DATA_SHORT];
    [gui setBackgroundImage:dataEl];
    designEl = [[BADesignElement alloc] initWithDatasetFile:@"/Users/user/Development/designfromscipt.v" ofImageDataType:IMAGE_DATA_FLOAT];
   
    printf("\nCOVARIATE VALUE AT 1/42: %10.10f", [[designEl getValueFromCovariate:0 atTimestep:42] floatValue]);
    
    
    analyzer = [[BAAnalyzerElement alloc] initWithAnalyzerType:kAnalyzerGLM];
    
    if ([analyzer isKindOfClass:[BAAnalyzerElement class]]) {
        printf("JIPPIE!");
    }
    
    [analyzer anaylzeTheData:dataEl withDesign:designEl];
    //[gui updateImage:nil];
}

-(void)dealloc{

    [analyzer release];
    [dataEl release];
    [designEl release];
    [analyzer release];
    [super dealloc];    
    
}

@end
