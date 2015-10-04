//
//  uatcDspFdfireff1024.h
//  UATC
//
//  Created by Oliver Hawker on 18/07/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__uatcDspFYP__
#define __UATC__uatcDspFYP__

#include <iostream>

#include "uatcEffector.h"
#include "uatcDspOverlapAdd.h"
#include "uatcMatlab.h"
#include <Accelerate/Accelerate.h>

class uatcEffectorFdfireff : public uatcEffector
{
    int bufferSize = 1024;
private:
    const int convolutionSize = 2048;
    float *paddedBuffer;
    float *tailBuffer;
    int attenuation = 100;
    
    DSPSplitComplex currentFilter;
    DSPSplitComplex tempSplitComplex;
    
    FFTSetup fftSetup;
    
    const int LOG_N = 11; // 2^11 = 2048
    const int N = 1 << LOG_N;
public:
    uatcEffectorFdfireff(){
        paddedBuffer = new float[convolutionSize]();
        tailBuffer = new float[convolutionSize/2]();
        currentFilter.realp = new float[convolutionSize];
        currentFilter.imagp = new float[convolutionSize];
        fftSetup = vDSP_create_fftsetup(LOG_N, kFFTRadix2);
        tempSplitComplex.realp = new float[N];
        tempSplitComplex.imagp = new float[N];
    };
    void setAttenuation(float dbAttenuation){
        if (dbAttenuation < -80) dbAttenuation = -80;
        if (dbAttenuation > 0) dbAttenuation = 0;
        if (0-(int)dbAttenuation != attenuation)
        {
            attenuation = 0-(int)dbAttenuation;
            memcpy(currentFilter.realp,Fdfir1024RealFloat[attenuation][0],convolutionSize*sizeof(float));
            memcpy(currentFilter.imagp,Fdfir1024ImagFloat[attenuation][0],convolutionSize*sizeof(float));
        }
    }
    void processBlock(float *data, float deltaPhon){
        this->setAttenuation(deltaPhon);
        
        // Input data
        memcpy(paddedBuffer,data,bufferSize*sizeof(float));
        memset(paddedBuffer+bufferSize,0,bufferSize*sizeof(float));
        
        // Forward FFT
        vDSP_ctoz((DSPComplex*)paddedBuffer, 2, &tempSplitComplex, 1, N/2);
        
        // Do real->complex forward FFT
        vDSP_fft_zrip(fftSetup, &tempSplitComplex, 1, LOG_N, kFFTDirection_Forward);
        
        float preserveIRNyq = currentFilter.imagp[0];
        currentFilter.imagp[0] = 0;
        float preserveSigNyq = tempSplitComplex.imagp[0];
        tempSplitComplex.imagp[0] = 0;
        vDSP_zvmul(&tempSplitComplex, 1, &currentFilter, 1, &tempSplitComplex, 1, N, 1);
        tempSplitComplex.imagp[0] = preserveIRNyq * preserveSigNyq;
        currentFilter.imagp[0] = preserveIRNyq;

        // Do complex->real inverse FFT.
        vDSP_fft_zrip(fftSetup, &tempSplitComplex, 1, LOG_N, kFFTDirection_Inverse);
        
        // This leaves result in packed format. Here we unpack it into a real vector.
        vDSP_ztoc(&tempSplitComplex, 1, (DSPComplex*)paddedBuffer, 2, N/2);
        
        // Neither the forward nor inverse FFT does any scaling. Here we compensate for that.
        float scale = 0.5/N;
        vDSP_vsmul(paddedBuffer, 1, &scale, paddedBuffer, 1, N);
        
        memcpy(data,paddedBuffer,bufferSize*sizeof(float));
        vDSP_vadd(paddedBuffer,1,tailBuffer,1,data,1,bufferSize);
        memcpy(tailBuffer,paddedBuffer+bufferSize,bufferSize*sizeof(float));
    };
    
    int inducedLatency()
    {
        return bufferSize/2;
    }
    int getBufferSize() { return bufferSize; };
};

#endif /* defined(__UATC__uatcDspFYP__) */