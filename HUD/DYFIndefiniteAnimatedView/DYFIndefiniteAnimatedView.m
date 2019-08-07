//
//  DYFIndefiniteAnimatedView.m
//
//  Created by dyf on 15/8/27.
//  Copyright © 2015 dyf. All rights reserved.
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

#import "DYFIndefiniteAnimatedView.h"

@interface DYFIndefiniteAnimatedView ()
@property (nonatomic, strong) CAShapeLayer *indefiniteAnimatedLayer;
@end

@implementation DYFIndefiniteAnimatedView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    } else {
        [_indefiniteAnimatedLayer removeFromSuperlayer];
        _indefiniteAnimatedLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.indefiniteAnimatedLayer;
    [self.layer addSublayer:layer];
    
    CGFloat posX   = CGRectGetWidth (self.bounds) - CGRectGetWidth (layer.bounds)/2.;
    CGFloat posY   = CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds)/2.;
    layer.position = CGPointMake(posX, posY);
}

- (CAShapeLayer *)indefiniteAnimatedLayer {
    if (!_indefiniteAnimatedLayer) {
        CGFloat mX         = self.radius + self.lineWidth/2.;
        CGPoint arcCenter  = CGPointMake(mX, mX);
        CGRect  rect       = CGRectMake(0., 0., 2*arcCenter.x, 2*arcCenter.y);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                            radius:self.radius
                                                        startAngle:(M_PI*3/2.)
                                                          endAngle:(M_PI/2.+M_PI*5)
                                                         clockwise:YES];
        
        _indefiniteAnimatedLayer               = [CAShapeLayer layer];
        _indefiniteAnimatedLayer.contentsScale = [UIScreen mainScreen].scale;
        _indefiniteAnimatedLayer.frame         = rect;
        _indefiniteAnimatedLayer.fillColor     = [UIColor clearColor].CGColor;
        _indefiniteAnimatedLayer.strokeColor   = self.lineColor.CGColor;
        _indefiniteAnimatedLayer.lineWidth     = self.lineWidth;
        _indefiniteAnimatedLayer.lineCap       = kCALineCapRound;
        _indefiniteAnimatedLayer.lineJoin      = kCALineJoinBevel;
        _indefiniteAnimatedLayer.path          = path.CGPath;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (__bridge id)(self.maskImage.CGImage);
        maskLayer.frame    = _indefiniteAnimatedLayer.bounds;
        
        _indefiniteAnimatedLayer.mask = maskLayer;
        
        NSTimeInterval animationDuration   = 1;
        CAMediaTimingFunctionName funcName = kCAMediaTimingFunctionLinear;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:funcName];
        
        CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue           = (id)0;
        animation.toValue             = @(M_PI*2);
        animation.duration            = animationDuration;
        animation.timingFunction      = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount         = INFINITY;
        animation.fillMode            = kCAFillModeForwards;
        animation.autoreverses        = NO;
        [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup   = [CAAnimationGroup animation];
        animationGroup.duration            = animationDuration;
        animationGroup.repeatCount         = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction      = linearCurve;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue         = @0.015;
        strokeStartAnimation.toValue           = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue         = @0.485;
        strokeEndAnimation.toValue           = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
    }
    return _indefiniteAnimatedLayer;
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setRadius:(CGFloat)radius {
    if (radius != _radius) {
        _radius = radius;
        [_indefiniteAnimatedLayer removeFromSuperlayer];
        _indefiniteAnimatedLayer = nil;
        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _indefiniteAnimatedLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _indefiniteAnimatedLayer.lineWidth = lineWidth;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius+self.lineWidth/2.)*2, (self.radius+self.lineWidth/2.)*2);
}

@end
