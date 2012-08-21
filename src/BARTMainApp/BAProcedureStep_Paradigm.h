//
//  BAProcedureStep_Paradigm.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/4/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef BAPROCEDURESTEP_PARADIGM_H
#define BAPROCEDURESTEP_PARADIGM_H

#import <Foundation/Foundation.h>
#import "BAProcedureStep.h"

@class NEDesignElement;

@interface BAProcedureStep_Paradigm : BAProcedureStep {
    
   
@private
    
}

@property (readonly, getter = designElement) NEDesignElement* mDesignElement;
//-(void)doWhatIWant;

@end

#endif //BAPROCEDURESTEP_PARADIGM_H
