//
//  CardViewController.m
//  PisShadowScrollView
//
//  Created by newegg on 15/7/17.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "CardViewController.h"
#import "NEPagedScrollView.h"
#import "PagedScrollViewHelperView.h"
#import "CardViewAnimationHelper.h"
#import "CardView.h"
@interface CardViewController ()<UIScrollViewDelegate,NEPagedScrollViewDataSource,NEPagedScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NEPagedScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *footHelperView;

@property (nonatomic, strong)NSArray    *cards;

@end

@implementation CardViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"scrollView";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.scrollView.pagingDirection = PagingDirectionVertical;
    self.scrollView.dataSource = self;
    self.scrollView.pagedScrollViewDelegate = self;
    
    [CardViewAnimationHelper initAlphaOfCardViewsInScrollView:self.scrollView];
    

}


#pragma mark - paged scroll view data source
-(NSInteger)numberOfItemViewsInPagedScrollView:(NEPagedScrollView *)pagedScrollView
{
    return 8;
}

-(UIView *)pagedScrollView:(NEPagedScrollView *)pagedScrollView itemViewOfPage:(NSInteger)pageIndex
{
    CardView *cardView = (CardView *)[pagedScrollView dequeueReusableItemView];
    if (!cardView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardView" owner:self options:nil];
        cardView = [nib objectAtIndex:0];
    }
    pageIndex += 1;
    [cardView bindIndex:pageIndex];

    return cardView;
}


#pragma mark - paged scroll view delegate
- (void)pagedScrollViewDidScroll:(NEPagedScrollView *)pagedScrollView
{
    [CardViewAnimationHelper initAlphaOfCardViewsInScrollView:self.scrollView];
}

- (void)pagedScrollView:(NEPagedScrollView *)pagedScrollView didScrollToPage:(NSInteger)pageIndex
{
    NSInteger totalPageCount = [self numberOfItemViewsInPagedScrollView:pagedScrollView];
    CGAffineTransform transform = pageIndex == totalPageCount - 1 ? CGAffineTransformMakeTranslation(0, self.footHelperView.sizeH) : CGAffineTransformIdentity;
    
    pagedScrollView.transform = transform;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
