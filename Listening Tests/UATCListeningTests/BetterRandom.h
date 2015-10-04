//
//  BetterRandom.h
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 11/07/2015.
//  Copyright (c) 2015 Oliver Hawker. All rights reserved.
//

#ifndef UATC_Listening_Tests_BetterRandom_h
#define UATC_Listening_Tests_BetterRandom_h

#include <time.h>


#define a 48271
#define m 2147483647
#define q (m / a)
#define r (m % a)

static int seed = time(0);

extern "C" {

    static long BetterRandom()
    {
        long int hi = seed / q;
        long int lo = seed % q;
        long int test = a * lo - r * hi;
        if(test > 0)
            seed = test;
        else	seed = test + m;
        return seed;
    }

}

#endif