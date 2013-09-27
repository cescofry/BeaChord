//
//  BCTone.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCTone.h"

@implementation BCTone

@synthesize frequency = _frequency;

+ (instancetype)toneFromNote:(BCNote)note {
    BCTone *tone = [[BCTone alloc] init];
    tone.note = note;
    
    return tone;
}

- (float)frequency {
    if (_frequency < 1.0) {
        switch (self.note) {
            default:
            case BCNoteA:
                _frequency = 440.00;
                break;
            case BCNoteB:
                _frequency = 493.88;
                break;
            case BCNoteC:
                _frequency = 523.25;
                break;
            case BCNoteD:
                _frequency = 587.33;
                break;
            case BCNoteE:
                _frequency = 659.26;
                break;
            case BCNoteF:
                _frequency = 698.46;
                break;
            case BCNoteG:
                _frequency = 783.99;
                break;
        }
    }
    return _frequency;
}

@end
