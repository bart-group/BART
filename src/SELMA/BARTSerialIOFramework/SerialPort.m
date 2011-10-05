//
//  SerialPort.m
//  
//
//  Created by Karsten Molka on 4/20/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

/**
 * The class SerialPort is the wrapper for the IOKit Serial Port. For use, one has to init an instance 
 * with the many parameters as descripted and afterwards to start. 
 * It will send the values arrived on the initialized serial port to all observers that has been added before 
 * start. 
 * These observers in best case are plugins (BARTSerialIOPlugins) knowing how to interpret the arrived stuff.
 */


//TODO 
//testcase
//Thread Canceling

#import "SerialPort.h"

@interface SerialPort (hidden) 

- (NSError*) openSerialPort;	
- (NSError*) initCommunication;


- (void) dispatchData:(unsigned char)data;
- (unsigned char) readChar;
- (void) createFinalObserverList;

@end



@implementation SerialPort

@synthesize devicePath;
@synthesize deviceDescription;
@synthesize baud;
@synthesize parity;
@synthesize bits;

	

- (id) initSerialPortWithDevicePath:(NSString*)aDevicePath 
                     deviceDescript:(NSString*)aDeviceDescription
						 symbolrate:(int)aSymbolrate 
                             parity:(int)aParity 
                            andBits:(int)aBits
{

	if((self = [super init])) {
		devicePath = [aDevicePath copy];
		deviceDescription = [aDeviceDescription copy];
        baud = aSymbolrate;
        parity = aParity;
        bits = aBits;
        addingObserversAllowed = YES;
        observerMutableList = [[NSMutableArray alloc] initWithCapacity:0];
        observerList = nil;
	}
	
	return self;	
}

- (NSError*) openSerialPort {

    const char *device = [devicePath cStringUsingEncoding:NSASCIIStringEncoding];
    
    int res = FindAndOpenModem(device, strlen(device), baud, parity, bits, &portDescriptor);
    if (res != 0) {
        NSString *domain = @"Fehler beim Finden und Oeffnen des Devices.";
        [domain stringByAppendingString:devicePath];
         
        NSError *err = [[NSError alloc] initWithDomain:domain code:res userInfo:nil];
        return [err autorelease];
    }

    return nil; 
}

- (NSError*) initCommunication {
 
    int res = InitAndStartModem(portDescriptor);
    if (res != 0) {
        NSString *domain = @"Fehler bei der Kommunikation mit dem Device.";
        [domain stringByAppendingString:devicePath];

        NSError *err = [[NSError alloc] initWithDomain:domain code:res userInfo:nil];
        return err;
    }
	
    return nil;
}

-(void)closeSerialPort:(NSError*)err {
    
	err = nil;
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply([observerList count], queue, ^(size_t i) {
		[((id<BARTSerialIOProtocol>) [observerList objectAtIndex:i]) connectionIsClosed];
    });
	
    int res = CloseSerialPort(portDescriptor);
    if (res != 0) {
        NSString *domain = @"Fehler beim Schließen des Devices.";
        [domain stringByAppendingString:devicePath];
        
        err = [NSError errorWithDomain:domain code:res userInfo:nil];
	}
    
    return;
}


- (unsigned char) readChar {

    unsigned char c = ReadData(portDescriptor);    

    [self dispatchData:c];    
    
    return c;
}

- (void) dispatchData:(unsigned char)data {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply([observerList count], queue, ^(size_t i) {
		[((id<BARTSerialIOProtocol>) [observerList objectAtIndex:i]) valueArrived:data];
    });
}



//return false : did not match BARTTriggerProtocol
- (BOOL) addObserver:(id)anObserver {
   
	if (YES == addingObserversAllowed)
	{
		
		[anObserver retain];
		if ( ! [anObserver conformsToProtocol:@protocol(BARTSerialIOProtocol)]  ) {
			[anObserver release];
			return NO;
		}
		else {
			[observerMutableList addObject:anObserver];
		}
		return YES;
	}
	
	return NO;
}

- (void) createFinalObserverList {
	
    addingObserversAllowed = NO;
	if (observerList != nil) {
        [observerList release];
    }
    observerList = [[NSArray alloc] initWithArray:observerMutableList];
    [observerMutableList release];
}


- (void) startSerialPortThread:(NSError*)err {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    err = [self openSerialPort];
	if(err != nil) {
        NSLog( @"Error: %s, %d\n", [err.domain UTF8String], (int) err.code );
        [pool drain];
		return;
	}
    
	err = [self initCommunication];
	if(err != nil) {
		NSLog( @"Error: %s, %d\n", [err.domain UTF8String], (int) err.code );
        [pool drain];
		return;
	}

    [self createFinalObserverList];

	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply([observerList count], queue, ^(size_t i) {
		[((id<BARTSerialIOProtocol>) [observerList objectAtIndex:i]) connectionIsOpen];
    });
	
	while (![[NSThread currentThread] isCancelled]) {
		[self readChar];        
	}
    
	    
    [pool drain];
}


- (void) dealloc {
    
    [observerList release];
    [devicePath release];
	[deviceDescription release];
    [super dealloc];
}

-(NSPoint)isConditionFullfilled:(NSDictionary*)params
{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSPoint ret = NSMakePoint(0.0, 0.0);
    dispatch_apply([observerList count], queue, ^(size_t i) {
		ret = [((id<BARTSerialIOProtocol>) [observerList objectAtIndex:i]) isConditionFullfilled:params];
    });
	return ret;
}


@end
