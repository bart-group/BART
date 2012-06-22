//
//  BAConstants.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    BA_NODE_TYPE_UNKNOWN    = 0x0,
    BA_NODE_TYPE_SESSION    = 0x1,
    BA_NODE_TYPE_EXPERIMENT = 0x2,
    BA_NODE_TYPE_STEP       = 0x3
};

typedef NSUInteger BASessionTreeNodeType;


enum {
    BA_NODE_STATE_UNKNOWN             = 0x0,
    BA_NODE_STATE_ERROR               = 0x1,
    BA_NODE_STATE_NEEDS_CONFIGURATION = 0x2,
    BA_NODE_STATE_READY               = 0x3,
    BA_NODE_STATE_RUNNING             = 0x4,
    BA_NODE_STATE_FINISHED            = 0x5
}

typedef NSUInteger BASessionTreeNodeState;

@end
