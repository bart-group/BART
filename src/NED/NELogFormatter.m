//
//  NELogFormatter.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/3/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NELogFormatter.h"
#import "NEStimEvent.h"


@implementation NELogFormatter

@synthesize keyValuePairSeperator;
@synthesize keyValueSeperator;

@synthesize beginSetDelimiter;
@synthesize entrySeperator;
@synthesize endSetDelimiter;

@synthesize triggerIdentifier;

@synthesize eventIdentifier;
@synthesize startEventIdentifier;
@synthesize endEventIdentifier;

-(id)init
{
    if ((self = [super init])) {
        keyValuePairSeperator = @"\t";
        keyValueSeperator     = @":";
        
        beginSetDelimiter     = @"\t{";
        entrySeperator        = @"\t";
        endSetDelimiter       = @"}";
        
        triggerIdentifier     = @"Trigger";
        
        eventIdentifier       = @"Event";
        startEventIdentifier  = @"Start";
        endEventIdentifier    = @"End";
    }
    
    return self;
}

+(NELogFormatter*)defaultFormatter
{
    /** Default instance of NELogFormatter. */
    static NELogFormatter* mDefaultFormatter = nil;

    if (!mDefaultFormatter) {
        mDefaultFormatter = [[self alloc] init];
    } 

    return mDefaultFormatter;
}

-(NSString*)stringForTriggerNumber:(NSUInteger)triggerNr
{
    // @"T:triggerNr"
    return [NSString stringWithFormat:@"%@%@%d", triggerIdentifier, keyValueSeperator, triggerNr];
}

-(NSString*)stringForStimEvent:(NEStimEvent*)event
{
    // @"E:{time,duration,ID}"
    return [NSString stringWithFormat:@"%@%@%@%d%@%d%@%@%@%.0f,%0.f%@", 
            eventIdentifier, 
            keyValueSeperator, 
            beginSetDelimiter, 
            [event time], 
            entrySeperator,
            [event duration], 
            entrySeperator,
            [[event mediaObject] getID],
            entrySeperator,
            [[event mediaObject] position].x,
            [[event mediaObject] position].y,
            endSetDelimiter];
}

-(NSString*)stringForActionThen:(NSDictionary *)action
{
    return @"t";//[NSString stringWithFormat:@"", ];
}

-(NSString*)stringForActionElse:(NSDictionary*)action
{
    return @"t";//[NSString stringWithFormat:@"", ];
}

@end
