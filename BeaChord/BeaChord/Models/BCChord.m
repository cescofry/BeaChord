//
//  BCChord.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCChord.h"
#import "BCTone.h"

const float _arpeggioTime = 0.3;

@interface BCChord ()

@property(nonatomic, strong) BCTone *currentArpeggioTone;

@end

@implementation BCChord

+(instancetype)chordWithTones:(NSArray *)tones {
    BCChord *chord = [[BCChord alloc] init];
    chord.tones = tones;
    return chord;
}

+(instancetype)majorChordFromTone:(BCTone *)tone {
    // Major chords are tone + 4 sm and + 7 sm
    BCTone *thirdMajor = [tone toneByAddingSemitones:4];
    BCTone *fifth = [tone toneByAddingSemitones:7];
    
    return [self chordWithTones:@[tone, thirdMajor, fifth]];
}

+(instancetype)minorChordFromTone:(BCTone *)tone {
    // Major chords are tone + 3 sm and + 7 sm
    BCTone *thirdMinor = [tone toneByAddingSemitones:3];
    BCTone *fifth = [tone toneByAddingSemitones:7];
    
    return [self chordWithTones:@[tone, thirdMinor, fifth]];
}

- (void)play {
    [self.tones enumerateObjectsUsingBlock:^(BCTone *obj, NSUInteger idx, BOOL *stop) {
        [obj play];
    }];
}

- (void)stop {
    [self.tones enumerateObjectsUsingBlock:^(BCTone *obj, NSUInteger idx, BOOL *stop) {
        [obj stop];
    }];
}

- (void)nextArpeggio {
    if (!self.currentArpeggioTone) self.currentArpeggioTone = [self.tones firstObject];
    else {
        [self.currentArpeggioTone stop];
        NSInteger index = [self.tones indexOfObject:self.currentArpeggioTone];
        if (++index >= self.tones.count) index = 0;
        self.currentArpeggioTone = [self.tones objectAtIndex:index];
    }
    [self.currentArpeggioTone play];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_arpeggioTime * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self nextArpeggio];
    });
}

- (void)arpeggio {
    [self nextArpeggio];
}


@end
