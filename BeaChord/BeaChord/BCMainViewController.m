//
//  BCMainViewController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCMainViewController.h"

@interface BCMainViewController ()

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
	// Do any additional setup after loading the view.
    
    
    
}


- (IBAction)switchModeAction:(id)sender {
    BOOL isBroadcast = [(UISwitch *)sender isOn];
    [self.segmentedControl setAlpha:(isBroadcast)? 1.0 : 0.0];
}

- (IBAction)changedSegment:(id)sender {
    NSInteger segment = [(UISegmentedControl *)sender selectedSegmentIndex];
    NSLog(@"Selected index %d", segment);
}

- (IBAction)startButtonAction:(id)sender {
    NSLog(@"start");
}

@end
