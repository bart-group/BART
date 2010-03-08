//
//  COSystemConfig.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum COSystemConfigError {
    URL_CREATION,
	XML_DOCUMENT_READ,
	CONFIG_ENTRY
};

/**
 * Class for storing realtime fMRI configuration (experiment setup,
 * design information, etc.)
 * Differentiates between original experiment config (pre experiment 
 * start) and runtime config (manipulation of the original config
 * during realtime analysis).
 */
@interface COSystemConfig : NSObject {
	
}

/**
 * Return the singleton COSystemConfig object.
 *
 * \return COSystemConfig object.
 */
+(COSystemConfig*)getInstance;

/**
 * Initializes the configuration with the information from an EDL file
 * and optionally checks its logical consistency.
 *
 * \param edlPath  Path to the EDL file.
 * \param rulePath Path to the XML file containing the EDL 
 *                 logical validation rules (pass nil if not needed).
 * \return         Nil if successful, error object otherwise.
 */
-(NSError*)initWithContentsOfEDLFile:(NSString*)edlPath 
                         andEDLRules:(NSString*)rulePath;

/**
 * Sets a property for a given key.
 *
 * \param key   Complete XPath to the desired config entity according 
 *			    to EDL specification.
 *              Alternative: short keyword definitely identifiing the
 *			    wanted config entry (predefined, starts with letter "s").
 * \param value Value to change/insert (string representation).
 * \return      Nil if successful, error object otherwise.
 */
-(NSError*)setProp:(NSString*)key :(NSString*)value;

/**
 * Returns a requested value for a given key.
 *
 * \param key See method setProp:key:value.
 * \return    Value for key (string representation).
 */
-(NSString*)getProp:(NSString*)key;

/**
 * Resolves a reference to a XML node given in MATLAB syntax.
 *
 * \param ref  Reference path to the wanted EDL value in MATLAB syntax.
 * \param node Context node from which the reference path navigates.
 * \return     Value of the node referenced by ref.
 */
-(NSString*)substituteEDLValueForRef:(NSString*)ref
                         basedOnNode:(NSXMLNode*)node;


@end
