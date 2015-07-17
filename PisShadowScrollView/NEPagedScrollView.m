//
//  NEPagedScrollView.m
//  ArgosCNIPhone
//
//  Created by Frog Tan on 7/4/12.
//  Copyright (c) 2012 Newegg. All rights reserved.
//

#import "NEPagedScrollView.h"

@interface NEPagedScrollView ()

@property (nonatomic, strong) NSMutableArray			*cycledItemViews;
@property (nonatomic, strong) NSMutableDictionary		*visibleItemViews;

@property (nonatomic, assign) BOOL                      isInnerScroll;
@property (nonatomic, assign) NSInteger                 targetPageIndex;

@property (nonatomic, assign) NSInteger					touchedPageIndex;

@end

@implementation NEPagedScrollView

#pragma mark - property methods
- (void)setDataSource:(id<NEPagedScrollViewDataSource>)dataSource{
	_dataSource = dataSource;
	
	[self initSubViews];
}

- (void)setMaskViewOffsetFrame:(CGRect)maskViewOffsetFrame{
	if( !CGRectEqualToRect(_maskViewOffsetFrame, maskViewOffsetFrame) ){
		_maskViewOffsetFrame = maskViewOffsetFrame;
		
		self.maskView.frame = CGRectMake(self.frame.origin.x + _maskViewOffsetFrame.origin.x,
										 self.frame.origin.y + _maskViewOffsetFrame.origin.y,
										 self.frame.size.width + _maskViewOffsetFrame.size.width,
										 self.frame.size.height + _maskViewOffsetFrame.size.height);
	}
}
#pragma mark - utility methods
- (NSString *)keyWithPageIndex:(NSInteger)pageIndex{
	return [NSString stringWithFormat:@"%ld", (long)pageIndex];
}
- (void)cyclyVisibleItemViewOfPageIndex:(NSInteger)pageIndex{
	NSString *key = [self keyWithPageIndex:pageIndex];
	UIView *nonVisibleItemView = [self.visibleItemViews objectForKey:key];
	
	if( nonVisibleItemView ){
		[self.cycledItemViews addObject:nonVisibleItemView];
		
		[self.visibleItemViews removeObjectForKey:key];
		[nonVisibleItemView removeFromSuperview];
	}
}

- (void)initSubViews{
	CGPoint offset = CGPointMake(self.pagingDirection == PagingDirectionHoriaontal ? self.currentPageIndex * self.sizeW : 0,
								 self.pagingDirection == PagingDirectionHoriaontal ? 0 : self.currentPageIndex * self.sizeH);
	[self setContentOffset:offset animated:NO];
	
	NSInteger pageCount = [self.dataSource numberOfItemViewsInPagedScrollView:self];
	
    self.contentSize = self.pagingDirection == PagingDirectionHoriaontal ?
	CGSizeMake(self.bounds.size.width *  pageCount, self.bounds.size.height) : CGSizeMake(self.bounds.size.width, self.bounds.size.height  *  pageCount);
	
    if (self.visibleItemViews.count > 0) {
        [self.cycledItemViews addObjectsFromArray:[self.visibleItemViews allValues]];
		
        // Remove all item views from superview. To avoid reAdd
        for (UIView *subView in self.visibleItemViews.allValues) {
            [subView removeFromSuperview];
        }
        
        [self.visibleItemViews removeAllObjects];
    }
	
	[self addItemViewToPage:self.currentPageIndex - 1];
	[self addItemViewToPage:self.currentPageIndex];
	[self addItemViewToPage:self.currentPageIndex + 1];
}

- (void)addItemViewToPage:(NSInteger)pageIndex{
	if( pageIndex >= 0 && pageIndex < [self.dataSource numberOfItemViewsInPagedScrollView:self] ){
		if(  [self.visibleItemViews objectForKey:[self keyWithPageIndex:pageIndex]] == nil ){
			UIView *itemView = [self.dataSource pagedScrollView:self itemViewOfPage:pageIndex];
			itemView.frame = CGRectMake(self.pagingDirection == PagingDirectionHoriaontal ?
										self.bounds.size.width * pageIndex : 0,
										self.pagingDirection == PagingDirectionVertical ?
										self.bounds.size.height * pageIndex : 0,
										self.bounds.size.width,
										self.bounds.size.height);
            itemView.autoresizingMask = self.pagingDirection == PagingDirectionHoriaontal ? UIViewAutoresizingFlexibleHeight : UIViewAutoresizingFlexibleWidth;
			[self addSubview:itemView];
			
			[self.visibleItemViews setObject:itemView forKey:[self keyWithPageIndex:pageIndex]];
		}
	}
}

- (void)setMaskViewHidden:(BOOL)hidden{
	if( self.showTouchIndicator ){
		if( self.pagingDirection == PagingDirectionHoriaontal ){
			self.maskView.originX = self.touchedPageIndex *  self.sizeW + self.maskViewOffsetFrame.origin.x;
		}
		else{
			self.maskView.originY = self.touchedPageIndex *  self.sizeH + self.maskViewOffsetFrame.origin.y;
		}
		
		
		[self bringSubviewToFront:self.maskView];
		self.maskView.hidden = NO;
		[UIView animateWithDuration:0.1f 
						 animations:^{
							 self.maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:hidden ? 0 : 0.5f];
						 }
						 completion:^(BOOL finished){
							 self.maskView.hidden = hidden;
						 }
		 ];
	}
}
#pragma mark - init
- (void)setup{
	self.pagingEnabled = YES;
	self.delegate = self;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = NO;
	self.itemViewTouchEnabled = YES;
	self.showTouchIndicator = YES;
	
	self.visibleItemViews = [NSMutableDictionary dictionary];
	self.cycledItemViews = [NSMutableArray array];
	
	self.maskView = [[UIView alloc] initWithFrame:self.bounds];
	[self addSubview:self.maskView];
	
	self.pagingDirection = PagingDirectionHoriaontal;
	self.maskViewOffsetFrame = CGRectZero;
}

- (id)init{
	self = [super init];
	
	if( self ){
		[self setup];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	
	if( self ){
		[self setup];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	
	if( self ){
		[self setup];
	}
	
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize currentContentSize = self.contentSize;
    
    if (self.pagingDirection == PagingDirectionHoriaontal) {
        currentContentSize.height = self.sizeH;
    } else if (self.pagingDirection == PagingDirectionVertical) {
        currentContentSize.width = self.sizeW;
    }
    
    self.contentSize = currentContentSize;
}

#pragma mark - scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isInnerScroll = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isInnerScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSInteger pageIndex;
	
	if( self.pagingDirection == PagingDirectionHoriaontal ){
		pageIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
		
		if( (int)scrollView.contentOffset.x % (int)scrollView.bounds.size.width >= scrollView.bounds.size.width / 2 ){
			pageIndex++;
		}
	}
	else{
		pageIndex = scrollView.contentOffset.y / scrollView.bounds.size.height;
		
		if( (int)scrollView.contentOffset.y % (int)scrollView.bounds.size.height >= scrollView.bounds.size.height / 2 ){
			pageIndex++;
		}
	}
    
    // Ensure the page index is valid
    NSInteger pageCount = [self.dataSource numberOfItemViewsInPagedScrollView:self];
	if(pageIndex != self.currentPageIndex && pageIndex >= 0 && pageIndex < pageCount){

		if(pageIndex > self.currentPageIndex){
			[self cyclyVisibleItemViewOfPageIndex:self.currentPageIndex - 1];
		}
		else{
			[self cyclyVisibleItemViewOfPageIndex:self.currentPageIndex + 1];
		}
		
		if(pageIndex > self.currentPageIndex){
			[self addItemViewToPage:pageIndex + 1];
		}
		else{
			[self addItemViewToPage:pageIndex - 1];
		}
		
		self.currentPageIndex = pageIndex;
        
        // 如果是单纯的innerScroll，只有当滚动到目标页面时才触发delegate，路过中间页面时不触发
        if (!(self.isInnerScroll && pageIndex != self.targetPageIndex)) {

            if( [self.pagedScrollViewDelegate respondsToSelector:@selector(pagedScrollView:didScrollToPage:)] ){
                [self.pagedScrollViewDelegate pagedScrollView:self didScrollToPage:pageIndex];
            }

        }
	}
	
	if( [self.pagedScrollViewDelegate respondsToSelector:@selector(pagedScrollViewDidScroll:)] ){
		[self.pagedScrollViewDelegate pagedScrollViewDidScroll:self];
	}
}
#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	
	[self updateTouchedPageIndexWithTouches:touches];
	if(self.itemViewTouchEnabled && self.visibleItemViews.count > 0){
		[self setMaskViewHidden:NO];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesCancelled:touches withEvent:event];
	[self updateTouchedPageIndexWithTouches:touches];
	
	if(self.itemViewTouchEnabled && self.visibleItemViews.count > 0){
		[self setMaskViewHidden:YES];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	[self updateTouchedPageIndexWithTouches:touches];
	
	if(self.itemViewTouchEnabled && self.visibleItemViews.count > 0){
		[self setMaskViewHidden:YES];
		if( [self.pagedScrollViewDelegate respondsToSelector:@selector(pagedScrollView:didSelectedItemViewOfPage:) ]){
						[self.pagedScrollViewDelegate pagedScrollView:self didSelectedItemViewOfPage:self.touchedPageIndex];
		}
	}
}

#pragma mark - public methods
- (UIView *)dequeueReusableItemView{
	UIView *result = nil;
	
	if( self.cycledItemViews.count > 0 ){
		result = [self.cycledItemViews lastObject];
		[self.cycledItemViews removeLastObject];
	}
	
	return result;
}

- (void)reload{
	[self initSubViews];
}

- (void)scrollToPage:(NSInteger)pageIndex
{
    [self scrollToPage:pageIndex isInnerScroll:NO];
}

- (void)scrollToPage:(NSInteger)pageIndex isInnerScroll:(BOOL)innerScroll{
    self.isInnerScroll = innerScroll;
    self.targetPageIndex = pageIndex;
    
	if( pageIndex >= 0 && pageIndex < [self.dataSource numberOfItemViewsInPagedScrollView:self] ){
		CGFloat offset = self.pagingDirection == PagingDirectionHoriaontal ? self.bounds.size.width * pageIndex : self.bounds.size.height * pageIndex;
		
		CGPoint contentOffset = self.pagingDirection == PagingDirectionHoriaontal ? CGPointMake(offset, 0) : CGPointMake(0, offset);
		
		if( CGPointEqualToPoint(contentOffset, self.contentOffset) ){
			self.isInnerScroll = NO;
		}
		else{
			[self setContentOffset:contentOffset
						  animated:YES];
		}
	}
}

- (void)scrollToNextPage{
	[self scrollToPage:self.currentPageIndex + 1];
}

- (void)scrollToPrevPage{
	[self scrollToPage:self.currentPageIndex - 1];
}

- (NSArray *)visibleViews{
	return [NSArray arrayWithArray:[self.visibleItemViews allValues]];
}
#pragma mark - Get Current Page

- (UIView *)getCurrentPage
{
    return [self.visibleItemViews objectForKey:[self keyWithPageIndex:self.currentPageIndex]];
}

#pragma mark -
#pragma mark - utility methods
- (void)updateTouchedPageIndexWithTouches:(NSSet *)touches{
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	
	NSInteger pageIndex = floor(pt.y / self.sizeH);
	
	self.touchedPageIndex = MAX(MIN(pageIndex, [self.dataSource numberOfItemViewsInPagedScrollView:self] - 1), 0);
}

@end
