//
//  WaveViewController.m
//  WaveTouch
//
//  Created by Jackson Firlik on 11/26/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import "WaveViewController.h"
#import "SynthCore.h"

@interface WaveViewController ()

@property (strong, nonatomic) WaveView *waveView;
@property (strong, nonatomic) NSMutableArray *waveTable;
@property (strong, nonatomic) SynthCore *synthCore;

@end

@implementation WaveViewController

- (void)loadView
{
    self.waveView = [[WaveView alloc] initWithFrame:CGRectZero];
    self.view = self.waveView;
    self.waveView.delegate = self;
    
    self.synthCore = [[SynthCore alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Converts graphics values to (-1 -> +1)
- (NSArray *)scalePointsTable:(NSArray *)pointsTable
{
    NSMutableArray *waveTable = [NSMutableArray array];
    
    CGFloat heightScale = self.view.frame.size.height / 2.0;
    
    for (NSValue *v in pointsTable)
    {
        CGPoint p = [v CGPointValue];
        p.y = 1.0 - p.y / heightScale;
        NSValue *w = [NSValue valueWithCGPoint:p];
        [waveTable addObject:w];
    }
    
    return waveTable;
}

- (CGFloat)linTerpA:(CGFloat)a B:(CGFloat)b T:(CGFloat)t
{
    return a + (b - a) * t;
}

- (void)makeWaveTable:(NSArray *)scaledPointsTable
{
    NSValue *last = [scaledPointsTable lastObject];
    NSUInteger lastIndex = (NSUInteger)last.CGPointValue.x;
    NSMutableArray *waveTable = [[NSMutableArray alloc] init];

    //Create empty array
    for (NSUInteger i = 0; i<=lastIndex; i++)
    {
        [waveTable addObject:[NSNull null]];
    }
    
    //Fill out slots that we know
    for (NSValue *v in scaledPointsTable)
    {
        CGPoint p = v.CGPointValue;

        NSUInteger index = (NSUInteger)p.x;
        [waveTable replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:v.CGPointValue.y]];
    }
    
    //Read through table again and interpolate empty slots
    for (NSUInteger i = 0; i < scaledPointsTable.count - 1; i++)
    {
        NSValue *v1 = [scaledPointsTable objectAtIndex:i];
        NSValue *v2 = [scaledPointsTable objectAtIndex:(i+1)];
        CGPoint p1 = v1.CGPointValue;
        CGPoint p2 = v2.CGPointValue;
        
        CGFloat diff = p2.x - p1.x;
        if (diff > 1)
        {
            for (NSUInteger j = 1; j < diff; j++)
            {
                CGFloat y = [self linTerpA:p1.y B:p2.y T:(j / diff)];
                CGPoint p = CGPointMake((p1.x + j), y);
                NSValue *v = [NSValue valueWithCGPoint:p];
                [waveTable replaceObjectAtIndex:(NSUInteger)p.x withObject:[NSNumber numberWithFloat:v.CGPointValue.y]];
            }
        }
    }
    
    self.waveTable = waveTable;
}

//Callback from view
- (void)waveViewFinishedDrawing:(NSArray *)pointsTable
{
    NSArray *scaledPointsTable = [self scalePointsTable:pointsTable];
    [self makeWaveTable:scaledPointsTable];
    [self.synthCore setWaveTable:self.waveTable];
    [self.synthCore noteOn:45];
    
    for (NSValue *v in self.waveTable)
    {
        NSLog(@"%@", v);
    }
}

@end
