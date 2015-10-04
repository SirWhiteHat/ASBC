//
//  ViewController.m
//  UATCListeningTests
//
//  Created by Oliver Hawker on 30/06/2014.
//  Copyright (c) 2014 Oliver Hawker. All rights reserved.
//

#import "LTViewController.h"
#define NUMBEROFTESTS 15

@interface LTViewController ()

@end

@implementation LTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _TestsCompleted = 0;
    
    [self resetInterface];
    
    _testController = [[TestController alloc] init];
    
    _testController.doneSelector = @selector(doneTesting);
    _testController.doneTarget = self;
    
    [_testController startTest];
}

- (void)resetInterface
{
    
    [_ABPicker setSelectedSegmentIndex:UISegmentedControlNoSegment]; // Reset choice control
    
    _answerLabel.textAlignment = NSTextAlignmentCenter;
    _answerLabel.text = @"(neither)";
    _submitButton.hidden = true;
    
    _testProgress.progress = (float)_TestsCompleted / (float)NUMBEROFTESTS;
}

- (IBAction)StartTest:(id)sender {
    [_testController startTest];
}

- (IBAction)answerChanged:(UISegmentedControl*)sender {
    if (_testController.testIsRunning)
    {
        _submitButton.hidden = false;
        bool answer = sender.selectedSegmentIndex;
        
        if (answer)
        {
            _answerLabel.text = @"Answer B";
            [_testController.test choiceChanged:choiceSelectionB];
        }
        else
        {
            _answerLabel.text = @"Answer A";
            [_testController.test choiceChanged:choiceSelectionA];
        }
    }
    else
    {
        sender.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
}

- (IBAction)submitPressed:(id)sender {
    [_testController.test submit];
    _TestsCompleted++;
    [self resetInterface];
}

- (IBAction)sendPressed:(id)sender {
    
    NSString* results = @"";
    
    for (NSString* line in _testController.testResults) {
        results = [NSString stringWithFormat:@"%@\n%@",results,line];
    }
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setSubject:@"UATC Results"];
        [mailCont setMessageBody:results isHTML:NO];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"ohawker@me.com"]];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (IBAction)StartSampleA:(id)sender {
    [_testController.test PlayWithChoice:choiceSelectionA];
}

- (IBAction)StartSampleB:(id)sender {
    [_testController.test PlayWithChoice:choiceSelectionB];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //handle any error
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneTesting
{
    self.DoneLabel.hidden = false;
    self.SendResults.hidden = false;
    self.submitButton.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
