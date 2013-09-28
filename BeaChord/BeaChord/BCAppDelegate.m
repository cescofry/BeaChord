//
//  BCAppDelegate.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCAppDelegate.h"
#import "BCTone.h"
#import "BCChord.h"

@implementation BCAppDelegate

- (void)playToneDirectlyFromTheAppDelegate {

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
    
    BCChord *chord = [BCChord chordWithTones:@[cTone, eTone, gTone, fTone, aTone, cToneUp]];
    
    [chord arpeggio];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self playToneDirectlyFromTheAppDelegate];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
