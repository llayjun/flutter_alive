//
//  AliLivePlayerViewController.m
//  Runner
//
//  Created by 张智慧 on 2020/2/21.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "AliLivePlayerViewController.h"
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>

@interface AliLivePlayerViewController ()
@property (nonatomic, strong) AliVcMediaPlayer *player;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation AliLivePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playView];
    [self.view addSubview:self.backBtn];
    [self playVideo];
    // Do any additional setup after loading the view.
}

- (void)playVideo {
    if (self.playerURL == nil) return;
    //1. 新建播放器
    self.player = [[AliVcMediaPlayer alloc]init];
    //2. 创建播放器,传入显示窗口
    [self.player create:self.playView];
    //3. 注册完成通知
    [self addPlayObserver];
    //4.设置网络超时时间
    self.player.timeout = 25000;
    //5.设置渲染的模式，适应全屏还是充满全屏
    self.player.scalingMode = scalingModeAspectFitWithCropping;
    //传入播放地址，初始化视频，准备播放
    [self.player prepareToPlay:[NSURL URLWithString:self.playerURL]];
    //开始播放
    [self.player play];
}

- (void)addPlayObserver {
   //成功的通知
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(OnVideoPrepared:) name:AliVcMediaPlayerLoadDidPreparedNotification object:self.player];
   //注册错误通知
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(OnVideoError:) name:AliVcMediaPlayerPlaybackErrorNotification object:self.player];
}

 - (void)OnVideoPrepared:(NSNotification *)notification {
    //收到完成通知后，获取视频的相关信息，更新界面相关信息

}

- (void)OnVideoError:(NSNotification *)notification {
    NSString* error_msg = @"未知错误";
    AliVcMovieErrorCode error_code = self.player.errorCode;
    switch (error_code) {
        case ALIVC_ERR_ILLEGALSTATUS:
            error_msg = @"非法的播放流程";
            break;
        case ALIVC_ERR_INVALID_INPUTFILE:
            error_msg = @"无法打开";
            break;
        case ALIVC_ERR_NO_INPUTFILE:
            error_msg = @"无输入文件";
            break;
        case ALIVC_ERR_DOWNLOAD_NO_NETWORK:
            error_msg = @"网络连接失败";
            break;
        case ALIVC_ERR_NO_SUPPORT_CODEC:
            error_msg = @"不支持的视频编码格式";
            break;
        case ALIVC_ERR_NO_VIEW:
            error_msg = @"无显示窗口";
            break;
        case ALIVC_ERR_NO_MEMORY:
            error_msg = @"内存不足";
            break;
        case ALIVC_ERR_DOWNLOAD_NETWORK_TIMEOUT:
            error_msg = @"网络超时";
            break;
        case ALIVC_ERR_UNKNOWN:
            error_msg = @"未知错误";
            break;
        default:
            break;
    }
    
    if(error_code > 500) {
        [self.player reset];
        return;
    }
    if(error_code == ALIVC_ERR_DOWNLOAD_NETWORK_TIMEOUT) {
        [self.player pause];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AliVcMediaPlayerLoadDidPreparedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AliVcMediaPlayerPlaybackErrorNotification object:nil];
}

- (void)back {
    [self.player destroy];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- LazyMethod
- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDE, HIGHT - Indicator_H)];
        _playView.backgroundColor = [UIColor clearColor];
    }
    return _playView;
}

- (UIButton *)backBtn {
    if(!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NSTATUS_H, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"whitenav_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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
