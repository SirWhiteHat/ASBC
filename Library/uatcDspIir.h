//
//  uatcDspIir.h
//  UATC
//
//  Created by Oliver Hawker on 16/07/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef UATC_iirTypeII_h
#define UATC_iirTypeII_h

class uatcDspIir {
protected:
    int bufferSize;
    int filterSize;
    int attenuation;
public:
    const double* bCoefficients;
    const double* aCoefficients;
    void processBlock(float* data, int numSamples, int Attenuation)
    {
        if (attenuation != Attenuation)
        {
            attenuation = Attenuation;
        }
        for (int i = 0; i < numSamples; i++)
        {
            data[i] = doSample(data[i]);
        }
    }
    void processBlock(double* data, int numSamples, int Attenuation)
    {
        if (attenuation != Attenuation)
        {
            attenuation = Attenuation;
        }
        for (int i = 0; i < numSamples; i++)
        {
            data[i] = doSample(data[i]);
        }
    }
    virtual double doSample(double) = 0;
};

class uatcDspIirII : public uatcDspIir {
private:
    double *delayRegister;
    double outSample;
    double currentSample;
public:
    uatcDspIirII()
    {
        // Default constructor
    }
    uatcDspIirII(int FilterSize){
        filterSize = FilterSize+1; // convert from filter order to processing depth
        delayRegister = new double[filterSize+1]();
    }
    ~uatcDspIirII()
    {
        delete[] delayRegister;
    }
    double doSample(double sample)
    {
        for (int j = filterSize-1; j > 0; j--)
        {
            delayRegister[j] = delayRegister[j-1];
        }
        delayRegister[0] = sample;
        for (int j = 1; j < filterSize; j++)
        {
            delayRegister[0] -= delayRegister[j] * aCoefficients[j];
        }
        sample = 0;
        for (int j = 0; j < filterSize; j++)
        {
            sample += delayRegister[j] * bCoefficients[j];
        }
        return sample;
    }
};

#endif
