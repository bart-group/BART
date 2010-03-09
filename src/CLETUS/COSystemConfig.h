//
//  COSystemConfig.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


enum COSystemConfigError {
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
 * Initializes the configuration with the information from an EDL file.
 *
 * \param edlPath  Path to the EDL file.
 * \return         Nil if successful, error object otherwise.
 */
-(NSError*)initializeWithContentsOfEDLFile:(NSString*)edlPath;

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


@end
