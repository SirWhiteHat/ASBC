//
//  ABXTest.mm
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 30/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import "ABXTest.h"
#import <time.h>
#import "BetterRandom.h"

#define SAMPLE_FILENAME @"%ishort"

@implementation ABXTest

bool hasFlipped; // If not flipped, "A" is UATC.
SEL finishedSelector;
id finishedTarget;

- (id)init
{
    self = [super init];

    self.uatc = new UATC(1,512,uatcDspMethodFir1024);
    self.audioManager = [Novocaine audioManager];
    self.ringBuffer = new RingBuffer(32768, 2);

    [self.audioManager pause];
    self.currentSelection = inputSelectionX;
    self.eventRecorder = [[EventRecorder alloc] init];
    
    return self;
}

-(void)initFileReader
{
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:SAMPLE_FILENAME,_sampleId] withExtension:@"mp3"];
    self.fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numOutputChannels];
    
    _duration = self.fileReader.duration;
}

-(void)runTestWithSampleID:(int)ID andAttenuation:(int)attenuation andFinishedSelector:(SEL)selector andFinishedTarget:(id)target;
{
    self.attenuation = attenuation;
    hasFlipped  = BetterRandom() % 2;
    
    _sampleId = ID;
    
    finishedSelector = selector;
    finishedTarget = target;
    __weak ABXTest* wself = self;
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    {
        if (wself)
        {
            if (wself.fileReader.currentTime >= wself.duration)
            {
                wself.fileReader.currentTime = 0;
                [wself.audioManager pause];
            }
            
            [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
            
            wself.uatc->applyLoudnessChange(static_cast<float*>(data), numFrames, numChannels, wself.attenuation);
        }
    }];
    
    if (hasFlipped)
        [_eventRecorder addEventWithType:eventTypeStart andValue:@"B"];
    else
        [_eventRecorder addEventWithType:eventTypeStart andValue:@"A"];
    
    [_eventRecorder addEventWithType:eventTypeMetaAttenuation andValue:[NSString stringWithFormat:@"%f",_attenuation]];
    [_eventRecorder addEventWithType:eventTypeMetaSample andValue:[NSString stringWithFormat:SAMPLE_FILENAME,ID]];
}

-(void)PlayWithChoice:(choiceSelection)choice
{
    bool shouldBypass = (choice == choiceSelectionB)^hasFlipped;

    if (_fileReader)
    {
        [_fileReader stop];
    }
    
    [self initFileReader];
    
    NSLog(@"%i",shouldBypass);
    _uatc->setBypass(shouldBypass);
    
    [_fileReader play];
    [_audioManager play];
    
    switch(choice)
    {
        case choiceSelectionA:
            [_eventRecorder addEventWithType:eventTypeSamplePreviewed andValue:@"A"];
            break;
        case choiceSelectionB:
            [_eventRecorder addEventWithType:eventTypeSamplePreviewed andValue:@"B"];
            break;
    }
}

-(void)choiceChanged:(choiceSelection)selection
{
    switch(selection)
    {
        case choiceSelectionA:
            [_eventRecorder addEventWithType:eventTypeChoiceChanged andValue:@"A"];
            break;
        case choiceSelectionB:
            [_eventRecorder addEventWithType:eventTypeChoiceChanged andValue:@"B"];
            break;
    }
}

-(void)submit
{
    [_eventRecorder addEventWithType:eventTypeSubmitted andValue:@""];
    [_audioManager pause];
    [_fileReader stop];
    [_eventRecorder stop];
    [finishedTarget performSelector:finishedSelector withObject:nil];
}

@end
