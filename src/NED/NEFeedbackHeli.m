//
//  NEFeedbackHeli.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEFeedbackHeli.h"
#import "NEHeliWindowController.h"


@interface _NEHeliBullet : NSObject
{
    NSPoint position;
    CGFloat speed;
}

@property (readwrite) NSPoint position;
@property (readwrite) CGFloat speed;

-(id)initWithPosition:(NSPoint)pos
             andSpeed:(CGFloat)v;

@end

@implementation _NEHeliBullet

@synthesize position;
@synthesize speed;

-(id)initWithPosition:(NSPoint)pos
             andSpeed:(CGFloat)v
{
    if ((self = [super init])) {
        position = pos;
        speed = v;
    }
    
    return self;
}

@end


@implementation NEFeedbackHeli

-(id)initWithFrame:(NSRect)frame
     andParameters:(NSDictionary*)params 
{
    if ((self = [super initWithFrame:frame andParameters:params])) {
        
        if ([parameters valueForKey:@"height"]) {
            height = [[parameters valueForKey:@"height"] floatValue];
        } else {
            height = 0.0;
        }
        if ([parameters valueForKey:@"minHeight"]) {
            minHeight = [[parameters valueForKey:@"minHeight"] floatValue];
        } else {
            minHeight = 0.0;
        }
        if ([parameters valueForKey:@"maxHeight"]) {
            maxHeight = [[parameters valueForKey:@"maxHeight"] floatValue];
        } else {
            maxHeight = 100.0;
        }
        
        if ([parameters valueForKey:@"firerate"]) {
            firerate = [[parameters valueForKey:@"firerate"] floatValue];
        } else {
            firerate = 0.0;
        }
        if ([parameters valueForKey:@"minFirerate"]) {
            minFirerate = [[parameters valueForKey:@"minFirerate"] floatValue];
        } else {
            minFirerate = 0.0;
        }
        if ([parameters valueForKey:@"maxFirerate"]) {
            maxFirerate = [[parameters valueForKey:@"maxFirerate"] floatValue];
        } else {
            maxFirerate = 3.0;
        }

        heliWindowController = [[NEHeliWindowController alloc] initWithWindowNibName:@"HeliControl"];
        [[heliWindowController window] setStyleMask:(NSTitledWindowMask
                                                     | NSMiniaturizableWindowMask
                                                     | NSResizableWindowMask)];
        [[heliWindowController window] setMovableByWindowBackground:YES];
        [heliWindowController setFeedbackObject:self];
        [heliWindowController showWindow:nil];
        
        bullets = [[NSMutableArray alloc] initWithCapacity:0];
        bulletCooldown = 0;
        
    }
    
    return self;
}

-(void)tick
{
    if ([parameters valueForKey:@"height"]) {
        height = ([[parameters valueForKey:@"height"] floatValue] / maxHeight) 
                 * ([self bounds].size.height - 33.0)
                 + minHeight; // 33.0 = height of the heli sprite.
    }
    if ([parameters valueForKey:@"firerate"]) {
        firerate = [[parameters valueForKey:@"firerate"] floatValue];
    }

    NSMutableArray* bulletsToRemove = [NSMutableArray arrayWithCapacity:0];
    for (_NEHeliBullet* bullet in bullets) {
        NSPoint newPosition = NSMakePoint(bullet.position.x + 3.0, bullet.position.y);
        [bullet setPosition:newPosition];
        if (bullet.position.x > [self bounds].size.width) {
            [bulletsToRemove addObject:bullet];
        }
    }
    [bullets removeObjectsInArray:bulletsToRemove];
    
    bulletCooldown++;
    if (firerate > 0.0) {
        if (bulletCooldown >= (60 / firerate)) {
            [bullets addObject:[[[_NEHeliBullet alloc] initWithPosition:NSMakePoint(40.0, height + 15.0) andSpeed:1.0] autorelease]];
            bulletCooldown = 0;
        }
    } else {
        bulletCooldown = 60;
    }
}

-(void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, dirtyRect);
    
    NSString* heli = @">";
    
    [[NSColor blackColor] setStroke];
    [[NSColor blackColor] setFill];
    
    CGContextSelectFont(context, "Monaco" /*"Arial"*//* "Helvetica-Bold" */, 60.0, kCGEncodingMacRoman);
    //CGContextSetCharacterSpacing(context, 1); 
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextShowTextAtPoint(context, 10.0, height, [heli cStringUsingEncoding:NSUTF8StringEncoding], [heli length]);
    
    // Draw bullets.
    NSRect bulletRect = NSMakeRect(0.0, 0.0, 4.0, 2.0);
    for (_NEHeliBullet* bullet in bullets) {
        bulletRect.origin.x = bullet.position.x;
        bulletRect.origin.y = bullet.position.y;
        CGContextFillRect(context, bulletRect);
    }
}

-(void)dealloc
{
    [heliWindowController release];
    [super dealloc];
}

@end
