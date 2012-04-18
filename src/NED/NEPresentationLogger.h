//
//  NEPresentationLogger.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/26/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NELogFormatter.h"


/**
 * Class for presentation logging.
 */
@interface NEPresentationLogger : NSObject {
    
    /** An array of NSDictionaries representing the log. */
    NSMutableArray* mMessages;
    
    /** An array of NSStrings with some header information for logfile. */
    NSMutableArray* mGeneralMessages;
    
    /** Date format for the timestamp in each message. */
    NSDateFormatter* mDateFormatter;
    
    /** Formatter for the log messages. */
    NELogFormatter* mLogFormatter;

}

/**
 * Returnes the shared NEPresentationLogger instance (Singleton).
 *
 * \return The shared NEPresentationLogger instance.
 */
+(NEPresentationLogger*)getInstance;

/**
 * Adds a message to the log.
 * The message is automatically expanded by a timestamp (time
 * the message was logged).
 *
 * \param msg Message to log/add.
 */
-(void)log:(NSString*)msg withTime:(NSUInteger)t;

/**
 * Logs a trigger message.
 * The message is automatically expanded by a timestamp (time
 * the message was logged).
 *
 * \param triggerNumber The number of the trigger that needs to
 *                      appear in the message.
 * \param t onset
 */
-(void)logTrigger:(NSUInteger)triggerNumber  withTime:(NSUInteger)t;

/**
 * Logs a keyboard message.
 * The message is automatically expanded by a timestamp (time
 * the message was logged).
 *
 * \param button The pressed button ID that needs to
 *                      appear in the message.
 * \param triggerNumber The triggerNumber that needs to
 *                      appear in the message.
 * \param t The onset that needs to
 *                      appear in the message.
 */
-(void)logButtonPress:(NSUInteger)button atTrigger:(NSUInteger)triggerNumber withTime:(NSUInteger)t;

/**
 * Logs conditions from constraint
 * The message is automatically expanded by a timestamp (time
 * the message was logged).
 *
 * \param dict dictionary describing the conditions - variables and status
 */
-(void)logConditions:(NSDictionary*)dict  withTime:(NSUInteger)t;

/**
 * Logs an action done if condition fullfilled
 * The message is automatically expanded by a timestamp (time
 * the message was logged).
 *
 * \param dict dictionary describing the actions - fctName, variables
 */
-(void)logActionsThen:(NSDictionary*)dict  withTime:(NSUInteger)t;

/**
 * Logs an action done if condition not fullfilled
 * The message is automatically expanded by a timestamp (time
 * the message was logged).
 *
 * \param dict dictionary describing the actions - fctName, variables
 */
-(void)logActionsElse:(NSDictionary*)dict  withTime:(NSUInteger)t;

/**
 * Generates a log message for a starting event and adds this
 * message to the log.
 * The log entry is automatically expanded by a timestamp 
 * (time the event was logged).
 * 
 * \param event         NEStimEvent which is logged with its
 *                      properties and the additional information
 *                      that it is starting.
 * \param triggerNumber The current trigger in which the event
 *                      happens.
 */
-(void)logStartingEvent:(NEStimEvent*)event 
            withTrigger:(NSUInteger)triggerNumber
             andTime:(NSUInteger)t;

/**
 * Generates a log message for a ending event and adds this
 * message to the log.
 * The log entry is automatically expanded by a timestamp 
 * (time the event was logged).
 * 
 * \param event         NEStimEvent which is logged with its
 *                      properties and the additional information
 *                      that it is ending.
 * \param triggerNumber The current trigger in which the event
 *                      ends.
 */
-(void)logEndingEvent:(NEStimEvent*)event 
          withTrigger:(NSUInteger)triggerNumber
              andTime:(NSUInteger)t;

/**
 * Returns an autoreleased copy of all messages/the log.
 *
 * \return All messages in an array of NSStrings.
 */
-(NSArray*)messages;

/**
 * Prints all messages/the log to stdout.
 */
-(void)print;

/**
 * Writes all messages/the log to a file.
 *
 * \param path The file to write to.
 */
-(void)printToFilePath:(NSString*)path;

/**
 * Prints all messages/the log using NSLog.
 */
-(void)printToNSLog;

/**
 * Deletes all messages/the log completely.
 */
-(void)clear;

/**
 * Searches the log for event messages that were logged later
 * than the event time plus a tolerance.
 *
 * \param tolerance The time tolerance in milliseconds.
 * \return          All logged events that violated the time tolerance
 *                  and the last trigger that was recorded before each of
 *                  those events.
 */
-(NSArray*)allMessagesViolatingTolerance:(NSUInteger)tolerance;

@end
