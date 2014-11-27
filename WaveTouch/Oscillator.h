//
//  Oscillator.h
//  Synth
//
//  Created by Jackson Firlik on 11/23/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Oscillator : NSObject

@property (assign, nonatomic) double f0;

- (instancetype)initWithWaveTable:(NSArray *)waveTable;
- (SInt16)doOscillate;

@end
