//
//  DYFDesignSpinner.m
//
//  Created by dyf on 14/11/4.
//  Copyright © 2014 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFDesignSpinner.h"
#import <QuartzCore/QuartzCore.h>

@interface DYFDesignSpinner () {
    float _progress;
}
@end

@implementation DYFDesignSpinner

+ (instancetype)spinnerWithSize:(DYFDesignSpinnerSize)size
                          color:(UIColor *)color {
    CGFloat spinnerW;
    
    switch (size) {
        case DYFDesignSpinnerSizeDefault:
            spinnerW = 40.f;
            break;
        case DYFDesignSpinnerSizeLarge:
            spinnerW = 50.f;
            break;
        case DYFDesignSpinnerSizeSmall:
            spinnerW = 30.f;
            break;
    }
    
    CGRect frame = CGRectMake(0, 0, spinnerW, spinnerW);
    DYFDesignSpinner *spinner = [[DYFDesignSpinner alloc] initWithFrame:frame];
    spinner.color = color;
    
    return spinner;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque           = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addAppActivatedObserver];
    }
    return self;
}

- (void)addAppActivatedObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        CGPoint p = [self convertPoint:point toView:view];
        if ([view pointInside:p withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

- (void)resetAnimations {
    if (self.isAnimating) {
        [self setNeedsDisplay];
    }
}

- (void)setIsAnimating:(BOOL)animating {
    _isAnimating = animating;
    if(animating) {
        [UIView animateWithDuration:0.8 animations:^{
            self.alpha = 1.f;
        }];
        [self startRotationAnimation];
    } else {
        [self hide];
    }
}

- (void)hide {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
    }];
}

- (void)drawAnnular {
    _progress += 0.05;
    if(_progress > M_PI) {
        _progress = 0;
    }
    
    CGFloat lineWidth = 3.f;
    if(_circleSize == DYFDesignSpinnerSizeDefault) {
        lineWidth = 2.f;
    }
    
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth     = lineWidth;
    processBackgroundPath.lineCapStyle  = kCGLineCapRound;
    [[UIColor colorWithRed:1. green:1. blue:1. alpha:0.1] set];
    
    CGSize  m_size     = self.bounds.size;
    CGPoint center     = CGPointMake(m_size.width/2., m_size.height/2.);
    CGFloat radius     = (m_size.width - 10 - lineWidth)/2.;
    CGFloat startAngle = - ((float)M_PI/2. - 2*_progress);
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineWidth     = lineWidth;
    processPath.lineCapStyle  = kCGLineCapSquare;
    CGFloat endAngle          = ((float)M_PI + startAngle);
    
    [processPath addArcWithCenter:center
                           radius:radius
                       startAngle:startAngle
                         endAngle:endAngle
                        clockwise:YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if(_hasGlow) {
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(),
                                    CGSizeMake(0, 0),
                                    6,
                                    _color.CGColor);
    }
    [_color set];
    [processPath stroke];
    CGContextRestoreGState(context);
    
    if(_isAnimating) {
        [self startRotationAnimation];
    }
}

- (void)startRotationAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue           = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration          = _speed;
    rotationAnimation.repeatCount       = MAXFLOAT;
    rotationAnimation.cumulative        = YES;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)drawRect:(CGRect)rect {
    [self drawAnnular];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
