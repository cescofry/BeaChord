//
//  BCToneGenerator.h
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCTone.h"


@interface BCToneGenerator : NSObject

- (void)playTone:(BCTone *)tone;
- (void)stop;

@end
