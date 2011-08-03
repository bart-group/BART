//
//  BARTSerialIOProtocol.h
//  SerialPortSample
//
//  Created by Lydia Hellrung on 11/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol BARTSerialIOProtocol

-(void) valueArrived:(char)value;
-(BOOL) isConditionFullfilled;

-(void)connectionIsOpen;
-(void)connectionIsClosed;

-(NSString*) pluginTitle;
-(NSString*) pluginDescription;
-(NSImage*) pluginIcon;



@end
