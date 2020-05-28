//
//  BeautySettingView.m
//  ocflutter
//
//  Created by 张智慧 on 2020/2/19.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "BeautySettingView.h"

@interface BeautySettingView ()
@property (nonatomic, copy) NSArray *labelNameArray;
@property (nonatomic, copy) NSArray *beautyDefaultValueArray;

@property (nonatomic, strong) AlivcLivePushConfig *config;
@end

@implementation BeautySettingView

- (instancetype)initWithFrame:(CGRect)frame configWith:(nonnull AlivcLivePushConfig *)config{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
        self.config = config;
        [self createBottomBtn];
        [self initialzie];
    }
    return self;
}

- (void)initialzie {
    self.labelNameArray = @[@"磨皮",@"美白",@"红润",@"腮红",@"瘦脸",@"收下巴",@"大眼"];
    self.beautyDefaultValueArray = @[@(self.config.beautyBuffing),@(self.config.beautyWhite),@(self.config.beautyRuddy),@(self.config.beautyCheekPink),@(self.config.beautyThinFace),@(self.config.beautyShortenFace),@(self.config.beautyBigEye)];
    CGFloat labelWidth = 50;
    CGFloat height = 30;
    CGFloat sliderWidth = self.width - labelWidth - 40;
    for(int i = 0;i<self.labelNameArray.count;i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, 30 + height*i , labelWidth, height);
        label.font = [UIFont systemFontOfSize:14.f];
        label.text = self.labelNameArray[i];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(CGRectGetMaxX(label.frame)+ 10, 30 + height*i, sliderWidth, height);
        [slider addTarget:self action:@selector(didMove:) forControlEvents:(UIControlEventValueChanged)];
        slider.maximumValue = 100;
        slider.minimumValue = 0;
        slider.value = [self.beautyDefaultValueArray[i] intValue];
        [self addSubview:slider];
    }
}


- (void)createBottomBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.width - 100)/2, self.height - 50, 100, 40)];
    [btn setTitle:@"开启/关闭美颜" forState:UIControlStateNormal];
    [btn setTitle:@"美颜" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)didClick:(UIButton *)sender {
    self.hidden = YES;
}

- (void)didMove:(UISlider *)slider {
    if([self.delegate respondsToSelector:@selector(didClickBeautyView:typeWith:valueWith:)]) {
        if(slider.tag == 0) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyBuffing valueWith:(int)slider.value];
        }else if(slider.tag == 1) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyWhite valueWith:(int)slider.value];
        }else if(slider.tag == 2) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyRuddy valueWith:(int)slider.value];
        }else if(slider.tag == 3) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyCheekPink valueWith:(int)slider.value];
        }else if(slider.tag == 4) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyThinFace valueWith:(int)slider.value];
        }else if(slider.tag == 5) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyShortenFace valueWith:(int)slider.value];
        }else if(slider.tag == 6) {
            [self.delegate didClickBeautyView:self typeWith:BeautyType_beautyBigEye valueWith:(int)slider.value];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
