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
     * Path (relative or absolute) to the EDL file used to fill
     * the configuration.
     */
    NSString* mEDLFilePath;
    
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
//+(COSystemConfig*)getInstance;

/**
 * Initializes the configuration with the information from an EDL file.
 *
 * \param edlPath  Path to the EDL file.
 * \return         Nil if successful, error object otherwise.
 */
-(NSError*)fillWithContentsOfEDLFile:(NSString*)edlPath;

/**
 * Validates the already filled configuration against a 
 * XML schema definition.
 *
 * \param xsdPath The path to the XSD file. Pass nil to use the schema
 *                path given in the EDL configuration file.
 *                The path may be absolute or relative to the position of the
 *                EDL file. Absolute URLs are also accepted, relative URL however
 *                not (you need to convert them into absolute URLs beforehand).
 * \return        Errors that occured during the validation. Returns nil
 *                if the validation succeeded.
 */
-(NSError*)validateAgainstXSD:(NSString*)xsdPath;

/**
 * Returns the path to the EDL file used by the configuration
 * (including filename and extension).
 *
 * \return Exactly the same path used to fill the configuration
 *         (if it was filled using a relative path it returns a
 *          relative path; if it was filled using a absolute path
 *          it returns a absolute path).
 *         Returns nil if the config has not been filled yet.
 */
-(NSString*)getEDLFilePath;

/**
 * Writes the current configuration state into a file.
 *
 * \param path The file path to write the configuration state to.
 * \return     NSError object if writing the file was not successful.
 *             Nil otherwise.
 */
-(NSError*)writeToFile:(NSString*)path;

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

/**
 * Replaces a configuration property/entry with a XML node.
 * You can only replace attributes with attribute nodes and elements 
 * with element nodes.
 *
 * \param key  Complete XPath to the desired config entity according 
 *			   to EDL specification.
 *             Alternative: short keyword definitely identifiing the
 *			   wanted config entry (predefined, starts with character "$").
 * \param node XML node to replace the config entry at key. If nil: the config
 *             entry will be deleted.
 * \return     NSError if something went wrong during the replacement process.
 *             
 */
-(NSError*)replaceProp:(NSString*)key 
              withNode:(NSXMLNode*)node;


@end
