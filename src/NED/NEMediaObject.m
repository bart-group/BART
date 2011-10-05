//
//  NEMediaObject.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEMediaObject.h"
#import "COExperimentContext.h"
#import "NEMediaText.h"
#import "NEMediaImage.h"
#import "NEMediaAudio.h"


@implementation NEMediaObject

@synthesize mPosition;

-(id)init
{
    if ((self = [super init])) {
        mPosition = (NSPoint) {0, 0};
        mID = @"";
    }
    
    return self;
}

-(id)initWithConfigEntry:(NSString*)key
{
    [self release];
    self = nil;
    
    COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
    
    NSString* objID   = [config getProp:[NSString stringWithFormat:@"%@/@moID", key]];
    NSString* objType = [config getProp:[NSString stringWithFormat:@"%@/@type", key]];
    
    if ([objType compare:@"TEXT"] == 0) {
        NSString* text = [config getProp:[NSString stringWithFormat:@"%@/contentText/text", key]];
        NSUInteger size = [[config getProp:[NSString stringWithFormat:@"%@/contentText/tSize", key]] intValue];
        // TODO: implement text color!
        NSColor* color = [NSColor colorWithCalibratedRed:1.0 
                                                   green:1.0 
                                                    blue:1.0 
                                                   alpha:1.0];
        NSPoint position;
        position.x = [[config getProp:[NSString stringWithFormat:@"%@/contentText/posX", key]] floatValue];
        position.y = [[config getProp:[NSString stringWithFormat:@"%@/contentText/posY", key]] floatValue];

        self = [[NEMediaText alloc] initWithID:objID
                                          Text:text 
                                        inSize:size
                                      andColor:color 
                                     atPostion:position];
        
    } else if ([objType compare:@"SOUND"] == 0) {
        NSString* soundFilePath = [config getProp:[NSString stringWithFormat:@"%@/contentSound/soundFile", key]];
        self = [[NEMediaAudio alloc] initWithID:objID 
                                        andFile:soundFilePath];
        
    } else if ([objType compare:@"IMAGE"] == 0) {
        NSString* imageFilePath = [config getProp:[NSString stringWithFormat:@"%@/contentImage/imageFile", key]];
        NSPoint position;
        position.x = [[config getProp:[NSString stringWithFormat:@"%@/contentImage/posX", key]] floatValue];
        position.y = [[config getProp:[NSString stringWithFormat:@"%@/contentImage/posY", key]] floatValue];
        
        self = [[NEMediaImage alloc] initWithID:objID 
                                           file:imageFilePath 
                                      displayAt:position];
    }
    
    return self;
}

-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
    return;
}
-(void)pausePresentation
{
    return;
}
-(void)continuePresentation
{
    return;
}
-(void)stopPresentation
{
    return;
}

-(NSString*)getID
{
    return mID;
}




@end