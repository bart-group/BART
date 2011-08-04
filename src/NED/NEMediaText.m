//
//  NEMediaText.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEMediaText.h"


@implementation NEMediaText

-(id)initWithID:(NSString*)objID
        andText:(NSString*)text
{
    if (self = [super init]) {
        mID    = [objID retain];
        mText  = [text retain];
        mSize  = 5;
        mColor = [[NSColor whiteColor] retain];
    }
    
    return self;
}
-(id)initWithID:(NSString*)objID
           Text:(NSString*)text 
         inSize:(NSUInteger)size 
       andColor:(NSColor*)color 
      atPostion:(NSPoint)position
{
    if (self = [super init]) {
        mID       = [objID retain];
        mText     = [text retain];
        mSize     = size;
        mColor    = [color retain];
        mPosition = position;
    }
    
    return self;
}


-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
//    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1); 
//    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    [mColor setStroke];
    [mColor setFill];
    CGContextSelectFont(context, "Monaco" /*"Arial"*//* "Helvetica-Bold" */, (CGFloat)mSize, kCGEncodingMacRoman);
    //CGContextSetCharacterSpacing(context, 1); 
    CGContextSetTextDrawingMode(context, kCGTextFillStroke); 
    CGContextShowTextAtPoint(context, mPosition.x, mPosition.y, [mText cStringUsingEncoding:NSUTF8StringEncoding], [mText length]);
}

-(void)dealloc
{
    [mID release];
    [mText release];
    [mColor release];
    
    [super dealloc];
}

@end
