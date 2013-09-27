//
//  BCToneGenerator.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCToneGenerator.h"
#import "BCTone.h"
#import <AudioToolbox/AudioToolbox.h>


@interface BCToneGenerator ()

@property (nonatomic, assign) AudioComponentInstance toneUnit;

@property (nonatomic, assign) double theta;
@property (nonatomic, assign) double frequency;
@property (nonatomic, assign) double sampleRate;

@end

#pragma mark - Tone Renderer

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
	// Fixed amplitude is good enough for our purposes
	const double amplitude = 0.25;
    
	// Get the tone parameters out of the view controller
	BCToneGenerator *generator = (__bridge BCToneGenerator *)inRefCon;
	double theta = [generator theta];// generator->theta;
	double theta_increment = 2.0 * M_PI * [generator frequency] / [generator sampleRate];
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
		buffer[frame] = sin(theta) * amplitude;
		
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	[generator setTheta:theta];
    
	return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	BCToneGenerator *generator = (__bridge BCToneGenerator *)inClientData;
	[generator stop];
}


#pragma mark - BCToneGenerator

@implementation BCToneGenerator

- (id)init
{
    self = [super init];
    if (self) {
        self.sampleRate = 44100.0;
    }
    return self;
}



- (void)playTone:(BCTone *)tone {
    
    self.frequency = tone.frequency;
    
    // Stop changing parameters on the unit
    OSErr err = AudioUnitInitialize(self.toneUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %d", err);
    
    // Start playback
    err = AudioOutputUnitStart(self.toneUnit);
    NSAssert1(err == noErr, @"Error starting unit: %d", err);
}

- (void)stop {
    AudioOutputUnitStop(self.toneUnit);
    AudioUnitUninitialize(self.toneUnit);
    AudioComponentInstanceDispose(self.toneUnit);
    self.toneUnit = nil;
}


- (AudioComponentInstance)toneUnit {
    if (!_toneUnit) {
        
        // Playback Output
        AudioComponentDescription defaultOutputDescription;
        defaultOutputDescription.componentType = kAudioUnitType_Output;
        defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
        defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
        defaultOutputDescription.componentFlags = 0;
        defaultOutputDescription.componentFlagsMask = 0;
        
        AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
        NSAssert(defaultOutput, @"Can't find default output");
        
        // create unit
        OSErr err = AudioComponentInstanceNew(defaultOutput, &_toneUnit);
        NSAssert1(_toneUnit, @"Error creating unit: %d", err);
        
        // Set our tone rendering function on the unit
        AURenderCallbackStruct input;
        input.inputProc = RenderTone;
        input.inputProcRefCon = (__bridge void *)(self);
        err = AudioUnitSetProperty(_toneUnit,
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Input,
                                   0,
                                   &input,
                                   sizeof(input));
        NSAssert1(err == noErr, @"Error setting callback: %d", err);
    }
    
    return _toneUnit;
}


@end
