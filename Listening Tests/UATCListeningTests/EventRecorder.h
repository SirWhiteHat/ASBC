//
//  EventRecorder.h
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 01/07/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventRecorder : NSObject

typedef enum
{
    eventTypeStart,
    eventTypeMetaAttenuation,
    eventTypeMetaSample,
    eventTypeSamplePreviewed,
    eventTypeChoiceChanged,
    eventTypeSubmitted
} eventType;

@property (nonatomic, strong) NSMutableArray* events;

-(void)addEventWithType:(eventType)type andValue:(NSString*)value;
-(void)stop;

@end

@interface Event : NSObject

@property (nonatomic) eventType type;
@property (nonatomic, strong) NSString* value;
@property (nonatomic) float time;

@end