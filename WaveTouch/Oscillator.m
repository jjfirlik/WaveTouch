//
//  Oscillator.m
//  Synth
//
//  Created by Jackson Firlik on 11/23/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import "Oscillator.h"

@interface Oscillator ()

@property (assign, nonatomic) double m_dStartingFrameCount;
@property (assign, nonatomic) double m_dReadIndex;
@property (assign, nonatomic) double m_dInc;
@property (assign, nonatomic) NSArray *waveTable;

- (void)incReadIndex;
- (BOOL)checkWrapReadIndex;
- (double)dLinTerpX1:(double)x1 X2:(double)x2 Y1:(double)y1 Y2:(double)y2 X:(double)x;


@end

@implementation Oscillator

@synthesize m_dInc;

- (instancetype)initWithWaveTable:(NSArray *)waveTable
{
    self = [super init];
    
    if (self)
    {
        self.m_dInc = 0.0;
        self.m_dReadIndex = 0.0;
        self.waveTable = waveTable;
        self.f0 = 440.0;
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithWaveTable:nil];
}

- (void)setF0:(double)f0
{
    _f0 = f0;
    self.m_dInc = self.waveTable.count * f0 / 44100.0;
}

- (void)incReadIndex
{
    self.m_dReadIndex += self.m_dInc;
}

- (double)dLinTerpX1:(double)x1 X2:(double)x2 Y1:(double)y1 Y2:(double)y2 X:(double)x
{
    double denom = x2 - x1;
    if(denom == 0)
        return y1; // should not ever happen
    
    // calculate decimal position of x
    double dx = (x - x1)/(x2 - x1);
    
    // use weighted sum method of interpolating
    double result = dx*y2 + (1-dx)*y1;
    
    return result;
}

- (BOOL)checkWrapReadIndex
{
    // for positive frequencies
    if(self.m_dInc > 0 && self.m_dReadIndex > self.waveTable.count - 1)
    {
        self.m_dReadIndex -= self.waveTable.count;
        return true;
    }
    // for negative frequencies
    if(self.m_dInc < 0 && self.m_dReadIndex <= 0.0)
    {
        self.m_dReadIndex += self.waveTable.count;
        return true;
    }
    return false;
}

- (SInt16)doOscillate;
{
    [self checkWrapReadIndex];
    
    int nReadIndex = (int)self.m_dReadIndex;
    double dFrac = self.m_dReadIndex - nReadIndex;
    int nReadIndexNext = nReadIndex + 1 > (self.waveTable.count - 1) ? 0 : nReadIndex + 1;
    
    double dOut = [self dLinTerpX1:0.0
                         X2:1.0
                         Y1:[[self.waveTable objectAtIndex:nReadIndex] doubleValue]
                         Y2:[[self.waveTable objectAtIndex:nReadIndexNext] doubleValue]
                          X:dFrac];
    
    [self incReadIndex];

    return (SInt16)(dOut * 0x8000);
}


@end
