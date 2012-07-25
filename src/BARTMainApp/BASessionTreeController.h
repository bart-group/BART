//
//  BASessionTreeController.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BASessionTreeNode.h"


@interface BASessionTreeController : NSTreeController <NSOutlineViewDelegate, NSOutlineViewDataSource> {
    
}

@property (readonly) NSArray *treeRoots;


@end
