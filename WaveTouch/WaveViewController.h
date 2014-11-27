//
//  WaveViewController.h
//  WaveTouch
//
//  Created by Jackson Firlik on 11/26/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"
@class SynthCore;

@interface WaveViewController : UIViewController <WaveViewDelegate>

@property (nonatomic, readonly) SynthCore *synthCore;

@end

