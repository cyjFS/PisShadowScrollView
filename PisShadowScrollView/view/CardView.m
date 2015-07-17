//
//  CardView.m
//  PisShadowScrollView
//
//  Created by newegg on 15/7/17.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "CardView.h"
#import "UIColor+Random.h"
@interface CardView ()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation CardView

- (void)awakeFromNib{
    self.frame = CGRectMake(0, 0, screen_w, self.sizeH);
}
- (void)bindIndex:(NSInteger)index
{
    self.colorView.backgroundColor = [UIColor randomColor];
    self.textLabel.text = [NSString stringWithFormat:@"这是第%ld个card",(long)index];
}

@end
