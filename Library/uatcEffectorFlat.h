//
//  uatcDspFlatAttenuation.h
//  UATC
//
//  Created by Oliver Hawker on 12/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#ifndef __UATC__uatcDspFlatAttenuation__
#define __UATC__uatcDspFlatAttenuation__

#include <iostream>
#include "uatcEffector.h"
#include <math.h>

class uatcEffectorFlat : public uatcEffector
{
public:
    void processBlock(float *data, float deltaPhon){
        for (int i = 0; i < bufferSize; i++){
            data[i] *= pow(10,deltaPhon/20); // Do something to the data
        }
    };
};

#endif /* defined(__UATC__uatcDspFlatAttenuation__) */
