//
//  PagedScrollViewContainerView.m
//  NeweggCNiPhone
//
//  Created by Frog Tan on 14-3-27.
//  Copyright (c) 2014年 newegg. All rights reserved.
//

#import "PagedScrollViewHelperView.h"

@implementation PagedScrollViewHelperView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	if(CGRectContainsPoint(self.bounds, point)){
		CGPoint pt = [self convertPoint:point toView:self.scrollView];
		for(UIView *subView in self.scrollView.subviews){
			if(CGRectContainsPoint(subView.frame, pt)){
				return subView;
			}
		}
	}
	return nil;
}

@end
