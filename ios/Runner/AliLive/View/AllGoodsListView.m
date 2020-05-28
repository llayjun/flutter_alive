//
//  AllGoodsListView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "AllGoodsListView.h"
#import <TYPagerView.h>
#import <TYTabPagerBar.h>
#import "GoodsListTableView.h"

@interface AllGoodsListView ()
<TYPagerViewDataSource,
TYPagerViewDelegate,
TYTabPagerBarDataSource,
TYTabPagerBarDelegate
>

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerView *pageView;
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, copy) NSString *lbId;
@end

@implementation AllGoodsListView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10,10)].CGPath;
        self.layer.mask = maskLayer;
        [self addPagerTabBar];
        [self addPagerView];
        [self loadData];
        
    }
    return self;
}


- (void)addPagerTabBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self addSubview:tabBar];
    self.tabBar = tabBar;
}


- (void)addPagerView {
    TYPagerView *pageView = [[TYPagerView alloc]init];
    pageView.layout.autoMemoryCache = NO;
    pageView.dataSource = self;
    pageView.delegate = self;
    [pageView.layout registerClass:[GoodsListTableView class] forItemWithReuseIdentifier:@"cellId"];
    [self addSubview:pageView];
    self.pageView = pageView;
}

- (void)loadData {
    self.datas = @[@"已上架",@"未上架"];
    [self reloadData];
}


- (void)reloadData {
    if(self.tabBar && self.pageView) {
        [self.tabBar reloadData];
        [self.pageView reloadData];
    }
}

#pragma mark -- TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.datas[index];
    return cell;
}

#pragma mark -- TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = self.datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pageView scrollToViewAtIndex:index animate:YES];
}

#pragma mark -- TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.datas.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    GoodsListTableView *tableView = (GoodsListTableView *)[pagerView.layout dequeueReusableItemWithReuseIdentifier:@"cellId" forIndex:index];
    if(index == 0) {
        [tableView setCurrentStatus:@"ON_SELL" lbIdWith:self.lbId];
    }else {
        [tableView setCurrentStatus:@"PENDING" lbIdWith:self.lbId];
    }
    @WeakSelf(self);
    tableView.needLoadBlock = ^{
        if(weakSelf.needloadWindowBlock) {
            weakSelf.needloadWindowBlock();
        }
    };
    tableView.onlineBlock = ^(NSInteger currentNum) {
        if(index == 0) {
            self.datas = @[[NSString stringWithFormat:@"已上架 (%ld)",currentNum],@"未上架"];
        }else {
            self.datas = @[@"已上架",[NSString stringWithFormat:@"未上架 (%ld)",currentNum]];
        }
        [weakSelf.tabBar reloadData];
    };
    return tableView;
}

#pragma mark -- TYPagerViewDelegate
- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tabBar.frame = CGRectMake(0, 0, WIDE, 45);
    self.pageView.frame = CGRectMake(0, 45, WIDE, self.height - 45 - Indicator_H);
}

- (void)showWithlbId:(NSString *)bId {
    self.lbId = bId;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop  animations:^{
        [self.superview bringSubviewToFront:self];
        self.y = HIGHT/2;
        [self reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.y = HIGHT;
    } completion:^(BOOL finished) {
        
    }];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
