//
//  BCMainViewController.h
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCBeaconController.h"

@interface BCMainViewController : UIViewController <BCBeaconControllerDelegate>

@property (nonatomic, assign) BOOL isInMelodyMode;

@end
