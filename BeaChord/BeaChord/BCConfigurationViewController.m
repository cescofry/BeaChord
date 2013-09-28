//
//  BCConfigurationViewController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCConfigurationViewController.h"
#import "BCMainViewController.h" // Please forgive me!

@interface BCConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UISwitch *melodySwitch;

- (IBAction)done:(id)sender;

@end

@implementation BCConfigurationViewController

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)modeChange:(UISwitch *)sender {
    BCMainViewController *mainVC = (BCMainViewController *)self.presentingViewController;
    mainVC.isInMelodyMode = sender.isOn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BCMainViewController *mainVC = (BCMainViewController *)self.presentingViewController;

    self.melodySwitch.on = mainVC.isInMelodyMode;
}



@end
