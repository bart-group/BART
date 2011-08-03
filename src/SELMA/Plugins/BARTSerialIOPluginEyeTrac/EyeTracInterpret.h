//
//  EyeTracInterpret.h
//  BARTSerialIOPluginEyeTrac
//
//  Created by Lydia Hellrung on 11/19/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "BARTSerialIOFramework/BARTSerialIOProtocol.h"
//#import </Users/Lydi/Development/BARTSerialIOFramework/BARTSerialIOProtocol.h>

// This class is to interpret the incoming data from ASL EyeTrac 6 into the BARTApplication

#define BITMASKOVERFLOWHSBDIAM 0x00000002
#define BITMASKOVERFLOWLSBDIAM 0x00000004
#define BITMASKOVERFLOWHSBCDIA 0x00000010
#define BITMASKOVERFLOWLSBCDIA 0x00000020
#define BITMASKOVERFLOWHSBHGAZ 0x00000040
#define BITMASKOVERFLOWLSBHGAZ 0x00000001
#define BITMASKOVERFLOWHSBVGAZ 0x00000002
#define BITMASKOVERFLOWLSBVGAZ 0x00000004


@interface EyeTracInterpret : NSObject <BARTSerialIOProtocol> {
	
	NSArray *byteMeanings;
	NSNumber *relevantBytes;
	char *valueBuffer;
	unsigned int indexBuffer;
	FILE *file, *fileFixationsOK, *fileFixationsOut, *fileAllBytes;
	unsigned int posStatus;
	unsigned int posHSBDiam;
	unsigned int posLSBDiam;
	unsigned int posHSBHgaz;
	unsigned int posLSBHgaz;
	unsigned int posHSBVgaz;
	unsigned int posLSBVgaz;
	unsigned int posOverflow1;
	unsigned int posOverflow2;
	NSUInteger posHSBCRDiam;
	NSUInteger posLSBCRDiam;
	NSString *logfilePath;
    BOOL isStarted;

	
}

@property (copy, nonatomic) NSNumber * relevantBytes;
@property (retain, nonatomic) NSArray * byteMeanings;
@property (copy, nonatomic) NSString *logfilePath;

@end
