//
//  PRPreprocessor.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/30/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//


#ifndef PRPREPROCESSOR_H
#define PRPREPROCESSOR_H


#import <Cocoa/Cocoa.h>
#import <EDNA/EDDataElement.h>


@interface PRPreprocessor : NSObject {

}


-(BOOL)preprocessTheData:(EDDataElement*)data
           timestepRange:(NSRange)range;

@end



#endif // PRPREPROCESSOR_H