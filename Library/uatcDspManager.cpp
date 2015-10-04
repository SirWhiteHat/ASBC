//
//  uatcDsp.cpp
//  UATC
//
//  Created by Oliver Hawker on 12/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#include "uatcDspManager.h"
#include "uatcEffectorFdfireff.h"
#include "uatcEffectorIir.h"
#include <math.h>

uatcDspManager::uatcDspManager(int NumChannels, int ExternalBufferSize)
{
    // Setup UATC streams for given channel count, and negotiate buffer size
    numChannels = NumChannels;
    
    channelBuffer = new float*[numChannels];
    delayBuffer = new float*[numChannels];
    effector = new uatcEffector*[numChannels];

    for (int i = 0; i < numChannels; i++)
    {
        effector[i] = new uatcEffectorFdfireff();
        isManaged = effector[i]->getBufferSize(); // if both DSP and external require fixed buffer sizes, initiate buffer management
        
        if (isManaged) // Set up for managed buffering
        {
            bufferSize = effector[i]->getBufferSize();
            inducedLatency = bufferSize+effector[i]->inducedLatency();
        }
        else // Set up to follow global buffer size
        {
            bufferSize = ExternalBufferSize;
            inducedLatency = effector[i]->inducedLatency();
            effector[i]->setBufferSize(bufferSize);
        }
        
        externalBufferSize = ExternalBufferSize;
        
        channelBuffer[i] = new float[bufferSize]();
        delayBuffer[i] = new float[inducedLatency+1]();
    }
}

uatcDspManager::uatcDspManager()
{
    for (int i = 0; i < numChannels; i++)
    {
        delete effector[i];
        delete[] channelBuffer[i];
        delete[] delayBuffer[i];
    }
    
    delete[] effector;
    delete[] channelBuffer;
    delete[] delayBuffer;
}

void uatcDspManager::deinterAndProcessManaged(float *data, float deltaPhon)
{
    float inputSample = 0;
    for (int sample = 0; sample < externalBufferSize; sample++)
    {
        for (int channel = 0; channel < numChannels; channel++)
        {
            inputSample = data[sample*numChannels+channel];
            //Copy processed sample from outputBuffer
            if (bypass)
            {
                data[sample*numChannels+channel] = delayBuffer[channel][delayPointer] * pow(10,deltaPhon/20);
            }
            else
            {
                data[sample*numChannels+channel] = channelBuffer[channel][pointer];
            }
            //Copy input sample to channelBuffer
            channelBuffer[channel][pointer] = inputSample;
            delayBuffer[channel][delayPointer] = inputSample;
        }
        pointer++;
        delayPointer++;
        if (delayPointer >= inducedLatency) delayPointer = 0;
        if (pointer >= bufferSize) // If buffer is full
        {
            for (int channel = 0; channel < numChannels; channel++)
            {
                effector[channel]->processBlock(channelBuffer[channel],deltaPhon);
            }
            pointer = 0;
        }
    }
}

void uatcDspManager::deinterAndProcessUnmanaged(float *data, float deltaPhon)
{
    float inputSample = 0;
    for (int channel = 0; channel < numChannels; channel++)
    {
        for (int sample = 0; sample < externalBufferSize; sample++)
        {
            //Copy input sample to channelBuffer
            inputSample = data[sample*numChannels+channel];
            channelBuffer[channel][sample] = inputSample;
            if(bypass)
                data[sample*numChannels+channel] = delayBuffer[channel][delayPointer] * pow(10,deltaPhon/20);
            delayBuffer[channel][delayPointer] = inputSample;
            delayPointer++;
            if (delayPointer >= inducedLatency) delayPointer = 0;
        }
        effector[channel]->processBlock(channelBuffer[channel],deltaPhon);
        if (!bypass)
        {
            for (int sample = 0; sample < externalBufferSize; sample++)
            {
                    data[sample*numChannels+channel] = channelBuffer[channel][sample];
            }
        }
    }
}