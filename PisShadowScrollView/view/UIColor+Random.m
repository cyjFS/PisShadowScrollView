//
//  UIColor+Random.m
//  PisShadowScrollView
//
//  Created by newegg on 15/7/17.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+(UIColor *)randomColor
{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned int)(time(NULL)));
    }
    
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
@end
