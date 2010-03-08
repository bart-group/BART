//
//  COEDLValidator.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface COEDLValidator: NSObject {
    
}
 
/**
 * Initializes the configuration with the information from an EDL file
 * and optionally checks its logical consistency.
 *
 * \param rulePath Path to the XML file containing the EDL 
 *                 logical validation rules (pass nil if not needed).
 * \return         Nil if successful, error object otherwise.
 */
-(id)initWithEDLRules:(NSString*)rulePath;
    
/**
 * Checks the logical consistency of the EDL configuration based on
 * the given EDL ruleset.
 */
-(NSError*)validateEDLConsistency;
    
/**
 * Resolves a reference to a XML node given in MATLAB syntax.
 *
 * \param ref  Reference path to the wanted EDL value in MATLAB syntax.
 * \param node Context node from which the reference path navigates.
 * \return     Value of the node referenced by ref.
 */
+(NSString*)substituteEDLValueForRef:(NSString*)ref
                         basedOnNode:(NSXMLNode*)node;

@end
