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


#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.uatcDemo = [[UATCDemo alloc] init];
    [self.uatcDemo beginDemo];
}

- (IBAction)phonChanged:(NSSlider*)sender {
    _uatcDemo.deltaPhon = (1-sender.floatValue/100)*-40;
}

- (IBAction)restart:(id)sender {
    [_uatcDemo returnToZero];
}

- (IBAction)setBypass:(NSSegmentedControl*)sender {
    _uatcDemo.bypass = !sender.selectedSegment;
}

- (IBAction)setBlindness:(NSSegmentedControl*)sender {
    if (!sender.selectedSegment)
    {
        [_abSelect setLabel:@"A" forSegment:0];
        [_abSelect setLabel:@"B" forSegment:1];
    }
    else
    {
        [_abSelect setLabel:@"Classic" forSegment:0];
        [_abSelect setLabel:@"Corrected" forSegment:1];
    }
}

- (IBAction)setSong:(NSSegmentedControl*)sender {
    switch (sender.selectedSegment) {
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

@end
