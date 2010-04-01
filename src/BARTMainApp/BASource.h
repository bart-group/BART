//
//  BASource.h
//  BARTCommandLine
//
//  Created by First Last on 10/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADataElement.h"


@interface BASource : NSObject {

       
    BAElement* mElement;
    NSArray* mFiles;
}

/**
 * Initialize with a file containing a part of an image dataset (e.g. the volume data from a single timestep).
 */

-(id) initWithDatasetPartFiles:(NSArray *) files;


/**
 * Initialize with a file containing the complete set of image data.
 */
-(id) initWithDatasetFile:(NSString*) file ofImageType:(enum ImageType)type;


/**
 * Initialize with a pipe from a network connection.
 */
-(id) initWithPipe:(NSString*) pipeName;

-(BADataElement*)getData;

@end


#pragma mark -

@interface BASource (AbstractMethods)

/**
 * Loads the whole image from source (file, pipe, etc.).
 */
-(void)loadFromSource;

/**
 * Has to be called by DataControl to inform about newly arrived data.
 */
-(void)newDataArrived;

@end





