//
//  BCTone.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCTone.h"
#import <AudioToolbox/AudioToolbox.h>

@interface BCTone ()

@property (nonatomic, assign, readonly) AudioComponentInstance toneUnit;

@property (nonatomic, assign) double theta;
@property (nonatomic, assign, readonly) double frequency;
@property (nonatomic, assign, readonly) double sampleRate;

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
	BCTone *tone = (__bridge BCTone *)inRefCon;
	double theta = [tone theta];
	double theta_increment = 2.0 * M_PI * [tone frequency] / [tone sampleRate];
    
    NSLog(@"inc: %f", theta_increment);
    
	// This is a mono tone generator so we only need the first buffer
    
#warning //TODO: work with channel for stereo.
    
    
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
	[tone setTheta:theta];
    
	return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	BCTone *tone = (__bridge BCTone *)inClientData;
	[tone stop];
}


@implementation BCTone

@synthesize frequency = _frequency;
@synthesize toneUnit = _toneUnit;

+ (instancetype)toneFromNote:(BCNote)note {
    BCTone *tone = [[BCTone alloc] init];
    tone.note = note;
    
    return tone;
}

- (id)init
{
    self = [super init];
    if (self) {
        _sampleRate = 44100.0;
    }
    return self;
}

- (double)frequency {
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

- (void)play {
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
    _toneUnit = nil;
}

@end
