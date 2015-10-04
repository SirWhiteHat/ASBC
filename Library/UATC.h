//
//  UATC.h
//  UATC
//
//  Created by Oliver Hawker on 05/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__UATC__
#define __UATC__UATC__

#define MAX_CHANNELS 8

enum uatcDspMethod
{
    uatcDspMethodFir1024,
    uatcDspMethodIir32,
};

class UATC
{
private:
    int bufferSize;
    int numChannels;
public:
    UATC(int numChannels, int bufferSize, uatcDspMethod uatcDspMethod);
    void applyLoudnessChange(float *data, int BufferSize, int NumChannels, float deltaPhon);
    void setUatcDspMethod(uatcDspMethod uatcDspMethod);
    void setBypass(bool Bypass);
};

#endif /* defined(__UATC__UATC__) */
