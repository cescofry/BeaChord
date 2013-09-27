//
//  BCBeaconController.m
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCBeaconController.h"

@import CoreBluetooth;

static NSString * const BCProximityUUID = @"60FD838B-8FA4-4DD5-9C7F-8A7C7CC4D05C";
static NSString * const BCProxmityIdentifier = @"com.nscodernightlondon.beachord";

@interface BCBeaconController ()

@property (nonatomic, copy, readwrite) NSArray *beacons;
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
    _locationManager.delegate = self;

    return self;
}

#pragma mark - Public methods

- (void)startListeningForBeacons {

}

- (void)stopListeningForBeacons {

}

- (void)startBroadcastingAsBeaconType:(BCBeaconType)beaconType {

}

- (void)stopBroadcastingAsBeacon {

}


@end
