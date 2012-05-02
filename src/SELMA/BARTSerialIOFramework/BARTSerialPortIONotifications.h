/*
 *  BARTSerialPortIONotifications.h
 *  SerialPortSample
 *
 *  Created by Lydia Hellrung on 5/7/11.
 *  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */

#ifndef BARTSERIALPORTIONOTIFICATIONS_H
#define BARTSERIALPORTIONOTIFICATIONS_H

#import "Cocoa/Cocoa.h"


/*define all the possible notifications that could be send by external sources*/

NSString *const BARTSerialIOScannerTriggerArrived = @"BARTSerialIOScannerTriggerArrived";
NSString *const BARTSerialIOButtonBoxPressedKey = @"BARTSerialIOButtonBoxPressedKey";

#endif //BARTSERIALPORTIONOTIFICATIONS_H
