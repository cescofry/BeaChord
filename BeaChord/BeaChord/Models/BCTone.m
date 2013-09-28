//
//  BCTone.m
//  BeaChord
//
//  Created by Francesco Frison on 27/09/2013.
//  Copyright (c) 2013 NSCoderNight. All rights reserved.
//

#import "BCTone.h"
#import <AudioToolbox/AudioToolbox.h>

const float sqrSemitone = 1.059463094359;
const float a4Hrz = 440.0;
const float defaultTime =  0.3;

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
    
	// This is a mono tone generator so we only need the first buffer
    
	Float32 *bufferL = (Float32 *)ioData->mBuffers[0].mData;
    //Float32 *bufferR = (Float32 *)ioData->mBuffers[1].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
		bufferL[frame] = sin(theta) * amplitude;
        //bufferR[frame] = sin(theta) * amplitude;
		
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
    tone.octave = 4;
    tone.period = defaultTime;
    tone.duration = defaultTime;
    
    return tone;
}

- (instancetype)toneByAddingSemitones:(NSInteger)semitones {
    
    
    NSInteger nextNote = ((self.note + semitones) % (BCNoteGSharp + 1));
    BOOL shiftOctave = (nextNote <= self.note && semitones > 0);

    BCTone *nextTone = [BCTone toneFromNote:nextNote];
    nextTone.octave = self.octave;
    if (shiftOctave) nextTone.octave++;
    
    return nextTone;
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
        
        _frequency = a4Hrz * pow(sqrSemitone, self.note);
        
        float multiplier = 1.0;
        if (self.octave == 3) multiplier = 0.5;
        if (self.octave == 5) multiplier = 2.0;
        if (self.octave == 6) multiplier = 4.0;
        if (self.octave == 7) multiplier = 8.0;
        if (self.octave == 8) multiplier = 16.0;
        
        _frequency = (_frequency * multiplier);
        
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

- (void)playCompleted:(voidBlock)completed {
    
    // Stop changing parameters on the unit
    OSErr err = AudioUnitInitialize(self.toneUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %d", err);
    
    // Start playback
    err = AudioOutputUnitStart(self.toneUnit);
    NSAssert1(err == noErr, @"Error starting unit: %d", err);
    
    BOOL sameStop = (self.period == self.duration);
    
    dispatch_time_t playTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.period * NSEC_PER_SEC));
    dispatch_after(playTime, dispatch_get_main_queue(), ^(void){
        [self stop];
        if (sameStop && completed) completed();
    });
    
    if (!sameStop && completed) {
        dispatch_time_t endTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC));
        dispatch_after(endTime, dispatch_get_main_queue(), ^(void){
            if (completed)completed();
        });
    }

}

- (void)stop {
    AudioOutputUnitStop(self.toneUnit);
    AudioUnitUninitialize(self.toneUnit);
    AudioComponentInstanceDispose(self.toneUnit);
    _toneUnit = nil;
}

@end
