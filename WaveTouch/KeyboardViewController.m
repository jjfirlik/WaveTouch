//
//  KeyboardViewController.m
//  WaveTouch
//
//  Created by Jackson Firlik on 11/27/14.
//  Copyright (c) 2014 Jackson Firlik. All rights reserved.
//

#import "KeyboardViewController.h"
#import "WaveViewController.h"
#import "SynthCore.h"

@interface KeyboardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *lowC;
@property (weak, nonatomic) IBOutlet UIButton *CSharp;
@property (weak, nonatomic) IBOutlet UIButton *D;
@property (weak, nonatomic) IBOutlet UIButton *DSharp;
@property (weak, nonatomic) IBOutlet UIButton *E;
@property (weak, nonatomic) IBOutlet UIButton *F;
@property (weak, nonatomic) IBOutlet UIButton *FSharp;
@property (weak, nonatomic) IBOutlet UIButton *G;
@property (weak, nonatomic) IBOutlet UIButton *GSharp;
@property (weak, nonatomic) IBOutlet UIButton *A;
@property (weak, nonatomic) IBOutlet UIButton *ASharp;
@property (weak, nonatomic) IBOutlet UIButton *B;
@property (weak, nonatomic) IBOutlet UIButton *highC;
@property (weak, nonatomic) IBOutlet UIButton *octaveUp;
@property (weak, nonatomic) IBOutlet UIButton *octaveDown;
- (IBAction)playNote:(id)sender;
- (IBAction)increaseOctave:(id)sender;
- (IBAction)decreaseOctave:(id)sender;
@property (assign, nonatomic) NSUInteger octave;
- (IBAction)stopNote:(id)sender;

@property (weak, nonatomic) WaveViewController *wvc;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.lowC.layer.borderColor = [UIColor blackColor].CGColor;
    self.lowC.layer.borderWidth = 1.0;
    self.CSharp.layer.borderColor = [UIColor blackColor].CGColor;
    self.CSharp.layer.borderWidth = 1.0;
    self.D.layer.borderColor = [UIColor blackColor].CGColor;
    self.D.layer.borderWidth = 1.0;
    self.DSharp.layer.borderColor = [UIColor blackColor].CGColor;
    self.DSharp.layer.borderWidth = 1.0;
    self.E.layer.borderColor = [UIColor blackColor].CGColor;
    self.E.layer.borderWidth = 1.0;
    self.F.layer.borderColor = [UIColor blackColor].CGColor;
    self.F.layer.borderWidth = 1.0;
    self.FSharp.layer.borderColor = [UIColor blackColor].CGColor;
    self.FSharp.layer.borderWidth = 1.0;
    self.G.layer.borderColor = [UIColor blackColor].CGColor;
    self.G.layer.borderWidth = 1.0;
    self.GSharp.layer.borderColor = [UIColor blackColor].CGColor;
    self.GSharp.layer.borderWidth = 1.0;
    self.A.layer.borderColor = [UIColor blackColor].CGColor;
    self.A.layer.borderWidth = 1.0;
    self.ASharp.layer.borderColor = [UIColor blackColor].CGColor;
    self.ASharp.layer.borderWidth = 1.0;
    self.B.layer.borderColor = [UIColor blackColor].CGColor;
    self.B.layer.borderWidth = 1.0;
    self.highC.layer.borderColor = [UIColor blackColor].CGColor;
    self.highC.layer.borderWidth = 1.0;
    
    self.wvc = [self.tabBarController.viewControllers firstObject];
    self.octave = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playNote:(id)sender {
    int noteNumber = (int)([sender tag] + self.octave);
    [self.wvc.synthCore noteOn:noteNumber];
}

- (IBAction)increaseOctave:(id)sender {
    self.octave += 12;
}

- (IBAction)decreaseOctave:(id)sender {
    self.octave -= 12;
}

- (IBAction)stopNote:(id)sender {
    int noteNumber = (int)([sender tag] + self.octave);
    [self.wvc.synthCore noteOff:noteNumber];

}
@end
