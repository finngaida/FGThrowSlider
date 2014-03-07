//
//  FGThrowSlider.m
//  Throw Slider Control Demo
//
//  Created by Finn Gaida on 15.02.14.
//  Copyright (c) 2014 Finn Gaida. All rights reserved.
//

#import "FGThrowSlider.h"

@implementation FGThrowSlider {
    UIDynamicAnimator *animator;
    UIView *knob;
    UIView *base;
    UIView *highlight;
    CGFloat startVal;
    BOOL valid;
}

#pragma mark instantiation

+ (FGThrowSlider *)sliderWithFrame:(CGRect)frame andDelegate:(id <FGThrowSliderDelegate>)del {
    return [[FGThrowSlider alloc] initWithFrame:frame andDelegate:del];
}

+ (FGThrowSlider *)sliderWithFrame:(CGRect)frame delegate:(id <FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage {
    return [[FGThrowSlider alloc] initWithFrame:frame
                                       delegate:del
                                      leftTrack:leftImage
                                     rightTrack:rightImage
                                          thumb:thumbImage];
}

- (id)initWithFrame:(CGRect)frame {
    return [[FGThrowSlider alloc] initWithFrame:frame andDelegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id <FGThrowSliderDelegate>)del {
    self = [super initWithFrame:frame];
    if (self) {
        if (NSClassFromString(@"UIDynamicAnimator")) {
            animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        }
        
        // args
        _delegate = del;
        valid = NO;
        
        // bg
        CGFloat xmargin = (_leftImage) ? 20 : 0;
        CGFloat width = (_rightImage) ? self.frame.size.width-xmargin-20 : self.frame.size.width-xmargin;
        base = [[UIView alloc] initWithFrame:CGRectMake(xmargin, self.frame.size.height/2-1, width, 2)];
        base.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
        [self addSubview:base];
        highlight = [[UIView alloc] initWithFrame:CGRectMake(0, base.frame.origin.y, self.frame.size.width/2, 2)];
        highlight.backgroundColor = [UIColor colorWithRed:0.0 green:(122.0/255.0) blue:1 alpha:1];
        [self addSubview:highlight];
        
        // dragger setup
        knob = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        knob.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        knob.backgroundColor = [UIColor whiteColor];
        knob.layer.masksToBounds = YES;
        knob.layer.cornerRadius = knob.frame.size.width/2;
        [self addSubview:knob];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage {
    self = [super initWithFrame:frame];
    if (self) {
        if (NSClassFromString(@"UIDynamicAnimator")) {
            animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        }
        
        // args
        _delegate = del;
        valid = NO;
        
        // bg
        CGFloat xmargin = (_leftImage) ? 20 : 0;
        CGFloat width = (_rightImage) ? self.frame.size.width-xmargin-20 : self.frame.size.width-xmargin;
        base = [[UIView alloc] initWithFrame:CGRectMake(xmargin, self.frame.size.height/2-1, width, 2)];
        base.backgroundColor = [UIColor colorWithPatternImage:rightImage];
        [self addSubview:base];
        
        highlight = [[UIView alloc] initWithFrame:CGRectMake(0, base.frame.origin.y, self.frame.size.width/2, 2)];
        highlight.backgroundColor = [UIColor colorWithPatternImage:leftImage];
        [self addSubview:highlight];
        
        // dragger setup
        knob = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thumbImage.size.width, thumbImage.size.height)];
        knob.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        knob.backgroundColor = [UIColor colorWithPatternImage:thumbImage];
//        knob.layer.masksToBounds = YES;
//        knob.layer.cornerRadius = knob.frame.size.width/2;
        [self addSubview:knob];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark callbacks

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
            // check if the drag starts inside the tolerance zone
            if ([pan locationInView:self].x > knob.frame.origin.x - 30 && [pan locationInView:self].x < knob.frame.origin.x + 80) {
                valid = YES;
                startVal = [pan locationInView:self].x - knob.center.x;
            } else {
                valid = NO;
            }
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
            // move the knob, highlight and value
            if (valid && [pan locationInView:self].x>10 && [pan locationInView:self].x<self.frame.size.width-10) {
                knob.center = (valid) ? CGPointMake([pan locationInView:self].x-startVal, self.frame.size.height/2) : knob.center;
                highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
                _value = knob.center.x/self.frame.size.width;
                [_delegate slider:self changedValue:_value];
            }
            
            NSLog(@"%f ", knob.center.x);
            
        } break;
        case UIGestureRecognizerStateEnded: {
            
            // introduce the fadeout
            if (valid) {
                [self fadeOut:knob from:[pan locationInView:self].x velocity:[pan velocityInView:self].x amplifier:30];
            }
        
        } break;
        case UIGestureRecognizerStateCancelled: {
        } break;
        case UIGestureRecognizerStateFailed: {
        } break;
        case UIGestureRecognizerStatePossible: {
        } break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    startVal = [[touches anyObject] locationInView:self].x-knob.center.x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    
    // move the knob, highlight and value
    if (valid && p.x>10 && p.x<self.frame.size.width-10) {
        knob.center = (valid) ? CGPointMake(p.x-startVal, self.frame.size.height/2) : knob.center;
        highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
        _value = knob.center.x/self.frame.size.width;
        [_delegate slider:self changedValue:_value];
    }
}

- (void)fadeOut:(UIView *)view from:(CGFloat)from velocity:(CGFloat)velocity amplifier:(CGFloat)amplifier {
    
    CGFloat perOne = velocity / 500;
    
    CGFloat calculatedFinalPosition = from + amplifier * perOne;
    
    CGFloat factor = perOne*2;
    
    [animator removeAllBehaviors];
    
    if (calculatedFinalPosition < 10) {
        
        /*UIGravityBehavior *grav = [[UIGravityBehavior alloc] initWithItems:@[knob]];
        [grav setAngle:M_PI magnitude:1];
        UICollisionBehavior *coll = [[UICollisionBehavior alloc] initWithItems:@[knob]];
        coll.translatesReferenceBoundsIntoBoundary = YES;
        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[knob]];
        item.elasticity = .5;
        [animator addBehavior:grav];
        [animator addBehavior:coll];
        [animator addBehavior:item];*/
        
        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.center = CGPointMake(0, view.center.y);
            highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                view.center = CGPointMake(factor, view.center.y);
                highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 animations:^{
                    view.center = CGPointMake(0, view.center.y);
                    highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
                } completion:^(BOOL finished) {
                    _value = self.frame.size.width/knob.center.x;
                }];
            }];
        }];
        
    } else if (calculatedFinalPosition > self.frame.size.width - 10) {
        
        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.center = CGPointMake(self.frame.size.width, view.center.y);
            highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                view.center = CGPointMake(self.frame.size.width-factor, view.center.y);
                highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 animations:^{
                    view.center = CGPointMake(self.frame.size.width, view.center.y);
                    highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
                } completion:^(BOOL finished) {
                    _value = self.frame.size.width/knob.center.x;
                }];
            }];
        }];
        
    } else {
        
        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.center = CGPointMake(calculatedFinalPosition, view.center.y);
            highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);
        } completion:^(BOOL finished) {
            _value = self.frame.size.width/knob.center.x;
        }];
  
    }
    
}

@end

// (c) Finn Gaida 2014
