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
    unsigned int pupilDiam;
    unsigned int pupilRec;
    float horGaze;
    float verGaze;
    unsigned int corneaDiam;
    unsigned int corneaRec;
    int status;
}TEyeTracParams;


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
    
    @private
    enum PARAMS {
        PDIAM = 0,
        PREC,
        HGAZE,
        VGAZE,
        CDIAM,
        CREC,
        STATUS
    };
    
    
    
    std::vector<TEyeTracParams> eyeTracParamsVector;
    
    size_t mWindowSize;
    
    size_t dispersionThreshold;
    size_t validMissingsInFixation;
    float distanceFromMidpointToBeValid;
    size_t halfScenePOGResolutionHeight;
    size_t halfScenePOGResolutionWidth;
    dispatch_queue_t serialQueue;
    
    //for timing log
    struct timeval timeval;
    time_t actualtime;
    struct tm *actualtm;
    char actualtmbuf[64], usecbuf[64];

	
}

@property (copy, nonatomic) NSNumber * relevantBytes;
@property (retain, nonatomic) NSArray * byteMeanings;
@property (copy, nonatomic) NSString *logfilePath;

@end
