//
//  NEPagedScrollView.h
//  ArgosCNIPhone
//
//  Created by Frog Tan on 7/4/12.
//  Copyright (c) 2012 Newegg. All rights reserved.
//


typedef enum{
	PagingDirectionHoriaontal,
	PagingDirectionVertical
}PagingDirection;

@class NEPagedScrollView;

@protocol NEPagedScrollViewDataSource <NSObject>
- (NSInteger)numberOfItemViewsInPagedScrollView:(NEPagedScrollView *)pagedScrollView;
- (UIView *)pagedScrollView:(NEPagedScrollView *)pagedScrollView itemViewOfPage:(NSInteger)pageIndex;
@end

@protocol NEPagedScrollViewDelegate <NSObject>
@optional
- (void)pagedScrollView:(NEPagedScrollView *)pagedScrollView didSelectedItemViewOfPage:(NSInteger)pageIndex;
- (void)pagedScrollView:(NEPagedScrollView *)pagedScrollView didScrollToPage:(NSInteger)pageIndex;
- (void)pagedScrollViewDidScroll:(NEPagedScrollView *)pagedScrollView;
@end

@interface NEPagedScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger							currentPageIndex;
@property (nonatomic, assign) id<NEPagedScrollViewDataSource>	dataSource;
@property (nonatomic, assign) id<NEPagedScrollViewDelegate>		pagedScrollViewDelegate;
@property (nonatomic, assign) BOOL								itemViewTouchEnabled;
@property (nonatomic, assign) BOOL								showTouchIndicator;
@property (nonatomic, assign) PagingDirection					pagingDirection;
@property (nonatomic, assign) CGRect							maskViewOffsetFrame;
@property (nonatomic, strong) UIView							*maskView;

- (void)setup;
- (UIView *)dequeueReusableItemView;
- (void)reload;
- (void)scrollToPage:(NSInteger)pageIndex isInnerScroll:(BOOL)innerScroll;  //如果是innerScroll，只滚动不触发delegate事件
- (void)scrollToPage:(NSInteger)pageIndex;
- (void)scrollToNextPage;
- (void)scrollToPrevPage;
- (NSArray *)visibleViews;

/**
 * Get the current page
 * @return Current page showing
 */
- (UIView *)getCurrentPage;

@end
