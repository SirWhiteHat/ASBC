//
//  uatcDspFdfir1024.h
//  UATC
//
//  Created by Oliver Hawker on 13/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__uatcDspFYP__
#define __UATC__uatcDspFYP__

#include <iostream>

#include "uatcEffector.h"
#include "uatcDspFdfirApply.h"
#include "uatcDspOverlapAdd.h"

class uatcEffectorFdfir : public uatcEffector
{
    int bufferSize = 1024;
private:
    const int convolutionSize = 2048;
    float *paddedBuffer;
    int attenuation = 0;
    uatcDspOverlapAdd *overlapAdd = new uatcDspOverlapAdd(bufferSize,convolutionSize);
public:
    uatcEffectorFdfir(){
        paddedBuffer = new float[convolutionSize]();
    };
    ~uatcEffectorFdfir(){
        delete overlapAdd;
    }
    void setAttenuation(float dbAttenuation){
        if (dbAttenuation < -80) dbAttenuation = -80;
        if (dbAttenuation > 0) dbAttenuation = 0;
        attenuation = 0-(int)dbAttenuation;
    }
    void processBlock(float *data, float deltaPhon){
        this->setAttenuation(deltaPhon);
        paddedBuffer = overlapAdd->paddedBuffer(data);
        uatcDspFdfirApply(paddedBuffer,Fdfir1024RealFloat[attenuation][0],Fdfir1024ImagFloat[attenuation][0]); // MATLAB-generated code
        overlapAdd->processBlock(paddedBuffer,data);
    };
    int inducedLatency()
    {
        return bufferSize/2;
    }
    int getBufferSize() { return bufferSize; };
};

#endif /* defined(__UATC__uatcDspFYP__) */