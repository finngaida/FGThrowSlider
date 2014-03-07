//
//  ViewController.m
//  Throw Slider Control Demo
//
//  Created by Finn Gaida on 15.02.14.
//  Copyright (c) 2014 Finn Gaida. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    UIView *one;
    UIView *two;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    one = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 20, 20)];
    one.backgroundColor = [UIColor redColor];
    [self.view addSubview:one];
    
    two = [[UIView alloc] initWithFrame:CGRectMake(280, 50, 20, 20)];
    two.backgroundColor = [UIColor redColor];
    [self.view addSubview:two];
    
    FGThrowSlider *slid = [FGThrowSlider sliderWithFrame:CGRectMake(50, 200, 200, 50) andDelegate:self];
    [self.view addSubview:slid];
    
    FGThrowSlider *slide = [FGThrowSlider sliderWithFrame:CGRectMake(50, 250, 200, 50)
                                                 delegate:self
                                                leftTrack:nil // insert UIImage for left track
                                               rightTrack:nil // insert UIImage for right track
                                                    thumb:nil // insert UIImage for thumb image
                            ];
    [self.view addSubview:slide];

    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 300, 200, 50)];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(s:) forControlEvents:UIControlEventValueChanged];

}

- (void)s:(UISlider *)s {
    two.center = CGPointMake(290, 50 + s.value * 100);
}

- (void)slider:(FGThrowSlider *)slider changedValue:(CGFloat)value {
    one.center = CGPointMake(30, 50 + slider.value * 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
