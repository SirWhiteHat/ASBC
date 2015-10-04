//
//  uatcDsp.h
//  UATC
//
//  Created by Oliver Hawker on 12/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__uatcBufferMatch__
#define __UATC__uatcBufferMatch__

#include <iostream>
#include "UATC.h"
#include "uatcEffector.h"

class uatcDspManager
{
private:
    bool isManaged = 0; // true if fixed buffer size required
    
    int numChannels = 0;
    int bufferSize; // buffer size used
    int externalBufferSize; // size of inputted blocks
    int inducedLatency; // latency compensation for bypassing
    bool bypass = false;
    
    float **channelBuffer;
    float **delayBuffer;
    uatcEffector **effector;
    int pointer = 0;
    int delayPointer = 0;

public:
    uatcDspManager(int numChannels, int bufferSize);
    uatcDspManager();
    void processBlock(float *data, float deltaPhon)
    {
        if (isManaged)
        this->deinterAndProcessManaged(data, deltaPhon);
    else
        this->deinterAndProcessUnmanaged(data, deltaPhon);
    }
    void setBypass(bool Bypass){bypass = Bypass;}
    bool getBypass(){return bypass;}
    void deinterAndProcessManaged(float *data, float deltaPhon);
    void deinterAndProcessUnmanaged(float *data, float deltaPhon);
};

#endif /* defined(__UATC__uatcBufferMatch__) */
