//
//  BCConfigurationViewController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCConfigurationViewController.h"

@interface BCConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)done:(id)sender;

@end

@implementation BCConfigurationViewController

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
