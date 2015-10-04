//
//  uatcDspEffector.h
//  UATC
//
//  Created by Oliver Hawker on 12/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__uatcDsp__
#define __UATC__uatcDsp__

#include <iostream>
#include "uatcMatlab.h"

class uatcEffector
{
protected:
    int bufferSize = 0;
public:
    virtual int getBufferSize() { return bufferSize; };
    virtual ~uatcEffector(){};
    void setBufferSize(int BufferSize)
    {if (bufferSize == 0)
        bufferSize = BufferSize;};
    virtual void processBlock(float *inData, float deltaPhon) { };
    virtual int inducedLatency() { return 0; };
};

#endif /* defined(__UATC__uatcDsp__) */