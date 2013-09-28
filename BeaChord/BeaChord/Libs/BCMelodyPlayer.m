//
//  BCMelodyPlayer.m
//  BeaChord
//
//  Created by Francesco Frison on 28/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCMelodyPlayer.h"
#import "BCChord.h"

const int _periodLength = 4;

@interface BCMelodyPlayer ()

@property (nonatomic, strong) BCChord *currentMelody;

@end

@implementation BCMelodyPlayer

- (BCChord *)melodyOfType:(BCMelodyType)type {
    
    BCChord *melody;
    
    switch (type) {
        case BCMelodyTypeMain:
        {
            BCTone *cTone = [BCTone toneFromNote:BCNoteC];
            [cTone setDuration:1];
            [cTone setPeriod:1];
            
            BCTone *eTone = [BCTone toneFromNote:BCNoteE];
            [eTone setDuration:0.5];
            [eTone setPeriod:0.5];
            
            BCTone *gTone = [BCTone toneFromNote:BCNoteG];
            [gTone setDuration:0.5];
            [gTone setPeriod:0.5];
            
            BCTone *fTone = [BCTone toneFromNote:BCNoteF];
            [fTone setDuration:1];
            [fTone setPeriod:1];
            
            BCTone *aTone = [BCTone toneFromNote:BCNoteA];
            aTone.octave++;
            [aTone setDuration:0.5];
            [aTone setPeriod:0.5];
            
            BCTone *cToneUp = [BCTone toneFromNote:BCNoteC];
            cToneUp.octave++;
            [cToneUp setDuration:0.5];
            [cToneUp setPeriod:0.5];
            
            melody = [BCChord chordWithTones:@[cTone, eTone, gTone, fTone, aTone, cToneUp]];
            
            
        }
            break;
        case BCMelodyTypeHigh:
        {
            
            BCTone *muteTone = [BCTone muteToneOfDuration:0.5];
            
            BCTone *cTone = [BCTone toneFromNote:BCNoteC];
            cTone.octave--;
            [cTone setDuration:0.125];
            [cTone setPeriod:0.125];
            
            melody = [BCChord chordWithTones:@[muteTone, cTone, cTone]];
        }
            break;
        case BCMelodyTypeBase:
        {
            
            BCTone *cTone = [BCTone toneFromNote:BCNoteC];
            cTone.octave--;
            [cTone setDuration:2];
            [cTone setPeriod:2];
            
            BCTone *fTone = [BCTone toneFromNote:BCNoteF];
            fTone.octave--;
            [fTone setDuration:2];
            [fTone setPeriod:2];
            
            melody = [BCChord chordWithTones:@[cTone, fTone]];
        }
            break;
        default:
            break;
    }
    
    return melody;
}

- (void)synchMelodyAnPlay:(BCMelodyType)melodyType {
    
    CFAbsoluteTime currentTime = (NSInteger)CFAbsoluteTimeGetCurrent();
    NSInteger nextRound = (NSInteger)currentTime % _periodLength;
    nextRound += (currentTime - nextRound);
    
    self.currentMelody = [self melodyOfType:melodyType];
    
    double delayInSeconds = nextRound;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.currentMelody playMelody];
    });
    
}

- (void)stop {
    [self.currentMelody stop];
}

#pragma mark --
#pragma mark Singleton

static BCMelodyPlayer *_sharedInstance = nil;

/**
 * Share entity for the singleton model
 */

+ (instancetype)sharedInstance {
    @synchronized(self)
    {
        if (_sharedInstance == nil) {
			_sharedInstance = [[BCMelodyPlayer alloc] init];
		}
    }
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end