//
//  DYFDesignSpinner.h
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

#import <UIKit/UIKit.h>

typedef enum {
    DYFDesignSpinnerSizeDefault, // default size.
    DYFDesignSpinnerSizeLarge,   // Large size.
    DYFDesignSpinnerSizeSmall    // Small size.
} DYFDesignSpinnerSize;

@interface DYFDesignSpinner : UIView

/** The property indicates whether the view is currently animating. */
@property (nonatomic, assign) BOOL isAnimating;

/** It is used to set color for the spinner. */
@property (nonatomic, strong) UIColor *color;

/** It is used to set shadow for the spinner. */
@property (nonatomic, assign) BOOL hasGlow;

/** The speed of the animation. */
@property (nonatomic, assign) float speed;

/** The enum value of the spinner. */
@property (nonatomic, assign) DYFDesignSpinnerSize circleSize;

/**
 Instantiates and return a `DYFDesignSpinner` spinner with the `DYFDesignSpinnerSize` size and the color.
 */
+ (instancetype)spinnerWithSize:(DYFDesignSpinnerSize)size color:(UIColor *)color;

@end
