//
//  uatcEffectorIirsos.h
//  UATC
//
//  Created by Oliver Hawker on 23/07/14.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef UATC_uatcEffectorIirsos_h
#define UATC_uatcEffectorIirsos_h

#include "uatcEffector.h"
#include "uatcDspIir.h"

class uatcEffectorIirsos : public uatcEffector
{
private:
    const int nFilters = 16;
    int attenuation = 0;
    uatcDspIirII* filters[16];
    double* doubleBuffer;
public:
    uatcEffectorIirsos(){
        for (int i = 0; i < nFilters; i++)
        {
            filters[i] = new uatcDspIirII(2);
        }
    }
    ~uatcEffectorIirsos()
    {
        for (int i = 0; i < nFilters; i++)
            delete filters[i];
        delete[] filters;
    }
    void setAttenuation(float dbAttenuation){
        if (dbAttenuation < -80) dbAttenuation = -80;
        if (dbAttenuation > 0) dbAttenuation = 0;
        if ((0-(int)dbAttenuation) != attenuation)
        {
            attenuation = 0-(int)dbAttenuation;
        }
        
        if (attenuation > 0)
        {
            float d = 4;
        }
        
        for (int i = 0; i < nFilters; i++)
        {
            filters[i]->bCoefficients = &Iirywsos32BDouble[attenuation][i][0];
            filters[i]->aCoefficients = &Iirywsos32ADouble[attenuation][i][0];
        }
    }
    void processBlock(float *data, float deltaPhon){
        doubleBuffer = new double[bufferSize]();
        
        this->setAttenuation(deltaPhon);
        
        for (int i = 0; i < bufferSize; i++)
        {
            doubleBuffer[i] = (double)data[i] * Iirywsos32GDouble[attenuation][0];
        }
        
        for (int i = 0; i < nFilters; i++)
        {
            filters[i]->processBlock(doubleBuffer, bufferSize, attenuation);
        }
        
        for (int i = 0; i < bufferSize; i++)
        {
            data[i] = (float)doubleBuffer[i];
        }
        
        delete[] doubleBuffer;
        
    };
    int inducedLatency()
    {
        return 0;
    }
    int getBufferSize() { return bufferSize; };
};

#endif
