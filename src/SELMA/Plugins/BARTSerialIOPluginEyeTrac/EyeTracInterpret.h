//
//  EyeTracInterpret.h
//  BARTSerialIOPluginEyeTrac
//
//  Created by Lydia Hellrung on 11/19/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "BARTSerialIOFramework/BARTSerialIOProtocol.h"
#include <sys/time.h>
#import "math.h"
#include <vector>


// This class is to interpret the incoming data from ASL EyeTrac 6 into the BARTApplication

#define BITMASKOVERFLOWHSBDIAM 0x00000002
#define BITMASKOVERFLOWLSBDIAM 0x00000004
#define BITMASKOVERFLOWHSBCDIA 0x00000010
#define BITMASKOVERFLOWLSBCDIA 0x00000020
#define BITMASKOVERFLOWHSBHGAZ 0x00000040
#define BITMASKOVERFLOWLSBHGAZ 0x00000001
#define BITMASKOVERFLOWHSBVGAZ 0x00000002
#define BITMASKOVERFLOWLSBVGAZ 0x00000004

typedef struct EyeTracParams{
    NSUInteger pupilDiam;
    NSUInteger pupilRec;
    float horGaze;
    float verGaze;
    NSUInteger corneaDiam;
    NSUInteger corneaRec;
    int status;
}TEyeTracParams;


@interface EyeTracInterpret : NSObject <BARTSerialIOProtocol> {
	
	NSUInteger relevantBytes;
	char *valueBuffer;
	NSUInteger indexBuffer;
	FILE *logFile;//, *fileFixationsOK, *fileFixationsOut, *fileAllBytes;
	NSUInteger posStatus;
	NSUInteger posHSBDiam;
	NSUInteger posLSBDiam;
	NSUInteger posHSBHgaz;
	NSUInteger posLSBHgaz;
	NSUInteger posHSBVgaz;
	NSUInteger posLSBVgaz;
	NSUInteger posOverflow1;
	NSUInteger posOverflow2;
	NSUInteger posHSBCRDiam;
	NSUInteger posLSBCRDiam;
	NSString *logfilePath;
    BOOL isStarted;
    BOOL isFixationDependingOnScreenCenter;
    NSPoint maxDistanceForFixation;
    NSPoint fixationDependsOnPoint;
    NSDictionary *dictPortParameters;
    @private
    enum PARAMS {
        HGAZE = 0,
        VGAZE
    };
    
    std::vector<TEyeTracParams> eyeTracParamsVector;
    
    NSUInteger analyseWindowSize;
    
    NSUInteger dispersionThreshold;
    NSUInteger validMissingsInFixation;
    float scenePOGResolutionHeight; 
    float scenePOGResolutionWidth;
    dispatch_queue_t serialQueue;
    
    //for timing log
    struct timeval timeval;
    time_t actualtime;
    struct tm *actualtm;
    char actualtmbuf[64], usecbuf[64];
    
    NSString *mLogfilePath;
    NSString *mLogfileNameAppend;

	
}


@end
