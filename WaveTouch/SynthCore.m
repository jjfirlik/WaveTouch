//
//  SynthCore.m
//  Synth
//
//  Created by Jackson Firlik on 11/23/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import "SynthCore.h"
#import "Oscillator.h"
#import "SynthGlobals.h"

#define BUFFER_COUNT 3
#define BUFFER_DURATION 0.012 // 1024 / 44100

@interface SynthCore ()

@property (strong, nonatomic) Oscillator *m_Osc1;
@property (assign, nonatomic) BOOL m_bNoteOn;

- (OSStatus)fillBuffer:(AudioQueueBufferRef)buffer;

@end

@implementation SynthCore

@synthesize streamFormat=_streamFormat;
@synthesize bufferSize;
@synthesize startingFrameCount;
@synthesize audioQueue;

static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    
    
    char errorString[20];
    // see if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) &&
        isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else
        sprintf(errorString, "%d", (int)error);
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    
    exit(1);
}

void MyInterruptionListener (void *inUserData,
                             UInt32 inInterruptionState)
{
    printf("Interrupted! inInterruptionState=%ud\n", inInterruptionState);
    SynthCore *synthCore = (__bridge SynthCore *)inUserData;
    switch (inInterruptionState) {
        case kAudioSessionBeginInterruption:
            break;
        case kAudioSessionEndInterruption:
            CheckError(AudioQueueStart(synthCore.audioQueue,
                                       0),
                       "Couldn't restart the audio queue");
            break;
        default:
            break;
    }
}

static void MyAQOutputCallback(void *inUserData,
                               AudioQueueRef inAQ,
                               AudioQueueBufferRef inCompleteAQBuffer)
{
    SynthCore *synthCore = (__bridge SynthCore *)inUserData;
    CheckError([synthCore fillBuffer:inCompleteAQBuffer],
               "Can't refill buffer");
    CheckError(AudioQueueEnqueueBuffer(inAQ,
                                       inCompleteAQBuffer,
                                       0,
                                       NULL),
               "Couldn't enqueue the buffer (refill)");
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.m_bNoteOn = NO;
        
        //Initialize the audio session
        CheckError(AudioSessionInitialize(NULL,
                                          kCFRunLoopDefaultMode,
                                          MyInterruptionListener,
                                          (__bridge void *)self),
                   "Couldn't initialize the audio session");
        
        UInt32 category = kAudioSessionCategory_MediaPlayback;
        CheckError(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                           sizeof(category),
                                           &category),
                   "Couldn't set category on audio session");
        
        //Set the stream format
        _streamFormat.mSampleRate = 44100.0;
        _streamFormat.mFormatID = kAudioFormatLinearPCM;
        _streamFormat.mFormatFlags = kAudioFormatFlagsCanonical;
        _streamFormat.mChannelsPerFrame = 1;
        _streamFormat.mFramesPerPacket = 1;
        _streamFormat.mBitsPerChannel = 16;
        _streamFormat.mBytesPerFrame = 2;
        _streamFormat.mBytesPerPacket = 2;
        
        CheckError(AudioQueueNewOutput(&_streamFormat,
                                       MyAQOutputCallback,
                                       (__bridge void *)self,
                                       NULL,
                                       kCFRunLoopCommonModes,
                                       0,
                                       &audioQueue),
                   "Couldn't create the output AudioQueue");
        
        //Initialize and prime the buffers
        AudioQueueBufferRef buffers [BUFFER_COUNT];
        bufferSize = BUFFER_DURATION * self.streamFormat.mSampleRate * self.streamFormat.mBytesPerFrame;
        NSLog(@"bufferSize is %u", bufferSize);
        
        for (int i=0; i<BUFFER_COUNT; i++) {
            CheckError(AudioQueueAllocateBuffer(audioQueue,
                                                bufferSize,
                                                &buffers[i]),
                       "Couldn't allocate the Audio Queue buffer");
            CheckError([self fillBuffer:buffers[i]],
                       "Couldn't fill buffer (priming)");
            CheckError(AudioQueueEnqueueBuffer(audioQueue,
                                               buffers[i],
                                               0,
                                               NULL),
                       "Couldn't enqueue buffer (priming)");
            
        }
        
    }
    
    return self;
}

- (void)setWaveTable:(NSArray *)waveTable
{
    self.m_Osc1 = [[Oscillator alloc] initWithWaveTable:waveTable];
}

- (void)noteOn:(int)noteNumber
{
    self.m_bNoteOn = YES;
    [self.m_Osc1 setF0:midiFreqTable[noteNumber]];
    CheckError(AudioQueueStart(audioQueue,
                               NULL),
               "Couldn't start the AudioQueue");
}

- (void)noteOff:(int)noteNumber
{
    self.m_bNoteOn = NO;
    CheckError(AudioQueuePause(audioQueue),
               "Couldn't pause the AudioQueue");
    CheckError(AudioQueueFlush(audioQueue),
               "Couldn't flush buffer");
    
}

- (OSStatus)fillBuffer:(AudioQueueBufferRef)buffer
{
    int frame = 0;
    
    double frameCount = bufferSize / self.streamFormat.mBytesPerFrame;
    for (frame = 0; frame < frameCount; ++frame)
    {
        SInt16 *data = (SInt16*)buffer->mAudioData;
        (data)[frame] = [self.m_Osc1 doOscillate];
    }
    buffer->mAudioDataByteSize = bufferSize;
    
    return noErr;
}

@end
