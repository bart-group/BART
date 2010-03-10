//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by First Last on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"
#import "BAGUIPrototyp.h"
#import "BADesignElementDyn.h"

@implementation BARTApplicationAppDelegate

@synthesize window;
@synthesize gui;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
 
    gui = [[BAGUIProtoCGLayer alloc] initWithWindow:window];
    [gui initLayers];
	//[gui doPaint];

    dataEl = [[BADataElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.v" ofImageDataType:IMAGE_DATA_SHORT];
    //dataEl = [[BADataElement alloc] initWithDatasetFile:@"/Users/user/Development/KC9T/KC9T081015-functional.v" ofImageDataType:IMAGE_DATA_SHORT];
    
    [gui setBackgroundImage:dataEl];
    
    designEl = [[BADesignElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-design.v" ofImageDataType:IMAGE_DATA_FLOAT];
    //designEl = [[BADesignElement alloc] initWithDatasetFile:@"/Users/user/Development/VGenDesign/testfiles/blockDesignTest01.des" ofImageDataType:IMAGE_DATA_FLOAT];
    
    //designEl = [[BADesignElement alloc] initWithDatasetFile:@"/Users/user/Development/KC9T/KC9T.des.v" ofImageDataType:IMAGE_DATA_FLOAT];

    analyzer = [[BAAnalyzerElement alloc] initWithAnalyzerType:kAnalyzerGLM];
    
//    if ([analyzer isKindOfClass:[BAAnalyzerElement class]]) {
//        printf("JIPPIE!");
//    }
    
    [analyzer anaylzeTheData:dataEl withDesign:designEl];
    
  //  BADesignElementDyn *designTest = [[BADesignElementDyn alloc] initWithFile:@"/Users/user/Development/VGenDesign/testfiles/blockDesignTest01.des" ofImageDataType:IMAGE_DATA_FLOAT];
  //  [designTest release];
}

-(void)dealloc{

    [analyzer release];
    [dataEl release];
    [designEl release];
    [analyzer release];
    
    [super dealloc];    
    
}

@end
