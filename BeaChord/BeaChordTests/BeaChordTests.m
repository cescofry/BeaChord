//
//  BeaChordTests.m
//  BeaChordTests
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCTone.h"

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

- (void)testNodeAddingSemitones {
    BCTone *aTone = [BCTone toneFromNote:BCNoteA];
    
    BCTone *aSharpTone = [aTone toneByAddingSemitones:1];
    
    NSAssert((aSharpTone.note == BCNoteA), @"This should be a a# is actually %d", aSharpTone.note);

    
    BCTone *fTone = [BCTone toneFromNote:BCNoteF];
    
    aSharpTone = [fTone toneByAddingSemitones:5];
    
    NSAssert((aSharpTone.note == BCNoteA), @"This should be a a# is actually %d", aSharpTone.note);
    
}

@end
