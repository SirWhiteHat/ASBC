//
//  TestController.h
//  UATC Listening Tests
//
//  Created by Oliver Hawker on 01/07/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABXTest.h"

@interface TestController : NSObject

@property (strong, nonatomic) ABXTest* test;
@property (nonatomic) SEL doneSelector;
@property (strong, nonatomic) id doneTarget;
@property (strong, nonatomic) NSMutableArray* fileNames;
@property (strong, nonatomic) NSMutableArray* testResults;
@property (nonatomic) BOOL testIsRunning;


-(void)startTest;

@end