//
//  UATCDemo.m
//  UATC Demo
//
//  Created by Oliver Hawker on 05/06/2014.
//

#import "UATCDemo.h"

@implementation UATCDemo

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    if (_ringBuffer){
        delete _ringBuffer;
    }
}

-(void)beginDemo
{
    self.audioManager = [Novocaine audioManager];
    self.ringBuffer = new RingBuffer(32768, 2);
    self.uatc = new UATC(2,512,uatcDspMethodFir1024);
    
    __weak UATCDemo * wself = self;
    
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Bill Withers" withExtension:@"mp3"];
    self.fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numOutputChannels];
    [self.fileReader play];
    
    __block int counter = 0;
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    {
        [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
        
        for (int i = 0; i < numFrames; i++)
        {
            for (int c = 0; c < numChannels; c++)
            {
//                data[c+(i*numChannels)] = i+(counter*numFrames);
            }
        }
        
        wself.uatc->setBypass(wself.bypass);
        wself.uatc->applyLoudnessChange(static_cast<float*>(data), numFrames, numChannels, wself.deltaPhon);
        
        counter++;
        if (counter % 80 == 0)
            NSLog(@"Time: %f", wself.fileReader.currentTime);
         
    }];
    
    [self.audioManager play];
}

-(void)setSongName:(NSString*)songName
{
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:songName withExtension:@"mp3"];
    self.fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numOutputChannels];
    [self.fileReader play];
}

-(void)returnToZero
{
    self.fileReader.currentTime = 0;
}

@end