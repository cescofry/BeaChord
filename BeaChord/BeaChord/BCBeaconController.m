//
//  BCBeaconController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCBeaconController.h"

static NSString * const BCProximityUUIDString = @"60FD838B-8FA4-4DD5-9C7F-8A7C7CC4D05C";
static NSString * const BCProxmityIdentifier = @"com.nscodernightlondon.beachord";

@interface BCBeaconController ()

@property (nonatomic, strong, readonly) NSUUID *proximityUUID;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

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
    CLBeaconRegion *region = [self listeningRegion];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = NO;
    [self.locationManager startMonitoringForRegion:region];
}

- (void)stopListeningForBeacons {
    CLBeaconRegion *region = [self listeningRegion];
    [self.locationManager stopMonitoringForRegion:region];

    if ([self.delegate respondsToSelector:@selector(beaconController:didChangeBeacons:)]) {
        [self.delegate beaconController:self didChangeBeacons:@[]];
    }
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
    // Required, but not used
}

#pragma mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if ([self.delegate respondsToSelector:@selector(beaconController:didChangeBeacons:)]) {
        [self.delegate beaconController:self didChangeBeacons:beacons];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Region: %@, error: %@", region, error);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    CLBeaconRegion *listeningRegion = [self listeningRegion];

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:listeningRegion.proximityUUID]) {
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    CLBeaconRegion *listeningRegion = [self listeningRegion];

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:listeningRegion.proximityUUID]) {
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }

    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    CLBeaconRegion *listeningRegion = [self listeningRegion];

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:listeningRegion.proximityUUID]) {
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];

            // Update with an empty beacons array
            if ([self.delegate respondsToSelector:@selector(beaconController:didChangeBeacons:)]) {
                [self.delegate beaconController:self didChangeBeacons:@[]];
            }
        }
    }

}

#pragma mark - Private methods

- (CLBeaconRegion *)listeningRegion {
    static CLBeaconRegion *region = nil;

    if (!region) {
        region = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID identifier:BCProxmityIdentifier];
    }

    return region;
}

@end
