//
//  CardViewAnimationHelper.m
//  NeweggCNiPhone
//
//  Created by Frog Tan on 14-2-20.
//  Copyright (c) 2014年 newegg. All rights reserved.
//

#import "CardViewAnimationHelper.h"

#import "NEPagedScrollView.h"

@implementation CardViewAnimationHelper
+ (void)initAlphaOfCardViewsInScrollView:(NEPagedScrollView *)scrollView{
	static CGFloat destAlpha = 0.4f;
	CGFloat offsetY = scrollView.contentOffset.y;
	
	NSArray *cardViews = [scrollView visibleViews];
	if(offsetY >= 0  && offsetY <= scrollView.contentSize.height - scrollView.sizeH){
		CGFloat centerY = offsetY + scrollView.sizeH / 2;
		
		CGFloat alphaDescreaseSpeed =  (1 - destAlpha) / (scrollView.sizeH / 2 );
		
		[cardViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			UIView *cardView = obj;
			
			CGFloat cardViewCenterY = cardView.center.y;
			
			CGFloat offset = fabs(cardViewCenterY - centerY);
			
			CGFloat alpha = 1 - offset * alphaDescreaseSpeed;
			
			if(alpha < destAlpha){
				alpha = destAlpha;
			}
			
			cardView.alpha = alpha;
		}];
	}
}
@end
