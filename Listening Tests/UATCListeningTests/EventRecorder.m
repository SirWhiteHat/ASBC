//
//  EventRecorder.m
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 01/07/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import "EventRecorder.h"

@implementation EventRecorder

NSTimer* timer;
float ticks = 0;
float interval = 0.1;

-(id)init
{
    self = [super init];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    
    self.events = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)timerTick
{
    ticks += interval;
}

-(void)addEventWithType:(eventType)type andValue:(NSString*)value
{
    Event* event = [[Event alloc] init];
    
    event.type = type;
    event.value  = value;
    event.time = ticks;
    
    [_events addObject:event];
}

-(void)stop
{
    [timer invalidate];
}

@end

@implementation Event

@end

