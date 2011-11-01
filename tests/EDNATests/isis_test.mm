//
//  isis_test.mm
//  BARTApplication
//
//  Created by Lydia Hellrung on 6/24/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "isis_test.h"
#import "EDNA/EDDataElementIsis.h"
#import "CoreUtils/common.hpp"

#import "RORegistration.h"



@implementation isis_test

@end

int main(void)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
//    NSString* imageFile = @"TestDataset01-functional.nii";
    NSString* imageFile = @"/Users/oliver/test/reg3d_test/dataset01/data.nii";
    EDDataElementIsis* functionalData = [[EDDataElementIsis alloc] initWithFile:imageFile
                                                                      andSuffix:@"" 
                                                                     andDialect:@"" 
                                                                    ofImageType:IMAGE_FCTDATA];

    NSString* referenceFile = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii";
    EDDataElementIsis* reference = [[EDDataElementIsis alloc] initWithFile:referenceFile
                                                                 andSuffix:@"" 
                                                                andDialect:@"" 
                                                               ofImageType:IMAGE_ANADATA];
    RORegistration* registration = [[RORegistration alloc] init];
    EDDataElement* dataElement = [registration align:functionalData 
                                       withReference:reference];
    
    [dataElement WriteDataElementToFile:@"/tmp/IsisTestDataElem.nii"];
    
    [functionalData release];
    [reference release];
    [registration release];
   
	[pool drain];
}