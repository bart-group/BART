//
//  BADataElementRealTimeLoader.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 3/22/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADataElement.h"




@interface  BADataElementRealTimeLoader : NSObject 
{

}
@end

@interface BADataElementRealTimeLoader (AbstractMethods)

-(void)startRealTimeInputOfImageType;

@end