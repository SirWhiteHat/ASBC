//
//  ViewController.h
//  UATCListeningTests
//
//  Created by Oliver Hawker on 30/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABXTest.h"
#import "TestController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface LTViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *ABPicker;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) TestController* testController;
@property (weak, nonatomic) IBOutlet UIProgressView *testProgress;

@property (weak, nonatomic) IBOutlet UILabel *DoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *SendResults;
@property (weak, nonatomic) IBOutlet UIButton *StartTest;

@property (weak, nonatomic) IBOutlet UIButton *SampleA;
@property (weak, nonatomic) IBOutlet UIButton *SampleB;

@property (nonatomic) int TestsCompleted;

@end