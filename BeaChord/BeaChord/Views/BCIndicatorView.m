//
//  BCIndicatorView.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCIndicatorView.h"

@implementation BCIndicatorView

- (void)drawRect:(CGRect)rect {
    float padding = 1;
    CGRect frame = CGRectMake(0, 0, ((self.bounds.size.width / self.max) - padding), self.bounds.size.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < self.max; i++) {
        float component = (i / self.max);
        UIColor *color = [UIColor colorWithRed:component green:(1.0 - component) blue:0 alpha:(i <= self.value)? 1.0 : 0.2];
        [color setFill];
        CGContextFillRect(ctx, frame);
        
        frame.origin.x += (padding + frame.size.width);
    }
}

@end
