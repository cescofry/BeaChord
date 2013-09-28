//
//  BCBeaconController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCBeaconController.h"
#import "BCTone.h"
#import "BCChord.h"

static NSString * const BCProximityUUIDString = @"60FD838B-8FA4-4DD5-9C7F-8A7C7CC4D05C";
static NSString * const BCProxmityIdentifier = @"com.nscodernightlondon.beachord";

@interface BCBeaconController ()

@property (nonatomic, strong, readonly) NSUUID *proximityUUID;
@property (nonatomic, copy, readwrite) NSArray *beacons;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@property (nonatomic, strong) BCChord *currentChord;

@end

@implementation BCBeaconController

#pragma mark - Set up and tear down

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _locationManager = [CLLocationManager new];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    _locationManager.delegate = self;
    _proximityUUID = [[NSUUID alloc] initWithUUIDString:BCProximityUUIDString];

    return self;
}

#pragma mark - Public methods

- (void)startListeningForBeacons {
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID identifier:BCProxmityIdentifier];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = NO;
    [self.locationManager startMonitoringForRegion:region];
}

- (void)stopListeningForBeacons {
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID identifier:BCProxmityIdentifier];
    [self.locationManager stopMonitoringForRegion:region];
}

- (void)startBroadcastingAsBeaconType:(BCBeaconType)beaconType {
    UInt16 major = 0;
    UInt16 minor = 0;

    switch (beaconType) {
        case BCBeaconTypeChord:
            major = BCBeaconTypeChord;
            minor = arc4random_uniform(UINT16_MAX);
            break;
        case BCBeaconTypeColour:
            major = BCBeaconTypeColour;
            break;
        case BCBeaconTypeRythm:
            major = BCBeaconTypeRythm;
            break;
        default:
            NSAssert(NO, @"You missed out a type");
    }

    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID major:major minor:minor identifier:BCProxmityIdentifier];
    NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:@-59];
    [self.peripheralManager startAdvertising:peripheralData];
}

- (void)stopBroadcastingAsBeacon {
    [self.peripheralManager stopAdvertising];
}

#pragma mark - Delegate methods

#pragma mark CBPeripheralManager delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"Did Update State for peripheral: %@", peripheral);
}

#pragma mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    self.beacons = beacons; // This is rough, there should be an API for getting data.
    
    if (!self.currentChord) {
        self.currentChord = [self chordFromBeacons];
        [self.currentChord arpeggio];
        return;
    }
    
    BCChord *chord = [self chordFromBeacons];
    if (![self.currentChord isEqual:chord]) {
        [self.currentChord stop];
        self.currentChord = chord;
        [self.currentChord arpeggio];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Region: %@, error: %@", region, error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

#pragma mark - Play on beacons changes


- (BCChord *)chordFromBeacons {
    
    static UInt16 _primaryChordBeacon = 0;
    
    __block BCNote note = BCNoteA;
    __block float time = 0.3;
    __block BOOL isMajor;
    
    [self.beacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
        __block UInt16 major = [beacon.major integerValue];
        __block UInt16 minor = [beacon.minor integerValue];
        
        NSInteger distance = abs([beacon rssi]);
        // 40 -> 80 : < 50; 50 -> 70; > 70
        NSInteger proximity = 1;
        if (distance < 40) proximity = 0;
        else if (distance > 70) proximity = 2;
        
        switch (major) {
            case BCBeaconTypeChord: {
                int chordOffset = (minor == _primaryChordBeacon)? 0 : 6;
                note += (proximity * 2) + chordOffset;
            }
                break;
            case BCBeaconTypeColour:
                isMajor = (proximity < 1);
                break;
            case BCBeaconTypeRythm:
                time =  (0.3 * (proximity + 1));
                break;
            default:
                break;
        }
    }];
    
    BCTone *tone = [BCTone toneFromNote:note];
    BCChord *chord = (isMajor)? [BCChord majorChordFromTone:tone] : [BCChord minorChordFromTone:tone];
    chord.time = time;
    
    return chord;
}


@end
