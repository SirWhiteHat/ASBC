//
//  uatcEffectorIir.h
//  UATC
//
//  Created by Oliver Hawker on 15/07/14.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef UATC_uatcEffectorIir_h
#define UATC_uatcEffectorIir_h

// DIRECT-FORM II (single central delay register)

#include "uatcEffector.h"
#include "uatcDspIir.h"
#include <iostream>

// Has a tendency to become unstable. Not recommended; use FIR or SOS instead.

class uatcEffectorIir : public uatcEffector
{
private:
    const int filterSize = 32;
    int attenuation = 0;
    uatcDspIirII* iirFilter;
public:
    uatcEffectorIir(){
        iirFilter = new uatcDspIirII(filterSize);
    };
    ~uatcEffectorIir(){
        delete iirFilter;
    }
    void setAttenuation(float dbAttenuation){
        if (dbAttenuation < -80) dbAttenuation = -80;
        if (dbAttenuation > 0) dbAttenuation = 0;
        if ((0-(int)dbAttenuation) != attenuation)
        {
            attenuation = 0-(int)dbAttenuation;
        }
    }
    void processBlock(float *data, float deltaPhon){
        this->setAttenuation(deltaPhon);
        
        iirFilter->bCoefficients = &Iiryw32BDouble[attenuation][0];
        iirFilter->aCoefficients = &Iiryw32ADouble[attenuation][0];
        
        iirFilter->processBlock(data, bufferSize, attenuation);
    };
    int inducedLatency()
    {
        return 0;
    }
    int getBufferSize() { return bufferSize; };
};

#endif