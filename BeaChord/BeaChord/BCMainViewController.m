//
//  BCMainViewController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCMainViewController.h"

#import "BCTone.h"
#import "BCChord.h"

@interface BCMainViewController ()

@property (strong, nonatomic) BCBeaconController *beaconController;
@property (assign, nonatomic) BOOL isBroadcasting;
@property (assign, nonatomic) BOOL isListening;
@property (nonatomic, strong) BCChord *currentChord;

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
    NSLog(@"Selected index %ld", (long)segment);
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

#pragma mark - BCBeaconControllerDelegate

- (void)beaconController:(BCBeaconController *)beaconController didChangeBeacons:(NSArray *)beacons {
    if ([beacons count] == 0) {
        [self.currentChord stop];
    }

    // Play Chord based on beacons
    if (!self.currentChord) {
        self.currentChord = [self chordFromBeacons:beacons];
        [self.currentChord arpeggio];
        return;
    }

    BCChord *chord = [self chordFromBeacons:beacons];
    if (![self.currentChord isEqual:chord]) {
        [self.currentChord stop];

        self.currentChord = chord;
        [self.currentChord arpeggio];
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

- (BCChord *)chordFromBeacons:(NSArray *)beacons {
    if (!beacons || [beacons count] == 0) {
        return nil;
    }

    static UInt16 _primaryChordBeacon = 0;

    __block BCNote note = BCNoteA;
    __block float time = 0.3;
    __block BOOL isMajor;

    [beacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
        __block UInt16 major = [beacon.major integerValue];
        __block UInt16 minor = [beacon.minor integerValue];

        NSInteger distance = labs([beacon rssi]);
        // 40 -> 80 : < 50; 50 -> 70; > 70
        NSInteger proximity = 1;
        if (distance < 40) proximity = 0;
        else if (distance > 60) proximity = 2;

        switch (major) {
            case BCBeaconTypeChord: {
                if (_primaryChordBeacon == 0) _primaryChordBeacon = minor;
                int chordOffset = (minor == _primaryChordBeacon)? 0 : 6;
                note += (proximity * 2) + chordOffset;
            }
                break;
            case BCBeaconTypeColour:
                isMajor = (proximity < 1);
                break;
            case BCBeaconTypeRythm:
                time =  (0.2 * (proximity + 1));
                break;
            default:
                break;
        }
    }];

    BCTone *tone = [BCTone toneFromNote:note];
    BCChord *chord = (isMajor)? [BCChord majorChordFromTone:tone] : [BCChord minorChordFromTone:tone];

    [chord.tones enumerateObjectsUsingBlock:^(BCTone *obj, NSUInteger idx, BOOL *stop) {
        obj.duration = time;
    }];

    return chord;
}


@end
