//
//  ScrollChatView.m
//  ScrollChatView
//
//  Created by 陈红 on 2018/1/31.
//  Copyright © 2018年 陈红. All rights reserved.
//

#import "ScrollChatView.h"
#import "ScrollChatTextModel.h"

#import <pthread/pthread.h>

@interface ScrollChatView ()<UITableViewDelegate,UITableViewDataSource> {
    pthread_mutex_t _mutex; // 互斥锁
}
@property (nonatomic, strong) NSTimer     *timer;
/** 消息数组(数据源) */
@property (nonatomic, strong) NSMutableArray *imTableDataSoure;

/** 用于存储消息还未刷新到tableView的时候接收到的消息 */
@property (nonatomic ,strong) NSMutableArray *yxDataSource;
@property (nonatomic ,assign) NSInteger scrollIndex;



/** 是否处于爬楼状态 */
@property (nonatomic, assign) BOOL inPending;

@end

@implementation ScrollChatView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupUI];
        self.scrollIndex = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)action{
    [self tryToappendAndScrollToBottom];
}

#pragma mark -- 添加数据
- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    pthread_mutex_lock(&_mutex);
    [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScrollChatTextModel *contentModel = (ScrollChatTextModel *)obj;
        CGSize contentSize = [self sizeWithFont:[UIFont systemFontOfSize:14] width:self.frame.size.width - 30 content:contentModel.content];
        if (self.font) {
            contentSize = [self sizeWithFont:self.font width:self.frame.size.width - 30 content:contentModel.content];
        }
        ScrollChatTextModel *md = [[ScrollChatTextModel alloc]init];
        md.content = contentModel.content;
        md.nickname = contentModel.nickname.length>0?contentModel.nickname:@"未知";
        
        if(contentModel.type == 0) {
            md.yx_content = [NSString stringWithFormat:@"%@：进入了房间",md.nickname];
        }else if(contentModel.type == 1) {
            md.yx_content = [NSString stringWithFormat:@"%@：离开了房间",md.nickname];
        }else {
            md.yx_content = [NSString stringWithFormat:@"%@：%@",md.nickname,contentModel.content];
        }
        md.yx_height = contentSize.height + 20;
        if (self.padding>0) {
            md.yx_height = contentSize.height + self.padding*2;
        }
        [self.yxDataSource addObject:md];
    }];
    pthread_mutex_unlock(&_mutex);
}

- (void)setSpeed:(NSInteger)speed{
    _speed = speed;
    [_timer setFireDate:[NSDate distantFuture]];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(action) userInfo:nil repeats:YES];
}

//MARK: - UITableViewControllerDataSoure

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScrollChatTextModel *md = _imTableDataSoure[indexPath.row];
    return md.yx_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imTableDataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.transform = CGAffineTransformMakeScale(1, -1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = COLOR_FFFFFF;
    cell.textLabel.font  = [UIFont systemFontOfSize:14.f];
    ScrollChatTextModel *md = [self.imTableDataSoure objectAtIndex:indexPath.row];
    if (self.font) {
        cell.textLabel.font = self.font;
    }
    if (self.color) {
        cell.textLabel.textColor = self.color;
    }
    cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    cell.textLabel.layer.cornerRadius = 2.0f;
    cell.textLabel.layer.masksToBounds = YES;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
    [string addAttribute:NSForegroundColorAttributeName value:[self randomColor] range:NSMakeRange(0, md.nickname.length+1)];
    cell.textLabel.attributedText = string;
    self.scrollIndex ++;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScrollChatTextModel *md = _imTableDataSoure[indexPath.row];
    if ([self.yx_delegate respondsToSelector:@selector(scrollChatTextView:withIndex:withText:)]) {
        [self.yx_delegate scrollChatTextView:self withIndex:indexPath.row withText:md.yx_content];
    }
}

- (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() %255;
    NSInteger aGreenValue = arc4random() %255;
    NSInteger aBlueValue = arc4random() %255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}

//MARK: - 取消定时器
- (void)removeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setCureentText:(NSString *)cureentText{
    _cureentText = cureentText;
    [_timer setFireDate:[NSDate distantFuture]];
    [self.imTableDataSoure insertObject:cureentText atIndex:0];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
    [_timer setFireDate:[NSDate distantPast]];
}


- (void)setupUI {
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableHeaderView = [[UIView alloc]init];
    self.transform = CGAffineTransformMakeScale(1, -1);
}


- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width content:(NSString *)content{
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@"字"];
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size = CGSizeMake(width,CGFLOAT_MAX);
    return [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}


#pragma mark - 消息追加 ---- 先放着吧
- (void)addNewMsg:(ScrollChatTextModel *)msgModel {
    if (!msgModel) return;
    pthread_mutex_lock(&_mutex);
    // 消息不直接加入到数据源
    [self.yxDataSource addObject:msgModel];
    pthread_mutex_unlock(&_mutex);
    [self tryToappendAndScrollToBottom];
}

/** 添加数据并滚动到底部 */
- (void)tryToappendAndScrollToBottom {
    if (!self.inPending) {
        // 如果不处在爬楼状态，追加数据源并滚动到底部
        [self appendAndScrollToBottom];
    }
}

/** 追加数据源 */
- (void)appendAndScrollToBottom {
    if (self.yxDataSource.count < 1) {
        return;
    }
    pthread_mutex_lock(&_mutex);
    // 执行插入
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0;i<self.yxDataSource.count;i++) {
        ScrollChatTextModel *item  = self.yxDataSource[i];
        [indexPaths addObject:[NSIndexPath indexPathForRow:self.yxDataSource.count - i - 1 inSection:0]];
        [self.imTableDataSoure insertObject:item atIndex:0];
    }
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.yxDataSource removeAllObjects];
    [self scrollToBottom:YES];
    pthread_mutex_unlock(&_mutex);
}

/** 执行插入动画并滚动 */
- (void)scrollToBottom:(BOOL)animated {
    //    NSInteger s = [self numberOfSections];  //有多少组
    //    NSInteger r = [self numberOfRowsInSection:s-1]; //最后一组行
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];  //取最后一行数据
    [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:animated]; //滚动到最后一行
}


- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 5;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, theView.height-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}

#pragma mark -- LazyMethod
- (NSMutableArray*)imTableDataSoure {
    if (!_imTableDataSoure) {
        _imTableDataSoure = [NSMutableArray new];
    }
    return _imTableDataSoure;
}

- (NSMutableArray *)yxDataSource {
    if(!_yxDataSource) {
        _yxDataSource = [NSMutableArray array];
    }
    return _yxDataSource;
}

- (void)dealloc {
    
}


@end
