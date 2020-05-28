//
//  CycleTakePhotoView.m
//  BlueBricks
//
//  Created by GOOT on 2018/10/24.
//  Copyright © 2018年 Wisdom. All rights reserved.
//

#import "CycleTakePhotoView.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"


#define MaxNum 4

@interface CycleTakePhotoView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate>
{
    NSMutableArray *_selectedPhotos;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;


@end

@implementation CycleTakePhotoView


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _selectedPhotos = [NSMutableArray array];
        
        [self configCollectionView];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    _selectedPhotos = [NSMutableArray array];
    
    [self configCollectionView];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(60*WIDES, 60*WIDES);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 240*WIDES) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark -- UICollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= MaxNum) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"white_add"];
        cell.deleteBtn.hidden = YES;
    } else {
        DisPlayWindowModel *subModel = _selectedPhotos[indexPath.item];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:subModel.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        [self pushTZImagePickerController];
    }else {
        
    }
}

#pragma mark -- 删除图片
- (void)deleteBtnClik:(UIButton *)sender {
    [self updateDataWithselectTag:sender.tag];

}

#pragma mark - TZImagePickerController
- (void)pushTZImagePickerController {
    if (MaxNum <= 0) {
        return;
    }
    /// 获取商品
    if(self.needOpenWindowBlock) {
        self.needOpenWindowBlock();
    }
}

- (void)setLbId:(NSString *)lbId {
    _lbId = lbId;
    [self requestDataWith:lbId];
}

#pragma mark -- RequestMethod
- (void)requestDataWith:(NSString *)lbId {
    NSString *url = [NSString stringWithFormat:@"%@/%@/products/displayWindow",GetLiveBroadcastURL,lbId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:lbId forKey:@"lbId"];
    [[RequestManager shareInstance]requestWithMethod:GET url:url dict:dic finished:^(id request) {
        [_selectedPhotos removeAllObjects];
        NSArray *arr = request;
        NSMutableArray *idArray = [NSMutableArray array];
        for (int i = 0; i<arr.count; i++) {
            DisPlayWindowModel *subModel = [DisPlayWindowModel mj_objectWithKeyValues:arr[i]];
            [_selectedPhotos addObject:subModel];
            [idArray addObject:subModel.id];
        }
        [self.collectionView reloadData];
        
        /// 刷新
        if(self.sendSocketMesBlock) {
            self.sendSocketMesBlock(idArray);
        }
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)updateDataWithselectTag:(NSInteger)tag {
    DisPlayWindowModel *model = _selectedPhotos[tag];
    NSString *url = [NSString stringWithFormat:@"%@/products/%@/display-window/HIDE",GetLiveBroadcastURL,model.id];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:model.id forKey:@"id"];
    [dic setValue:@"HIDE" forKey:@"displayWindow"];
    [[RequestManager shareInstance]requestWithMethod:PUT url:url dict:dic finished:^(id request) {
        if(self.needReloadGoodsBlock) {
            self.needReloadGoodsBlock();
        }
        if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
            [_selectedPhotos removeObjectAtIndex:tag];
            [self.collectionView reloadData];
            if(self.sendSocketMesBlock) {
                NSMutableArray *dicArr = [NSMutableArray array];
                for (DisPlayWindowModel *subModel in _selectedPhotos) {
                    [dicArr addObject:subModel.id];
                }
                self.sendSocketMesBlock(dicArr);
            }
            return;
        }
        [_selectedPhotos removeObjectAtIndex:tag];
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tag inSection:0];
            [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self->_collectionView reloadData];
        }];
        
        /// 刷新
        if(self.sendSocketMesBlock) {
           NSMutableArray *dicArr = [NSMutableArray array];
            for (DisPlayWindowModel *subModel in _selectedPhotos) {
                [dicArr addObject:subModel.id];
            }
            self.sendSocketMesBlock(dicArr);
        }
        
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    
    [_collectionView reloadData];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
