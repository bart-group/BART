//
//  BAAnalyzerGLM.h
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAAnalyzerElement.h"
#import "BAGUIProtoCGLayer.h"

// strange MAXKONSTANTEN aus vcolorglm - sicherheitshalber noch da - Test notwendig
#define ETMP     64   /* max number of temporary images for smoothness estim */
#define NSLICES 256   /* max number of image slices */
#define MBETA    64   /* max number of covariates */


@interface BAAnalyzerGLM : BAAnalyzerElement {
    
    BADesignElement *mDesign;
    BADataElement *mData;
    BAGUIProtoCGLayer *gui;
}

-(void)dealloc;

@end
