//
//  UATCDemo.h
//  UATC Demo
//
//  Created by Oliver Hawker on 05/06/2014.
//  Copyright (c) 2014 Datta Lab, Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"
#import <UATC.h>

@interface UATCDemo : NSObject

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic, strong) AudioFileWriter *fileWriter;
@property (nonatomic, assign) RingBuffer * ringBuffer;
@property (nonatomic) UATC* uatc;

@property (nonatomic) float deltaPhon;
@property (nonatomic) bool bypass;

-(void)beginDemo;
-(void)returnToZero;
-(void)setSongName:(NSString*)songName;

@end