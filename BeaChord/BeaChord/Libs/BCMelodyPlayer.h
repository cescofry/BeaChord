//
//  BCMelodyPlayer.h
//  BeaChord
//
//  Created by Francesco Frison on 28/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BCMelodyType) {
    BCMelodyTypeMain,
    BCMelodyTypeBase,
    BCMelodyTypeHigh
};

@interface BCMelodyPlayer : NSObject

+ (instancetype)sharedInstance;
- (void)synchMelodyAnPlay:(BCMelodyType)melodyType;
- (void)stop;

@end
