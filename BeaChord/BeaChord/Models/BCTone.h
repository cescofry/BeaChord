//
//  BCTone.h
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BCNote) {
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
};

static NSInteger const BCNoteMute = (BCNoteGSharp + 1);

@interface BCTone : NSObject
@property(nonatomic, assign) BCNote note;
@property(nonatomic, assign) NSInteger octave;
@property(nonatomic, assign) float duration; // how long it does play for
@property(nonatomic, assign) float period;   // lenght of the note (>= duration)

+ (instancetype)toneFromNote:(BCNote)note;
+ (instancetype)muteToneOfDuration:(float)duration;
- (instancetype)toneByAddingSemitones:(NSInteger)semitones;
- (void)playCompleted:(voidBlock)completed;
- (void)stop;
@end
