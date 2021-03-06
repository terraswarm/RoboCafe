//
//  ViewControllerSettings.m
//  RoboCafe
//
//  Created by Patrick Lazik on 8/11/15.
//  Copyright (c) 2015 Carnegie Mellon University. All rights reserved.
//

#import "ViewControllerSettings.h"
#import "AppDelegate.h"
#import <ALPS/ALPS.h>

@interface ViewControllerSettings ()

@end

@implementation ViewControllerSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setVCSettings:self];
    alps = [appDelegate ALPS];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    _alpsWSEntry.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"alps_ws_address"];
    _alpsWSEntry.delegate = self;
    
    UITapGestureRecognizer* alpsWSClearTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alpsWSClearTapped:)];
    alpsWSClearTapRecognizer.numberOfTapsRequired = 1;
    alpsWSClearTapRecognizer.numberOfTouchesRequired = 1;
    [_alpsWSClear addGestureRecognizer:alpsWSClearTapRecognizer];
    [_alpsWSClear setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* thresholdDivisorClearRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thresholdDivisorClearTapped:)];
    thresholdDivisorClearRecognizer.numberOfTapsRequired = 1;
    thresholdDivisorClearRecognizer.numberOfTouchesRequired = 1;
    [_thresholdDivisorClear addGestureRecognizer:thresholdDivisorClearRecognizer];
    [_thresholdDivisorClear setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* thresholdMultiplierClearRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thresholdMultiplierClearTapped:)];
    thresholdMultiplierClearRecognizer.numberOfTapsRequired = 1;
    thresholdMultiplierClearRecognizer.numberOfTouchesRequired = 1;
    [_thresholdMultiplierClear addGestureRecognizer:thresholdMultiplierClearRecognizer];
    [_thresholdMultiplierClear setUserInteractionEnabled:YES];
    
    float thresholdDivisorValue = [defaults floatForKey:@"alps_thresholdDivisor"];
    [alps setThresholdDivisor:thresholdDivisorValue];
    _thresholdDivisorSlider.minimumValue = 1;
    _thresholdDivisorSlider.maximumValue = 10;
    _thresholdDivisorSlider.continuous = NO;
    _thresholdDivisorSlider.value = thresholdDivisorValue;
    _thresholdDivisorLabel.text = [[NSNumber numberWithFloat:thresholdDivisorValue] stringValue];
    
    float thresholdMultiplierValue = [defaults floatForKey:@"alps_thresholdMultiplier"];
    [alps setThresholdMultiplier:thresholdMultiplierValue];
    _thresholdMultiplierSlider.minimumValue = 1;
    _thresholdMultiplierSlider.maximumValue = 100;
    _thresholdMultiplierSlider.continuous = NO;
    _thresholdMultiplierSlider.value = thresholdMultiplierValue;
    _thresholdMultiplierLabel.text = [[NSNumber numberWithFloat:thresholdMultiplierValue] stringValue];
    
    if (appDelegate.alpsWSState == WebsocketStateConnected){
        [_solverConnectionStatusLabel setText:@"Connected"];
        [_solverConnectionStatusLabel setTextColor:[UIColor greenColor]];
    } else if (appDelegate.alpsWSState == WebsocketStateConnecting) {
        [_solverConnectionStatusLabel setText:@"Connecting..."];
        [_solverConnectionStatusLabel setTextColor:[UIColor orangeColor]];
    } else {
        [_solverConnectionStatusLabel setText:@"Disconnected"];
        [_solverConnectionStatusLabel setTextColor:[UIColor redColor]];
    }
    
    if([appDelegate position] != nil){
        float x = [[[appDelegate position] objectForKey:@"x"] floatValue];
        float y = [[[appDelegate position] objectForKey:@"y"] floatValue];
        [_positionField setText:[NSString stringWithFormat:@"X: %.2f, Y: %.2f", x, y]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)alpsWSClearTapped:(UIGestureRecognizer*)gestureRecognizer {
    self.alpsWSEntry.text = DEFAULT_ALPS_WEBSOCKET;
    [self alpsWSEditingEnd:self];
}

- (void)thresholdDivisorClearTapped:(UIGestureRecognizer*)gestureRecognizer {
    self.thresholdDivisorSlider.value = DEFAULT_ALPS_THRESHOLD_DIVISOR;
    [self thresholdDivisorAction:self];
}

- (void)thresholdMultiplierClearTapped:(UIGestureRecognizer*)gestureRecognizer {
    self.thresholdMultiplierSlider.value = DEFAULT_ALPS_THRESHOLD_MULTIPLIER;
    [self thresholdMultiplierAction:self];
}

- (IBAction)thresholdDivisorAction:(id)sender {
    float val = self.thresholdDivisorSlider.value;
    val = roundf(val*2) / 2.0;
    _thresholdDivisorSlider.value = val;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:val] forKey:@"alps_thresholdDivisor"];
    [alps setThresholdDivisor:_thresholdDivisorSlider.value];
    _thresholdDivisorLabel.text = [[NSNumber numberWithFloat:_thresholdDivisorSlider.value] stringValue];
}

- (IBAction)thresholdMultiplierAction:(id)sender {
    float val = self.thresholdMultiplierSlider.value;
    val = roundf(val);
    _thresholdMultiplierSlider.value = val;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:val] forKey:@"alps_thresholdMultiplier"];
    [alps setThresholdMultiplier:_thresholdMultiplierSlider.value];
    _thresholdMultiplierLabel.text = [[NSNumber numberWithFloat:_thresholdMultiplierSlider.value] stringValue];
}


- (IBAction)alpsWSEditingBegin:(id)sender {
    [appDelegate.alpsWSReconnectTimer invalidate];
}

- (IBAction)alpsWSEditingEnd:(id)sender {
    if (appDelegate.alpsWSState != WebsocketStateDisconnected) {
        [appDelegate.alpsWS close];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.alpsWSEntry.text forKey:@"alps_ws_address"];
    appDelegate.alpsWSAddress = self.alpsWSEntry.text;
    [appDelegate alpsWSConnect];
}

- (IBAction)alpsWSReconnect:(id)sender {
    if (appDelegate.alpsWSState != WebsocketStateDisconnected) {
        [appDelegate.alpsWS close];
    }
    [appDelegate alpsWSConnect];
}


@end
