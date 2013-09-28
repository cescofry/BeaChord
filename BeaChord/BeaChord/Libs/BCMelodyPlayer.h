//
//  BCMelodyPlayer.h
//  BeaChord
//
//  Created by Francesco Frison on 28/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCChord.h"
typedef NS_ENUM(NSUInteger, BCMelodyType) {
    BCMelodyTypeBase,
    BCMelodyTypeMain,
    BCMelodyTypeHigh
};

@interface BCMelodyPlayer : NSObject

+ (instancetype)sharedInstance;
- (BCChord *)melodyOfType:(BCMelodyType)type;
- (void)synchMelodyAnPlay:(BCChord *)melody;
- (void)stop;

@end
