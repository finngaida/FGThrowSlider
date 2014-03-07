//
//  FGThrowSlider.h
//  Throw Slider Control Demo
//
//  Created by Finn Gaida on 15.02.14.
//  Copyright (c) 2014 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGThrowSlider;
@protocol FGThrowSliderDelegate

- (void)slider:(FGThrowSlider *)slider changedValue:(CGFloat)value;

@end

@interface FGThrowSlider : UIControl

+ (FGThrowSlider *)sliderWithFrame:(CGRect)frame andDelegate:(id <FGThrowSliderDelegate>)del;
+ (FGThrowSlider *)sliderWithFrame:(CGRect)frame delegate:(id <FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage;

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id <FGThrowSliderDelegate>)del;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage;

@property (nonatomic) BOOL usesPanGestureRecognizer;
@property (nonatomic) CGFloat value;
@property (nonatomic) id <FGThrowSliderDelegate> delegate;
@property (nonatomic) UIImageView *leftImage;
@property (nonatomic) UIImageView *rightImage;

@end
