//
//  SynthCore.h
//  Synth
//
//  Created by Jackson Firlik on 11/23/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SynthCore : NSObject

@property (assign, nonatomic) AudioQueueRef audioQueue;
@property (assign, nonatomic) AudioStreamBasicDescription streamFormat;
@property (assign, nonatomic) UInt32 bufferSize;
@property (assign, nonatomic) double startingFrameCount;

- (instancetype)init;
- (void)setWaveTable:(NSArray *)waveTable;

- (void)noteOn:(int)noteNumber;
- (void)noteOff:(int)noteNumber;

@end
