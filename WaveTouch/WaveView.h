//
//  WaveView.h
//  WaveTouch
//
//  Created by Jackson Firlik on 11/26/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaveViewDelegate <NSObject>

- (void)waveViewFinishedDrawing:(NSArray *)pointsTable;

@end

@interface WaveView : UIView

@property id<WaveViewDelegate>delegate;

@end
