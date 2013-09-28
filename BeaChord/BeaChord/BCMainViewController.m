//
//  BCMainViewController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCMainViewController.h"

#import "BCBeaconController.h"

@interface BCMainViewController ()

@property (strong, nonatomic) BCBeaconController *beaconController;
@property (assign, nonatomic) BOOL isBroadcasting;
@property (assign, nonatomic) BOOL isListening;

@property (nonatomic, strong) IBOutlet UISwitch *modeSwitch;
@property (nonatomic, strong) IBOutlet UILabel *udidLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UIButton *startButton;

- (IBAction)switchModeAction:(id)sender;
- (IBAction)changedSegment:(id)sender;
- (IBAction)startButtonAction:(id)sender;

@end

@implementation BCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beaconController = [BCBeaconController new];
    [self.segmentedControl setAlpha:0.0]; // Initially hidden as player is the default
    
}


- (IBAction)switchModeAction:(id)sender {
    [self.segmentedControl setAlpha:([self isPlayer])? 0.0 : 1.0];
}

- (IBAction)changedSegment:(id)sender {
    NSInteger segment = [(UISegmentedControl *)sender selectedSegmentIndex];
    NSLog(@"Selected index %d", segment);
}

- (IBAction)startButtonAction:(UIButton *)sender {
    if ([self isActive]) {
        [self deActivate];

        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        self.startButton.tintColor = [UIColor blueColor];
        
    } else {
        if ([self isPlayer]) {
            [self.beaconController startListeningForBeacons];
            self.isListening = YES;
            self.isBroadcasting = NO;

        } else {
            [self.beaconController startBroadcastingAsBeaconType:[self.segmentedControl selectedSegmentIndex]];
            self.isBroadcasting = YES;
            self.isListening = NO;
        }

        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.startButton.tintColor = [UIColor redColor];
    }
}

#pragma mark - Private methods

- (BOOL)isActive {
    return (self.isBroadcasting || self.isListening);
}

- (void)deActivate {
    if (self.isBroadcasting) {
        [self.beaconController stopBroadcastingAsBeacon];
        self.isBroadcasting = !self.isBroadcasting;
    } else if (self.isListening) {
        [self.beaconController stopListeningForBeacons];
        self.isListening = !self.isListening;
    } else {
        NSLog(@"Why did you try and deactivate an non-active service");
    }
}

- (BOOL)isPlayer {
    return [self.modeSwitch isOn];
}

@end
