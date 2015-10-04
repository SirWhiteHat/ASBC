//
//  overlapAdd.cpp
//  UATC
//
//  Created by Oliver Hawker on 07/07/14.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#include "uatcDspOverlapAdd.h"
#include <math.h>

uatcDspOverlapAdd::uatcDspOverlapAdd(int ExtBufferSize, int IntBufferSize)
{
    extBufferSize = ExtBufferSize;
    intBufferSize = IntBufferSize;
    latestSection = 0;
    numberOfSections = ceil(intBufferSize / extBufferSize);
    section = new float*[numberOfSections];
    workingBuffer = new float[intBufferSize]();
    for (int i = 0; i < numberOfSections; i++) {
        section[i] = new float[intBufferSize];
    }
}

uatcDspOverlapAdd::~uatcDspOverlapAdd()
{
    for (int i = 0; i < numberOfSections; i++)
        delete[] section[i];
    delete[] section;
    delete[] workingBuffer;
}

void uatcDspOverlapAdd::processBlock(float *inputData, float* outputData)
{
    int pointer = 0;
    
    memcpy(section[latestSection], inputData, intBufferSize * sizeof(float));
    memset(outputData, 0, extBufferSize * sizeof(float));
    
    for (int j = 0; j < numberOfSections; j++)
    {
        pointer = (extBufferSize*((j-latestSection+numberOfSections)%numberOfSections));
        for (int i = 0; i < extBufferSize; i++)
        {
            outputData[i] += section[j][i+pointer];
        }
    }
    latestSection++;
    if (latestSection >= numberOfSections) latestSection = 0;
}

float* uatcDspOverlapAdd::paddedBuffer(float *data)
{
    memcpy(workingBuffer, data, extBufferSize * sizeof(float));
    memset(workingBuffer+extBufferSize, 0, sizeof(float)*extBufferSize);
    
    return workingBuffer;
}