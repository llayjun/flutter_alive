//
//  GoodsListCell.m
//  Runner
//
//  Created by 张智慧 on 2020/3/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "GoodsListCell.h"

@interface GoodsListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@end

@implementation GoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)getCellHeight {
    return 100;
}

+ (GoodsListCell *)goodsListTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListCellId"];
    if(!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"GoodsListCell" owner:self options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(DisPlayWindowModel *)model {
    _model = model;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.goodsTitleLab.text = model.name;
    self.detailTitleLab.text = [NSString stringWithFormat:@"库存：%@  销量：%@",model.totalStockNum,model.saleAmount];
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    if([model.displayWindow isEqualToString:@"SHOW"]) {
        self.showBtn.selected = YES;
    }else {
        
        self.showBtn.selected = NO;
    }
    if([model.status isEqualToString:@"ON_SELL"]){
        self.downorUpBtn.selected = NO;
        self.showBtn.hidden = NO;
    }else {
        self.downorUpBtn.selected = YES;
        // 下架的状态不现实是否展示按钮
        self.showBtn.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
