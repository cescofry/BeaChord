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

@class BCBeaconController;

@protocol BCBeaconControllerDelegate <NSObject>

@required
- (void)beaconController:(BCBeaconController *)beaconController didChangeBeacons:(NSArray *)beacons;

@end

@interface BCBeaconController : NSObject <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (weak, nonatomic) id<BCBeaconControllerDelegate> delegate;

- (void)startListeningForBeacons;
- (void)stopListeningForBeacons;
- (void)startBroadcastingAsBeaconType:(BCBeaconType)beaconType;
- (void)stopBroadcastingAsBeacon;

@end
