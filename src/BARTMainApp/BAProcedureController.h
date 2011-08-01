//
//  BAProcedureController.h
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BAProcedureController : NSObject {
	
}


-(BOOL) initData;
-(BOOL) initDesign;
-(BOOL) initPresentation;
-(BOOL) initAnalyzer;
-(BOOL) startAnalysis;

@end
