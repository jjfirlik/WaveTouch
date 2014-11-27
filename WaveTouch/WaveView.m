//
//  WaveView.m
//  WaveTouch
//
//  Created by Jackson Firlik on 11/26/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()

@property (strong, nonatomic) NSMutableArray *pointsTable;
@property (strong, nonatomic) NSMutableArray *waveTable;

@property (assign, nonatomic) CGPoint farthestRight;

@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint lastPoint = CGPointMake(0.0, self.frame.size.height / 2.0);
    for (NSValue *v in self.pointsTable)
    {
        CGPoint p = [v CGPointValue];
        UIBezierPath *bp = [UIBezierPath bezierPath];
        
        bp.lineWidth = 2;
        bp.lineCapStyle = kCGLineCapRound;
        [bp moveToPoint:lastPoint];
        [bp addLineToPoint:p];
        lastPoint = p;
        [bp stroke];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.pointsTable = [NSMutableArray array];
    CGPoint first = CGPointMake(0.0, self.frame.size.height / 2.0);
    NSValue *v = [NSValue valueWithCGPoint:first];
    [self.pointsTable addObject:v];
    
    for (UITouch *t in touches)
    {
        CGPoint currentPoint = [t locationInView:self];
        currentPoint.x = floorf(currentPoint.x);
        self.farthestRight = currentPoint;
        NSValue *point = [NSValue valueWithCGPoint:currentPoint];
        [self.pointsTable addObject:point];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        CGPoint currentPoint = [t locationInView:self];
        currentPoint.x = floorf(currentPoint.x);
        if (currentPoint.x <= self.farthestRight.x)
            return;
        else
            self.farthestRight = currentPoint;
        NSValue *point = [NSValue valueWithCGPoint:currentPoint];
        [self.pointsTable addObject:point];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = CGPointMake(self.frame.size.width, self.frame.size.height / 2.0);
    NSValue *point = [NSValue valueWithCGPoint:currentPoint];
    [self.pointsTable addObject:point];
    
    [self.delegate waveViewFinishedDrawing:self.pointsTable];
    
    [self setNeedsDisplay];
}

@end
