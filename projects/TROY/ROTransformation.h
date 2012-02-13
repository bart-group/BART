//
//  ROTransformation.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/11/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ROTypedef.h"

#import "itkDisplacementFieldCompositionFilter.h"

@interface ROTransformation : NSObject {
    DeformationFieldType::Pointer m_Trans;
}

-(id)initWithTransform:(DeformationFieldType::Pointer)trans;

-(DeformationFieldType::Pointer)getTransform;

// return = other o this
-(ROTransformation*)join:(ROTransformation*)other;

@end
