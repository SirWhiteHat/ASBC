//
//  overlapAdd.h
//  UATC
//
//  Created by Oliver Hawker on 07/07/14.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__overlapAdd__
#define __UATC__overlapAdd__

#include <iostream>

class uatcDspOverlapAdd {
    int extBufferSize;
    int intBufferSize;
    int numberOfSections;
    float* workingBuffer;
    float** section; // [ID][Sample]
    int latestSection;
    
public:
    uatcDspOverlapAdd(int extBufferSize, int intBufferSize);
    ~uatcDspOverlapAdd();
    float* paddedBuffer(float *data);
    void processBlock(float *inputData, float *outputData);
};

#endif /* defined(__UATC__overlapAdd__) */
