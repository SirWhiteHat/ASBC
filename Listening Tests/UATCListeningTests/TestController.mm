//
//  TestController.m
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 01/07/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import "TestController.h"
#import <math.h>
#import "BetterRandom.h"

@implementation TestController

int testCounter = 0;
int numberOfTests = 15;
int numberOfSamples = 5;

float minAttenuation = 12;
float maxAttenuation = 30;

-(id)init
{
    self = [super init];

    _test = [[ABXTest alloc] init];
    
    self.testIsRunning = false;
    
    self.fileNames = [[NSMutableArray alloc] init];
    self.testResults = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)startTest
{
    float attenuation = fmod(-BetterRandom()/100,(maxAttenuation-minAttenuation)) - minAttenuation;
    _testIsRunning = true;
    [_test runTestWithSampleID:testCounter%numberOfSamples andAttenuation:attenuation andFinishedSelector:@selector(testFinished) andFinishedTarget:self];
}

-(void)testFinished
{
    NSMutableArray* values = [[NSMutableArray alloc] init];
    
    for (Event* event in _test.eventRecorder.events) {
    
        NSString* data = @"";
        
        switch (event.type) {
            case eventTypeStart:
                data = @"Start";
                break;
            case eventTypeSamplePreviewed:
                data = @"InputChanged";
                break;
            case eventTypeChoiceChanged:
                data = @"ChoiceChanged";
                break;
            case eventTypeSubmitted:
                data = @"Submitted";
                break;
            case eventTypeMetaAttenuation:
                data = @"Attenuation";
                break;
            case eventTypeMetaSample:
                data = @"SampleID";
                break;
            default:
                break;
        }
        
        data = [NSString stringWithFormat:@"%@,%@,%f",data,event.value,event.time];

        [values addObject:data];
    }
    
    NSString* path = [self saveFilePath];
    
    [_fileNames addObject:path];
    
	[values writeToFile:path atomically:YES];
    [_testResults addObjectsFromArray:values];
    
    _test = nil;

    testCounter++;
    
    if(testCounter < numberOfTests)
    {
        [_testResults addObject:@"\n"];
        _test = [[ABXTest alloc] init];
        _testIsRunning = false;
    }
    else
    {
        [_doneTarget performSelector:_doneSelector withObject:nil];
    }
    
    [self startTest];
}

- (NSString *) saveFilePath
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm:ss dd-MM-yyyy"];
    
    NSString* date = [DateFormatter stringFromDate:[NSDate date]];
    
    NSString* fileName = [NSString stringWithFormat:@"Tests/Test %@.uatctest",date];
    
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[path objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

@end