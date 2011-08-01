//
//  isis_test.mm
//  BARTApplication
//
//  Created by Lydia Hellrung on 6/24/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "isis_test.h"
#import "EDDataElementIsisRealTime.h"
#import "../../src/EDNA/EDDataElement.h"
#import "CoreUtils/common.hpp"



@implementation isis_test

@end

int main(void)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    std::list<isis::data::Chunk> chList;
    
    isis::image_io::enableLog<isis::util::DefaultMsgPrint>( isis::info );
	isis::data::enableLog<isis::util::DefaultMsgPrint>( isis::info );
	isis::util::enableLog<isis::util::DefaultMsgPrint>( isis::warning );
	
    BARTImageSize *imSize = [[BARTImageSize alloc] init];
    EDDataElementIsisRealTime *dataElem = [[EDDataElementIsisRealTime alloc] initEmptyWithSize:imSize ofImageType:IMAGE_FCTDATA];
	
    
    size_t i = 0;
    for (size_t t = 0; t < 123; t++) {
        
        for (size_t sl = 0; sl < 10;sl++){
            isis::data::MemChunk<float> ch(20,30);
            for (size_t r = 0; r < 30; r++) {
                for (size_t c = 0; c < 20; c++) {
                    ch.voxel<float>(c,r) = i++;
                }
            }
            ch.setPropertyAs<isis::util::fvector4>("indexOrigin", isis::util::fvector4(0,0,sl));
            ch.setPropertyAs<u_int32_t>("acquisitionNumber", sl+t*10);
            ch.setPropertyAs<u_int16_t>("sequenceNumber", 1);
            ch.setPropertyAs<isis::util::fvector4>("voxelSize", isis::util::fvector4(1,1,1,0));
            ch.setPropertyAs<isis::util::fvector4>("rowVec", isis::util::fvector4(1,0,0,0));
            ch.setPropertyAs<isis::util::fvector4>("columnVec", isis::util::fvector4(0,1,0,0));
            ch.setPropertyAs<isis::util::fvector4>("sliceVec", isis::util::fvector4(0,0,1,0));
            chList.push_back(ch);
        
        }
        isis::data::Image img(chList);
        [dataElem appendVolume:img];
    }
   
    
    for (size_t t =0; t < 10;t++){
        for (size_t sl = 0; sl < 10; sl++) {
            
            float val = [dataElem getFloatVoxelValueAtRow:1 col:1 slice:sl timestep:t];  
            NSLog(@"%.0f", val);
            }
        }
        
    [dataElem WriteDataElementToFile:@"/tmp/ohmygoodness.nii"];
    
    [dataElem release];
	[pool drain];
}