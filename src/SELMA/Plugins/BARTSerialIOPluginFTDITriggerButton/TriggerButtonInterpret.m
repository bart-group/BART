//
//  TriggerButtonInterpret.m
//  BARTSerialIOPluginFTDITriggerButton
//
//  Created by Lydia Hellrung on 5/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "TriggerButtonInterpret.h"
#include "BARTSerialIOFramework/BARTSerialPortIONotifications.h"


@interface TriggerButtonInterpret (PrivateMethods)



@end


@implementation TriggerButtonInterpret

@synthesize triggerID;

-(id)init
{
	if ((self = [super init])){
		//load the plugin own config file to read all the EyeTrac special configuration stuff
		NSString *errDescr = nil;
		NSPropertyListFormat format;
		NSString *plistPath;
		NSString *rootPath = 
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
		 objectAtIndex:0];
		plistPath = [rootPath stringByAppendingPathComponent:@"ConfigSerialIOFTDITriggerButton.plist"];
        NSBundle *thisBundle;
		if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
		{
            thisBundle = [NSBundle bundleForClass:[self class]]; 
            plistPath = [thisBundle pathForResource:@"ConfigSerialIOFTDITriggerButton" ofType:@"plist"];
		}
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
		NSDictionary *temp = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML
																			   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																						 format:&format 
																			   errorDescription:&errDescr];
		if (!temp)
		{
			NSLog(@"Error reading plist from BARTSerialIOPluginFTDITriggerButton: %@, format: %lu", errDescr, format);
		}
		self.triggerID = [temp objectForKey:@"triggerID"];
		triggerIDChar = [self.triggerID unsignedCharValue];
		NSLog(@"TriggerID: %d and as uchar: %d", [self.triggerID intValue], triggerIDChar);
		
		countTrigger = 0;
        
        // (6) collect the port parameters to give back for initialisation
        // serial, baud, parity, odd, path, description
        
        dictPortParameters = [[NSDictionary alloc] initWithDictionary:[temp objectForKey:@"portParameters"]];
        
		
	}
	return self;
}

-(void)valueArrived:(char)value
{
    //don't do anything on \n (newline character)
    if ( 0 != (value & (unsigned char)0x0a) ){
        return;
    }
	if (triggerIDChar == (unsigned char) value)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:BARTSerialIOScannerTriggerArrived object:[NSNumber numberWithUnsignedInt:countTrigger]];
		countTrigger++;
	}
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName:BARTSerialIOButtonBoxPressedKey object:[NSNumber numberWithUnsignedChar:value]];
	}
}

-(NSString*) pluginTitle
{
	return [[NSBundle mainBundle] bundleIdentifier]; 
}

-(NSString*) pluginDescription{
	return @"TriggerAndButtonBox";
}

-(NSImage*) pluginIcon{
	return nil;
}

-(NSDictionary*) portParameters
{
    return dictPortParameters;
}

-(void)dealloc
{
    [dictPortParameters release];
	[super dealloc];
}

-(NSDictionary*)evaluateConstraintForParams:(NSDictionary*)params
{
	return nil;
}
-(void)connectionIsOpen
{}

-(void)connectionIsClosed
{}
@end
