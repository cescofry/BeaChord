//
//  BCTone.h
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BCNoteA,
    BCNoteASharp,
    BCNoteB,
    BCNoteC,
    BCNoteCSharp,
    BCNoteD,
    BCNoteDSharp,
    BCNoteE,
    BCNoteF,
    BCNoteFSharp,
    BCNoteG,
    BCNoteGSharp
} BCNote;

@interface BCTone : NSObject
@property(nonatomic, assign) BCNote note;
@property(nonatomic, assign) NSInteger octave;
@property(nonatomic, assign) float duration; // how long it does play for
@property(nonatomic, assign) float period;   // lenght of the note (>= duration)

+ (instancetype)toneFromNote:(BCNote)note;
- (instancetype)toneByAddingSemitones:(NSInteger)semitones;
- (void)playCompleted:(voidBlock)completed;
- (void)stop;
@end
