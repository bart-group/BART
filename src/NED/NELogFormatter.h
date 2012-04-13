//
//  NELogFormatter.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/3/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class NEStimEvent;

/**
 * Class for converting objects into log messages (strings).
 * Also provides default log messages for often occurring application/
 * presentation states.
 */
@interface NELogFormatter : NSObject {
    
@private
    /** Essential strings for various log messages. */
    NSString* keyValuePairSeperator;
    NSString* keyValueSeperator;
    
    NSString* beginSetDelimiter;
    NSString* entrySeperator;
    NSString* endSetDelimiter;
    
    NSString* triggerIdentifier;
    
    NSString* eventIdentifier;
    NSString* startEventIdentifier;
    NSString* endEventIdentifier;

}

@property (readonly) NSString* keyValuePairSeperator;;
@property (readonly) NSString* keyValueSeperator;

@property (readonly) NSString* beginSetDelimiter;
@property (readonly) NSString* entrySeperator;
@property (readonly) NSString* endSetDelimiter;

@property (readonly) NSString* triggerIdentifier;

@property (readonly) NSString* eventIdentifier;
@property (readonly) NSString* startEventIdentifier;
@property (readonly) NSString* endEventIdentifier;

/**
 * Returns the default formatter (shared instance).
 *
 * \return An initialized NELogFormatter.
 */
+(NELogFormatter*)defaultFormatter;

/**
 * Generates a trigger message with a given trigger number.
 *
 * \param triggerNr The number of the trigger that needs to
 *                  appear in the message.
 * \return          A trigger message predestinated for logging.
 */
-(NSString*)stringForTriggerNumber:(NSUInteger)triggerNr;

/**
 * Converts a NEStimEvent into a log message.
 *
 * \param event The NEStimEvent to convert.
 * \return      The string representation of event.
 */
-(NSString*)stringForStimEvent:(NEStimEvent*)event;

/**
 * Converts a then action from a constraint into a log message.
 *
 * \param action The Dictionary describing the action.
 * \return      The string representation of action.
 */
-(NSString*)stringForActionThen:(NSDictionary*)action;

/**
 * Converts an else action from a constraint into a log message.
 *
 * \param action The Dictionary describing the action.
 * \return      The string representation of action.
 */
-(NSString*)stringForActionElse:(NSDictionary*)action;

@end
