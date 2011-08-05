//
//  BAProcedureStep_Anatomy.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/4/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAProcedureStep.h"
#import "EDNA/EDDataElement.h"


@interface BAProcedureStep_Anatomy : BAProcedureStep {
    
    EDDataElement *anatomyData;
@private
    
}

@property (retain) EDDataElement *anatomyData;

@end
