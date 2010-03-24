//
//  COSystemConfig.h
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
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
    
    /**
     * Original configuration from the EDL file. Remains unchanged
     * during runtime.
     */
    NSXMLDocument* mSystemSetting;
    
    /**
     * Copy of the original configuration. Changes to the experiment
     * configuration that occur during runtime are stored here.
     */
    NSXMLDocument* mRuntimeSetting;
    
    /**
     * Dictionary that eliminates the need of knowing the exact XPath
     * for often used configuration entries (e.g. RepetitionTime).
     */
    NSDictionary* mAbbreviations;
	
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
-(NSError*)fillWithContentsOfEDLFile:(NSString*)edlPath;

/**
 * Sets a property for a given key.
 *
 * \param key   Complete XPath to the desired config entity according 
 *			    to EDL specification.
 *              Alternative: short keyword definitely identifiing the
 *			    wanted config entry (predefined, starts with character "$").
 * \param value Value to change/insert (string representation).
 * \return      Nil if successful, error object otherwise.
 */
-(NSError*)setProp:(NSString*)key :(NSString*)value;

/**
 * Returns a requested value for a given key.
 *
 * \param key Complete XPath to the desired config entity according 
 *			  to EDL specification.
 *            Alternative: short keyword definitely identifiing the
 *			  wanted config entry (predefined, starts with character "$").
 * \return    Value for key (string representation).
 *            Returns nil if no value or more than 
 *            one value is associated with key.
 */
-(NSString*)getProp:(NSString*)key;

/**
 * Returns the number of nodes for a given key.
 *
 * \param key Complete XPath to the desired config entity according 
 *			  to EDL specification.
 *            Alternative: short keyword definitely identifiing the
 *			  wanted config entry (predefined, starts with character "$").
 * \return    Number of nodes that are referenced by key.
 */
-(NSUInteger)countNodes:(NSString*)key;


@end
