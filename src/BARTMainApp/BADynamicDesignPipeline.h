//
//  BADynamicDesignPipeline.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/6/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEDesignElement.h"
//#import "BARTSerialIOFramework/SerialPort.h"

@interface BADynamicDesignPipeline : NSObject {

	
	NEDesignElement *designElement;
}

@property (readonly, assign) NEDesignElement *designElement;


-(BOOL) initDesign;

@end
