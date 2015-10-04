//
//  UATC.cpp
//  UATC
//
//  Created by Oliver Hawker on 05/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#include "UATC.h"
#include <math.h>
#include "uatcDspManager.h"

uatcDspManager* dsp; // default initialiser
float currentDeltaPhon;

UATC::UATC(int NumChannels, int BufferSize, uatcDspMethod uatcDspMethod)
{
    numChannels = NumChannels;
    bufferSize = BufferSize;
    dsp = new uatcDspManager(numChannels, bufferSize);
}

#pragma mark Effector routines

void UATC::applyLoudnessChange(float *data, int BufferSize, int NumChannels, float deltaPhon){
    if (BufferSize != bufferSize || NumChannels != numChannels)
    {
        bufferSize = BufferSize;
        numChannels = NumChannels;
        bool bypass = dsp->getBypass();
        delete dsp;
        dsp = new uatcDspManager(numChannels, bufferSize);
        dsp->setBypass(bypass);
    }
    dsp->processBlock(data, deltaPhon);
}

void UATC::setBypass(bool Bypass){
    dsp->setBypass(Bypass);
}