//
//  BeaChordTests.m
//  BeaChordTests
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCToneGenerator.h"

@interface BeaChordTests : XCTestCase

@end

@implementation BeaChordTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    BCToneGenerator *toneG = [[BCToneGenerator alloc] init];
    BCTone *la = [BCTone toneFromNote:BCNoteA];
    [toneG playTone:la];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [toneG stop];
    });
}

@end
