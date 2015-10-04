//
//  ABXTest.h
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 30/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "RingBuffer.h"
#import <UATC.h>
#import "EventRecorder.h"

typedef enum
{
    inputSelectionA,
    inputSelectionX,
    inputSelectionB
} inputSelection;

typedef enum
{
    choiceSelectionA,
    choiceSelectionB
} choiceSelection;

@interface ABXTest : NSObject

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, assign) RingBuffer *ringBuffer;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic) UATC* uatc;
@property (nonatomic) float attenuation;
@property (nonatomic) float duration;
@property (nonatomic) inputSelection currentSelection;
@property (nonatomic, strong) EventRecorder* eventRecorder;
@property (nonatomic) int sampleId;

-(void)runTestWithSampleID:(int)ID andAttenuation:(int)attenuation andFinishedSelector:(SEL)selector andFinishedTarget:(id)target;
-(void)choiceChanged:(choiceSelection)selection;
-(void)submit;
-(void)PlayWithChoice:(choiceSelection)choice;

@end