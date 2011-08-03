//
//  SerialPort.h
// 
//
//  Created by Karsten Molka on 4/20/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "SerialPort_C.h"
#import <termios.h>
#import "BARTSerialIOProtocol.h"

#define PARNON 0
#define ScannerSignal "ScannerSignal"
#define ScannerNotification "ScannerNotification"

/**
 * Objective-C class for controlling a serial Port, e.g. Trigger from Scanner or Keyboxes or EyeTracker signals.
 * Classes who wants to be an observer have to fulfill BARTTriggerProtocol.
 * Has to be initialised first, then oberservers has to be added before start listening on port
 * (after starting no oberservers can be added).
 * Reading from the port runs in an additional thread.
 */

@interface SerialPort : NSObject {

	@private
    
	NSString *devicePath;
	NSString *deviceDescription;
	int baud;
    int parity;
	int bits;
    int portDescriptor;    
    // mutable list to collect all observers before start
    NSMutableArray *observerMutableList;
    // for better handling copy to nonmutable list when starting the port
    NSArray *observerList;
	// flag 
    BOOL addingObserversAllowed;
}

@property (copy, readonly) NSString *devicePath;
@property (copy, readonly) NSString *deviceDescription;
@property (readonly) int baud;
@property (readonly) int parity;
@property (readonly) int bits;



//- (id) init;

/** initialise the Serial Port with all needed descriptions
 *
 * \param aDevicePath			NSString from device manager (mostly look at /dev/cu.usbserial... )
 * \param aDeviceDescription	NSString with the given description from config
 * \param aSymbolrate			int for the baud rate (B2400 | B4800 | B9600 | B19200 | B38400 | B57600 )
 * \param aParity				parity of serial port (PARNON | PARODD | PARENB) 
 * \param aBits					number of bits (CS5 | CS6 | CS7 | CS8)
 *
 * \return SerialPort class object with given definition
 */
- (id) initSerialPortWithDevicePath:(NSString*)aDevicePath 
                     deviceDescript:(NSString*)aDeviceDescription
						 symbolrate:(int)aSymbolrate 
                             parity:(int)aParity 
                            andBits:(int)aBits;

/**
 * call this function to listen on the port from now on
 * can be done in a separat thread for efficiently use
 * 
 * \param err object to collect the errors
 */
- (void) startSerialPortThread:(NSError*)err;

/**
 * call this function to stop listening on a port
 * 
 * \param err object to collect the errors
 * \returns nil if no error, error code otherwise
 */
- (void) closeSerialPort:(NSError*)err;


/**
 * add classes as observer for incoming signals from serial port
 * these classes have to fulfill BARTTriggerProtocol
 * 
 * \param anObserver whatever class who wants to have signals from serial port
 */
- (BOOL) addObserver:(id)anObserver;

/*
 * ask for condition of external device
 */
-(BOOL) isConditionFullfilled;
   
@end
