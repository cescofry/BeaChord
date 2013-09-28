//
//  BCChord.h
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCTone.h"

@interface BCChord : NSObject

@property(nonatomic, strong) NSArray *tones;
@property(nonatomic, assign, readonly) BOOL isPlaying;

+(instancetype)chordWithTones:(NSArray *)tones;
+(instancetype)majorChordFromTone:(BCTone *)tone;
+(instancetype)minorChordFromTone:(BCTone *)tone;

- (void)play;
- (void)stop;
- (void)arpeggio;
- (void)playMelody;

@end
