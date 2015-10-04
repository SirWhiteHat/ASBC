// Copyright (c) 2012 Alex Wiltschko
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) RingBuffer *ringBuffer;

@end

@implementation ViewController

- (void)dealloc
{
    delete self.ringBuffer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.uatcDemo = [[UATCDemo alloc] init];
    self.uatcDemo.bypass = true;
    [_uatcDemo beginDemo];
}

- (IBAction)deltaPhon:(UISlider*)sender {
    _uatcDemo.deltaPhon = (1-sender.value)*-40;
}

- (IBAction)setBypass:(UISegmentedControl*)sender {
    _uatcDemo.bypass = !sender.selectedSegmentIndex;
}

- (IBAction)setBlindness:(UISwitch*)sender {
    if (sender.on)
    {
        [_abSelect setTitle:@"A" forSegmentAtIndex:0];
        [_abSelect setTitle:@"B" forSegmentAtIndex:1];
    }
    else
    {
        [_abSelect setTitle:@"Classic" forSegmentAtIndex:0];
        [_abSelect setTitle:@"Corrected" forSegmentAtIndex:1];
    }
}

- (IBAction)restart:(UIButton*)sender {
    [_uatcDemo returnToZero];
}

- (IBAction)setSong:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [_uatcDemo setSongName:@"Audio1"];
            break;
        case 1:
            [_uatcDemo setSongName:@"Audio2"];
            break;
        case 2:
            [_uatcDemo setSongName:@"Audio3"];
            break;
        case 3:
            [_uatcDemo setSongName:@"Audio4"];
            break;
        case 4:
            [_uatcDemo setSongName:@"Audio5"];
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
