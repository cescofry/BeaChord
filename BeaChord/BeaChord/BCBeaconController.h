//
//  BCBeaconController.h
//  BeaChord
//
//  Created by Abizer Nasir on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import CoreBluetooth;

typedef NS_ENUM(UInt16, BCBeaconType) {
    BCBeaconTypeChord,
    BCBeaconTypeColour,
    BCBeaconTypeRythm
};

@interface BCBeaconController : NSObject <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, copy, readonly) NSArray *beacons;

- (void)startListeningForBeacons;
- (void)stopListeningForBeacons;
- (void)startBroadcastingAsBeaconType:(BCBeaconType)beaconType;
- (void)stopBroadcastingAsBeacon;

@end
