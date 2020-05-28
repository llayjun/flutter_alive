//
//  SaveSharePicView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/24.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "SaveSharePicView.h"
#import <Photos/Photos.h>

@interface SaveSharePicView ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation SaveSharePicView


+ (void)showSaveSharePicViewWith:(NSString *)url {
    SaveSharePicView *picView = [[NSBundle mainBundle]loadNibNamed:@"SaveSharePicView" owner:self options:nil].lastObject;
    picView.frame = CGRectMake(0, 0, WIDE, HIGHT);
    picView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        picView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [UIApplication.sharedApplication.keyWindow addSubview:picView];
    
    [picView.imgView sd_setImageWithURL:[NSURL URLWithString:url]]; /// 暂不设置占位图


   
}

- (IBAction)saveClick:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [ZZProgress showSuccessWithStatus:@"保存图片失败"];
    }else{
        [ZZProgress showSuccessWithStatus:@"保存图片成功"];
    }
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
