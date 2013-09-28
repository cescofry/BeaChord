//
//  BCChord.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCChord.h"
#import "BCTone.h"

const float _arpeggioTime =  0.3;

@interface BCChord ()

@property(nonatomic, strong) BCTone *currentArpeggioTone;
@property (nonatomic, strong) NSEnumerator *arpeggioEnumerator;
@property(nonatomic, assign) BOOL isAscending;

@end

@implementation BCChord

+(instancetype)chordWithTones:(NSArray *)tones {
    BCChord *chord = [[BCChord alloc] init];
    chord.tones = tones;
    chord.time = _arpeggioTime;
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

- (BOOL)isEqual:(BCChord *)object {
    BCTone *thisTone = [self.tones firstObject];
    BCTone *objTone = [object.tones firstObject];
    
    BOOL isFirstSame = (thisTone.note == objTone.note);
    
    thisTone = [self.tones objectAtIndex:1];
    objTone = [object.tones objectAtIndex:1];
    
    BOOL isSecondSame = (thisTone.note == objTone.note);
    
    return (isFirstSame && isSecondSame && self.time == object.time && self);
}

- (void)play {
    [self.tones enumerateObjectsUsingBlock:^(BCTone *obj, NSUInteger idx, BOOL *stop) {
        [obj play];
    }];
    _isPlaying = YES;
}

- (void)stop {
    _isPlaying = NO;
    _arpeggioEnumerator = nil;
    [self.tones enumerateObjectsUsingBlock:^(BCTone *obj, NSUInteger idx, BOOL *stop) {
        [obj stop];
    }];
}

- (NSEnumerator *)arpeggioEnumerator {
    if (!_arpeggioEnumerator) {
        _arpeggioEnumerator = [self.tones objectEnumerator];
        self.isAscending = YES;
    }
    return _arpeggioEnumerator;
}

- (void)nextArpeggio {
    if (self.currentArpeggioTone) [self.currentArpeggioTone stop];
    
    self.currentArpeggioTone = [self.arpeggioEnumerator nextObject];
    if (!self.currentArpeggioTone) {
        self.isAscending = !self.isAscending;
        self.arpeggioEnumerator = (self.isAscending)? [self.tones objectEnumerator] : [self.tones reverseObjectEnumerator];
        [self.arpeggioEnumerator nextObject]; // discard first note as already playing
        self.currentArpeggioTone = [self.arpeggioEnumerator nextObject];
    }
    
    [self.currentArpeggioTone play];
    NSLog(@"tone: %d", self.currentArpeggioTone.note);

    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (!self.isPlaying) return;
        [self nextArpeggio];
    });
}

- (void)arpeggio {
    _isPlaying = YES;
    self.isAscending = YES;
    [self nextArpeggio];
}


@end
