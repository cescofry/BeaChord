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
    BCNoteB,
    BCNoteC,
    BCNoteD,
    BCNoteE,
    BCNoteF,
    BCNoteG
} BCNote;

@interface BCTone : NSObject
@property (nonatomic, assign) BCNote note;

+ (instancetype)toneFromNote:(BCNote)note;
- (void)play;
- (void)stop;
@end
