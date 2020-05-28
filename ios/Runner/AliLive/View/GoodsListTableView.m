//
//  GoodsListTableView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "GoodsListTableView.h"
#import "GoodsListCell.h"

@interface GoodsListTableView ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *myStatus;
@property (nonatomic, copy) NSString *lbId;
@end

@implementation GoodsListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_F0F0F0;
        self.separatorColor = COLOR_F0F0F0;
        if(@available(iOS 11.0,*)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            
        }
    }
    return self;
}

- (void)setCurrentStatus:(NSString *)currentStatus lbIdWith:(nonnull NSString *)lbId {
    self.myStatus = currentStatus;
    self.lbId = lbId;
    [self getGoodListDataWith:currentStatus boardIDWith:lbId];
}

- (void)getGoodListDataWith:(NSString *)status boardIDWith:(NSString *)boardId {
    NSString *url = [NSString stringWithFormat:@"%@/%@/products/status/%@",GetLiveBroadcastURL,boardId,status];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:boardId forKey:@"lbId"];
    [dic setValue:status forKey:@"status"];
    [[RequestManager shareInstance]requestWithMethod:GET url:url dict:dic finished:^(id request) {
        [self.dataArray removeAllObjects];
        NSArray *arr = request;
        for (int i = 0; i<arr.count; i++) {
            DisPlayWindowModel *subModel = [DisPlayWindowModel mj_objectWithKeyValues:arr[i]];
            [self.dataArray addObject:subModel];
        }
        if(self.onlineBlock) {
            self.onlineBlock(self.dataArray.count);
        }
        [self reloadData];
    } failed:^(NSError *error) {
        
    }];
    
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GoodsListCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsListCell *cell = [GoodsListCell goodsListTableView:tableView indexPathWith:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.numLab.text = [NSString stringWithFormat:@"%ld",self.dataArray.count - indexPath.row];
    @weakify(self);
    [[[cell.showBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal   ]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        /// 先判断屏幕数据是否超过四个
        int i = 0;
        for (DisPlayWindowModel *subModel in self.dataArray) {
            if([subModel.displayWindow isEqualToString:@"SHOW"]) {
                i++;
            }
        }
        DisPlayWindowModel *currentModel = self.dataArray[indexPath.row];
        if(i>=4 && [currentModel.displayWindow isEqualToString:@"HIDE"]) {
            [ZZProgress showErrorWithStatus:@"最多可展示4个商品，请先删除其他商品"];
        }else {
            [self updateDataWith:self.dataArray[indexPath.row]];
        }
        
    }];
    [[[cell.downorUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal   ]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self downOrupDataWith:self.dataArray[indexPath.row]];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark -- RequestMethod
- (void)updateDataWith:(DisPlayWindowModel *)model {
    NSString *displayWindow;
    if([model.displayWindow isEqualToString:@"SHOW"]) {
        displayWindow = @"HIDE";
    }else {
        displayWindow = @"SHOW";
    }
    NSString *url = [NSString stringWithFormat:@"%@/products/%@/display-window/%@",GetLiveBroadcastURL,model.id,displayWindow];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:model.id forKey:@"id"];
    [dic setValue:displayWindow forKey:@"displayWindow"];
    [[RequestManager shareInstance]requestWithMethod:PUT url:url dict:dic finished:^(id request) {
        if(self.needLoadBlock) {
            self.needLoadBlock();
        }
        [self getGoodListDataWith:self.myStatus boardIDWith:self.lbId];
        
    } failed:^(NSError *error) {
        
    }];
}

/// 上下架
- (void)downOrupDataWith:(DisPlayWindowModel *)model {
    NSString *status;
    if([model.status isEqualToString:@"PENDING"]) {
        status = @"ON_SELL";
    }else {
        status = @"PENDING";
    }
    NSString *url = [NSString stringWithFormat:@"%@/products/%@/status/%@",GetLiveBroadcastURL,model.id,status];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:model.id forKey:@"id"];
    [dic setValue:status forKey:@"status "];
    [[RequestManager shareInstance]requestWithMethod:PUT url:url dict:dic finished:^(id request) {
        if(self.needLoadBlock) {
            self.needLoadBlock();
        }
        [self getGoodListDataWith:self.myStatus boardIDWith:self.lbId];
    } failed:^(NSError *error) {
        
    }];
    
}


#pragma mark -- LazyMethod
- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
