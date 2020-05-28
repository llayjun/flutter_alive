//
//  GoodsListCell.h
//  Runner
//
//  Created by 张智慧 on 2020/3/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsListCell : UITableViewCell

+ (CGFloat)getCellHeight;

+ (GoodsListCell *)goodsListTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath;

@property (nonatomic, strong) DisPlayWindowModel *model;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (weak, nonatomic) IBOutlet UIButton *downorUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end

NS_ASSUME_NONNULL_END
