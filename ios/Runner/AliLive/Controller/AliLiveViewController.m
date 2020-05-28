//
//  AliLiveViewController.m
//  Runner
//
//  Created by 张智慧 on 2020/2/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "AliLiveViewController.h"

#import <AlivcLivePusher/AlivcLivePusher.h>
#import <AlivcLibFace/AlivcLibFaceManager.h>
#import <ALivcLibBeauty/AlivcLibBeautyManager.h>

#import "AliLiveConfigView.h"
#import "BeautySettingView.h"
#import "ScrollChatView.h"
#import "BottomChatView.h"
#import "SettingView.h"
#import "ClarityActionView.h"
#import "BoardWillStopView.h"
#import "BoardReadyView.h"
#import "BoardLiveDataView.h"
#import "AllGoodsListView.h"
#import "GoodsonWindowView.h"
#import "ShareBoardView.h"
#import "SaveSharePicView.h"
#import "StatusView.h"
#import "PromptView.h"

#import "ScrollChatTextModel.h"

#import "AppDelegate.h"

@interface AliLiveViewController ()
<AlivcLivePusherInfoDelegate,
AlivcLivePusherErrorDelegate,
AlivcLivePusherNetworkDelegate,
AlivcLivePusherCustomFilterDelegate,
AlivcLivePusherCustomDetectorDelegate,
AliLiveConfigViewDelegate,
BeautySettingViewDelegate,
ScrollChatViewDelegate,
BottomChatViewDelegate
>
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) AlivcLivePusher *livePusher;
@property (nonatomic, assign) BOOL isUseAsyncInterface;
@property (nonatomic, strong) AliLiveConfigView *configView;
@property (nonatomic, strong) BeautySettingView *beautySettingView;
@property (nonatomic, strong) ScrollChatView *chatView;
@property (nonatomic, strong) BottomChatView *bottomView;
@property (nonatomic, strong) AllGoodsListView *goodListView;
@property (nonatomic, strong) GoodsonWindowView *onwindowView;
@property (nonatomic, strong) StatusView *statusView;
@property (nonatomic, strong) PromptView *promptView;
@property (nonatomic, strong) SocketManager *manager;
@property (nonatomic, strong) SocketIOClient *socket;
@property (nonatomic, strong) NSMutableArray *chatListArray;
@property (nonatomic, strong) NSMutableDictionary *sendDic;




@property (nonatomic, copy) NSString *pushURL;
@property (nonatomic, copy) NSString *sharePosterLive;
@property (nonatomic, copy) NSString *sharePosterPending; /// 预
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *favNumStr;
@property (nonatomic, assign) BOOL isFront;


@end

@implementation AliLiveViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self destoryPusher];
    [self.chatView removeTimer];
    [UIApplication sharedApplication].idleTimerDisabled = NO; /// 自动锁屏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self initLive];
    [self setBaseConfig];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)initialize {
    self.view.backgroundColor = COLOR_FFFFFF;
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NSTATUS_H, 45, 40)];
    [self.backBtn setImage:[UIImage imageNamed:@"whitenav_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    self.isFront = YES;
}

- (void)back:(id)sender {
    if (self.livePusher && self.livePusher.isPushing) {
        [BoardWillStopView showIdWith:self.boardcastId favWith:self.favNumStr resultWith:^{
            /// 调用结束直播接口
            [self closeBoardCast];
        }];
        return;
    }
    [self hideOtherView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- RequestMethod
- (void)requestData {
    NSString *url = [NSString stringWithFormat:@"%@/%@",GetLiveBroadcastURL,self.boardcastId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.boardcastId forKey:@"id"];
    [[RequestManager shareInstance]requestWithMethod:GET url:url dict:nil finished:^(id request) {
        AliLiveModel *model = [AliLiveModel mj_objectWithKeyValues:request];
        model.squareCoverModel  = [SquareCoverModel mj_objectWithKeyValues:model.squareCover];
        self.sendDic = [model.squareCover mutableCopy];
        if([[self.sendDic allKeys]containsObject:@"name"]) {
            self.sendDic[@"name"] = model.title;
        }
        self.pushURL = model.pushUrl;
        self.sharePosterLive = model.sharePosterLive;
        self.sharePosterPending = model.sharePosterPending;
        self.roomName = model.title;
        self.roomID = model.id;
        self.nickname = model.nickname;
        [self.bottomView.bottomNumBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)model.products.count] forState:UIControlStateNormal];
    } failed:^(NSError *error) {
        
    }];
}

- (void)closeBoardCast {
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/closure",GetLiveBroadcastURL,self.boardcastId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.boardcastId forKey:@"id"];
    [ZZProgress showWithStatus:@"正在停止..."];
    [[RequestManager shareInstance]requestWithMethod:PUT url:urlStr dict:dic finished:^(id request) {
        int ret =  [self stopPush];
        if(ret != 0) {
            [ZZProgress showErrorWithStatus:@"退出直播失败，可能出错了哦～"];
        }
        [self.socket disconnect];
        self.flutterResult(@"over");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failed:^(NSError *error) {
        [ZZProgress showErrorWithStatus:@"退出直播失败，可能出错了哦～"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

#pragma mark -- chatRoom
- (void)socketContact {
    //    NSURL* url = [[NSURL alloc] initWithString:@"wss://chat.test.9daye.cn"];
    //     self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"forceWebsockets": @YES,@"websocket":@YES,@"secure":@YES}];
    NSURL* url = [[NSURL alloc] initWithString:SocketURL];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"forceWebsockets": @YES,@"websocket":@YES,@"secure":@YES}];
    self.socket = self.manager.defaultSocket;
    __weak typeof(self) weakSelf = self;
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        weakSelf.statusView.statusLab.text = @"直播中";
        weakSelf.statusView.favnumLab.hidden = NO;
        /// 加入聊天室可以看到聊天内容
        [weakSelf.socket emit:@"join" with:@[@{@"jwt":[RequestManager shareInstance].token,@"nickname":weakSelf.nickname,@"roomId":weakSelf.roomID,@"roomName":weakSelf.roomName}]];
    }];
    
    [self.socket on:@"auth" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
    }];
    
    [self.socket on:@"like" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        /// 点赞人数
        ScrollChatTextModel *subModel = [ScrollChatTextModel mj_objectWithKeyValues:data.firstObject];
        weakSelf.favNumStr = subModel.content;
        weakSelf.statusView.favnumLab.text = [NSString stringWithFormat:@"%@个赞",weakSelf.favNumStr];
    }];
    
    [self.socket on:@"join" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        /// 加入聊天室
    }];
    
    [self.socket on:@"enter" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        ///  进入房间
        [weakSelf reloadChatListWith:data typeWith:0];
    }];
    
    [self.socket on:@"leave" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        ///  离开房间
        //        [weakSelf reloadChatListWith:data typeWith:1];
    }];
    
    [self.socket on:@"view" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        ///  谁去买
        [weakSelf reloadChatListWith:data typeWith:3];
    }];
    
    [self.socket on:@"chat" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        ///  新消息
        [weakSelf reloadChatListWith:data typeWith:2];
    }];
}

- (void)reloadChatListWith:(NSArray *)array typeWith:(NSInteger)type{
    if(type == 0 || type == 1 || type == 3) {
        for (NSDictionary *dic in array) {
            ScrollChatTextModel *subModel = [ScrollChatTextModel mj_objectWithKeyValues:dic];
            if(![subModel.nickname isEqualToString:self.nickname]) {
                NSString *detailStr = (type == 0)?[NSString stringWithFormat:@"%@进入了房间",subModel.nickname]:(type == 1)?[NSString stringWithFormat:@"%@离开了房间",subModel.nickname]:[NSString stringWithFormat:@"%@正在去买",subModel.nickname];
                self.promptView.width = [ClassMethod sizeText:detailStr font:[UIFont systemFontOfSize:12] limitHeight:25].width>=WIDE-44?WIDE-44:[ClassMethod sizeText:detailStr font:[UIFont systemFontOfSize:12] limitHeight:25].width+20;
                [self.promptView showWith:detailStr];
            }
        }
    }else {
        [self.chatListArray removeAllObjects];
        for (NSDictionary *dic in array) {
            ScrollChatTextModel *subModel = [ScrollChatTextModel mj_objectWithKeyValues:dic];
            subModel.type = type;
            [self.chatListArray addObject:subModel];
        }
        self.chatView.dataList = self.chatListArray;
    }
    
}

- (void)initLive {
    self.pushConfig = [[AlivcLivePushConfig alloc]init];
    self.pushConfig.resolution = AlivcLivePushResolution540P;
    self.pushConfig.cameraType = AlivcLivePushCameraTypeFront;
    self.pushConfig.previewMirror = true;
    self.pushConfig.pushMirror = true;
    //    self.pushConfig.orientation = AlivcLivePushOrientationPortrait;
    //    self.pushConfig.previewDisplayMode =  ALIVC_LIVE_PUSHER_PREVIEW_SCALE_FILL;
}

- (void)setBaseConfig {
    /// 如果不需要退后台继续推流，可以参考这套退后台通知的实现。
    //    [self addBackgroundNotifications];
    [self initLive];
    [self setupSubviews];
    int ret = [self setupPusher];
    if (ret != 0) {
        return;
    }
    ret = [self startPreview];
    if (ret != 0) {
        return;
    }
    [self socketContact];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.pushConfig.orientation == AlivcLivePushOrientationLandscapeLeft) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else if (self.pushConfig.orientation == AlivcLivePushOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (int)setupPusher {
    self.pushConfig.externMainStream = false; /// 自定义流
    self.livePusher = [[AlivcLivePusher alloc] initWithConfig:self.pushConfig];
    [self.livePusher setLogLevel:(AlivcLivePushLogLevelDebug)];
    if (!self.livePusher) {
        return -1;
    }
    [self.livePusher setInfoDelegate:self];
    [self.livePusher setErrorDelegate:self];
    [self.livePusher setNetworkDelegate:self];
    [self.livePusher setCustomFilterDelegate:self];
    [self.livePusher setCustomDetectorDelegate:self];
    return 0;
}

/// 销毁推流
- (void)destoryPusher {
    if (self.livePusher) {
        [self.livePusher destory];
    }
    self.livePusher = nil;
}

///  开始预览
- (int)startPreview {
    if (!self.livePusher) {
        return -1;
    }
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher startPreviewAsync:self.previewView];
    } else {
        // 使用同步接口
        ret = [self.livePusher startPreview:self.previewView];
    }
    return ret;
}

/// 停止预览
- (int)stopPreview {
    if (!self.livePusher) {
        return -1;
    }
    int ret = [self.livePusher stopPreview];
    return ret;
}


/// 开始推流
- (int)startPush {
    if (!self.livePusher) {
        return -1;
    }
    int ret = 0;
    
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher startPushWithURLAsync:self.pushURL];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher startPushWithURL:self.pushURL];
    }
    return ret;
}


/// 停止推流
- (int)stopPush {
    if (!self.livePusher) {
        return -1;
    }
    int ret = [self.livePusher stopPush];
    return ret;
}

/// 暂停推流
- (int)pausePush {
    if (!self.livePusher) {
        return -1;
    }
    int ret = [self.livePusher pause];
    return ret;
}

/// 恢复推流
- (int)resumePush {
    if (!self.livePusher) {
        return -1;
    }
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher resumeAsync];
    } else {
        // 使用同步接口
        ret = [self.livePusher resume];
    }
    return ret;
}


/// 重新推流
- (int)restartPush {
    if (!self.livePusher) {
        return -1;
    }
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher restartPushAsync];
    } else {
        // 使用同步接口
        ret = [self.livePusher restartPush];
    }
    return ret;
}

- (void)reconnectPush {
    if (!self.livePusher) {
        return;
    }
    [self.livePusher reconnectPushAsync];
}

#pragma mark -- AlivcLivePusherErrorDelegate
- (void)onSystemError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
}

- (void)onSDKError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
}

#pragma mark -- AlivcLivePusherNetworkDelegate
- (void)onConnectFail:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
}

- (void)onSendDataTimeout:(AlivcLivePusher *)pusher {
}

- (void)onSendSeiMessage:(AlivcLivePusher *)pusher {
}

- (void)onConnectRecovery:(AlivcLivePusher *)pusher {
}

- (void)onNetworkPoor:(AlivcLivePusher *)pusher {
}

- (void)onReconnectStart:(AlivcLivePusher *)pusher {
}

- (void)onReconnectSuccess:(AlivcLivePusher *)pusher {
}

- (void)onConnectionLost:(AlivcLivePusher *)pusher {
    
}

- (void)onReconnectError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    /// 805439750 禁止直播
    if(error.errorCode == 805439750) {
        @WeakSelf(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZZProgress showErrorWithStatus:@"您的直播间已中断！"];
            [weakSelf stopPush];
            [weakSelf.socket disconnect];
            weakSelf.flutterResult(@"over");
            [weakSelf hideOtherView];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    }
    
    
}

- (NSString *)onPushURLAuthenticationOverdue:(AlivcLivePusher *)pusher {
    if(!self.livePusher.isPushing) { ///  推流URL的鉴权时长即将过期
        /// 获取新的推流地址
    }
    return self.pushURL;
}

- (void)onPacketsLost:(AlivcLivePusher *)pusher {
    
}

#pragma mark -- AlivcLivePusherInfoDelegate
- (void)onPreviewStarted:(AlivcLivePusher *)pusher {
}

- (void)onPreviewStoped:(AlivcLivePusher *)pusher {
}

- (void)onPushStarted:(AlivcLivePusher *)pusher {
}

- (void)onPushPaused:(AlivcLivePusher *)pusher {
}

- (void)onPushResumed:(AlivcLivePusher *)pusher {
}

- (void)onPushStoped:(AlivcLivePusher *)pusher {
}

- (void)onFirstFramePreviewed:(AlivcLivePusher *)pusher {
}

- (void)onPushRestart:(AlivcLivePusher *)pusher {
}


#pragma mark -- AlivcLivePusherCustomFilterDelegate
- (void)onCreate:(AlivcLivePusher *)pusher context:(void*)context
{
    [[AlivcLibBeautyManager shareManager] create:context];
}

- (void)updateParam:(AlivcLivePusher *)pusher buffing:(float)buffing whiten:(float)whiten pink:(float)pink cheekpink:(float)cheekpink thinface:(float)thinface shortenface:(float)shortenface bigeye:(float)bigeye
{
    [[AlivcLibBeautyManager shareManager] setParam:buffing whiten:whiten pink:pink cheekpink:cheekpink thinface:thinface shortenface:shortenface bigeye:bigeye];
}

- (void)switchOn:(AlivcLivePusher *)pusher on:(bool)on
{
    [[AlivcLibBeautyManager shareManager] switchOn:on];
}

- (int)onProcess:(AlivcLivePusher *)pusher texture:(int)texture textureWidth:(int)width textureHeight:(int)height extra:(long)extra
{
    return [[AlivcLibBeautyManager shareManager] process:texture width:width height:height extra:extra];
}

- (void)onDestory:(AlivcLivePusher *)pusher
{
    [[AlivcLibBeautyManager shareManager] destroy];
}

#pragma mark -- AlivcLivePusherCustomDetectorDelegate
- (void)onCreateDetector:(AlivcLivePusher *)pusher
{
    [[AlivcLibFaceManager shareManager] create];
}

- (long)onDetectorProcess:(AlivcLivePusher *)pusher data:(long)data w:(int)w h:(int)h rotation:(int)rotation format:(int)format extra:(long)extra
{
    return [[AlivcLibFaceManager shareManager] process:data width:w height:h rotation:rotation format:format extra:extra];
}

- (void)onDestoryDetector:(AlivcLivePusher *)pusher
{
    [[AlivcLibFaceManager shareManager] destroy];
}

#pragma mark -- 退后台停止推流的实现方案
- (void)addBackgroundNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    
    if (!self.livePusher) {
        return;
    }
    // 如果退后台不需要继续推流，则停止推流
    if ([self.livePusher isPushing]) {
        [self.livePusher stopPush];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (!self.livePusher) {
        return;
    }
    [self.livePusher startPushWithURLAsync:self.pushURL];
}

#pragma mark -- UI
- (void)setupSubviews {
    [self.view addSubview: self.previewView];
    [self.view bringSubviewToFront:self.backBtn];
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.configView];
    [self.view addSubview:self.bottomView];
    self.onwindowView.cycGoodsView.lbId = self.boardcastId;
}

#pragma mark -- AliLiveConfigViewDelegate
- (void)didClickView:(AliLiveConfigView *)configView typeWith:(ConfigType)currentType {
    if (!self.livePusher) {
        return;
    }
    if(currentType == ConfigType_camera) { /// 旋转摄像头
        [self.livePusher switchCamera];
        self.isFront = !self.isFront;
        [self.livePusher setPreviewMirror:self.isFront];
        [self.livePusher setPushMirror:self.isFront];
        
    }else if(currentType == ConfigType_setting) {
        @WeakSelf(self);
        [SettingView showWith:self.pushConfig.beautyOn blockWith:^(SettingType settingType) {
            if(settingType == SettingType_beauty) {
                weakSelf.pushConfig.beautyOn = !weakSelf.pushConfig.beautyOn;
                [weakSelf.livePusher setBeautyOn:weakSelf.pushConfig.beautyOn];
            }else {
                ClarityActionView *actionView = [ClarityActionView createViewFromNib]; /// 分辨率
                actionView.is540 = ( weakSelf.pushConfig.resolution == AlivcLivePushResolution540P)?YES:NO;
                actionView.clarityBlock = ^(NSInteger type) {
                    if(type == 1) { /// 清晰
                        weakSelf.pushConfig.resolution = AlivcLivePushResolution540P; /// 默认分辨率
                    }else {
                        weakSelf.pushConfig.resolution = AlivcLivePushResolution360P;
                    }
                    [weakSelf.livePusher setResolution:weakSelf.pushConfig.resolution];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                };
                TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:actionView preferredStyle:TYAlertControllerStyleActionSheet];
                alertVC.backgoundTapDismissEnable = YES;
                [self presentViewController:alertVC animated:YES completion:nil];
            }
            if([[UIApplication sharedApplication].keyWindow viewWithTag:2222]) {
                [[[UIApplication sharedApplication].keyWindow viewWithTag:2222] removeFromSuperview];
            }
        }];
    }
    self.configView.pushConfig = self.pushConfig;
    
    //    else if(currentType == ConfigType_flash) {
    //        self.pushConfig.flash = !self.pushConfig.flash;
    //        [self.livePusher setFlash:self.pushConfig.flash];
    //    }else if(currentType == ConfigType_skin) {
    //        self.beautySettingView.hidden = NO;
    //        self.pushConfig.beautyOn = !self.pushConfig.beautyOn;
    //        [self.livePusher setBeautyOn:self.pushConfig.beautyOn];
    //    }
}


#pragma mark -- BeautySettingViewDelegate
- (void)didClickBeautyView:(BeautySettingView *)settingView typeWith:(BeautyType)type valueWith:(int)value {
    /*
     @"磨皮",@"美白",@"红润",@"腮红",@"瘦脸",@"收下巴",@"大眼"
     */
    if (!self.livePusher) {
        return;
    }
    if(type == BeautyType_beautyBuffing) {
        [self.livePusher setBeautyBuffing:value];
    }else if(type == BeautyType_beautyWhite) {
        [self.livePusher setBeautyWhite:value];
    }else if(type == BeautyType_beautyRuddy) {
        [self.livePusher setBeautyRuddy:value];
    }else if(type == BeautyType_beautyCheekPink){
        [self.livePusher setBeautyRuddy:value];
    }else if(type == BeautyType_beautyThinFace) {
        [self.livePusher setBeautyThinFace:value];
    }else if(type == BeautyType_beautyShortenFace) {
        [self.livePusher setBeautyShortenFace:value];
    }else { /// 大眼
        [self.livePusher setBeautyBigEye:value];
    }
}

#pragma mark -- ScrollChatViewDelegate
- (void)scrollChatTextView:(ScrollChatView *)view withIndex:(NSInteger)index withText:(NSString *)text{
    
}

#pragma mark -- BottomChatViewDelegate
- (void)didClickInteractionView:(BottomChatView *)chatView typeWith:(InteractionType)currentType {
    if (!self.livePusher) {
        return;
    }
    if(currentType == InteractionType_board) { /// 开启直播 关闭直播
        @WeakSelf(self);
        if([chatView viewWithTag:100]) {
            UIButton *btn = (UIButton *)[chatView viewWithTag:100];
            if(btn.selected) {
                [BoardWillStopView showIdWith:weakSelf.boardcastId favWith:self.favNumStr resultWith:^{
                    /// 调用结束直播接口
                    [weakSelf closeBoardCast];
                }];
                
            }else {
                [BoardReadyView showWith:^{
                    if(weakSelf.pushURL.length > 0) {
                        int ret = [weakSelf startPush];
                        if(ret != 0) {
                            [ZZProgress showErrorWithStatus:@"开启失败，请再试一次哦～"];
                            btn.selected = NO;
                            btn.backgroundColor  = COLOR_F95259;
                            return;
                        }
                        [weakSelf.socket connect];
                    }
                }];
            }
        }
        
    }else if(currentType == InteractionType_data){
        if(self.livePusher.isPushing) {
            [BoardLiveDataView showWithBoardId:self.boardcastId];
        }else {
            [ZZProgress showErrorWithStatus:@"直播还未开始"];
        }
        
    }else if(currentType == InteractionType_goodlist) {
        [self.goodListView showWithlbId:self.boardcastId];
        [self.onwindowView show];
    }else if(currentType == InteractionType_share) {
        ShareBoardView *boardView = [ShareBoardView createViewFromNib];
        @weakify(self);
        [[boardView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [[boardView.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.eventSink(self.sendDic);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [[boardView.savePicBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.livePusher.isPushing) {
                [SaveSharePicView showSaveSharePicViewWith:self.sharePosterLive];
            }else {
                [SaveSharePicView showSaveSharePicViewWith:self.sharePosterPending];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:boardView preferredStyle:TYAlertControllerStyleActionSheet];
        alertVC.backgoundTapDismissEnable = YES;
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

//▪ BasicMessageChannel：用于传递字符串和半结构化的信息。
//▪ MethodChannel：用于传递方法调用（method invocation）
//▪ EventChannel: 用于数据流（event streams）的通信。

#pragma mark - LazyMethod
- (UIView *)previewView {
    if (!_previewView) {
        _previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDE, HIGHT - Indicator_H)];
        _previewView.backgroundColor = [UIColor clearColor];
    }
    return _previewView;
}

- (AliLiveConfigView *)configView {
    if(!_configView) {
        _configView = [[NSBundle mainBundle]loadNibNamed:@"AliLiveConfigView" owner:self options:nil].lastObject;
        _configView.frame = CGRectMake(WIDE - 280, NSTATUS_H, 280, 44);
        _configView.delegate = self;
        [_configView initConfigWith:self.pushConfig];
    }
    return _configView;
}

- (BeautySettingView *)beautySettingView {
    if(!_beautySettingView) {
        _beautySettingView = [[BeautySettingView alloc]initWithFrame:CGRectMake(15, HIGHT - 300 - Indicator_H, WIDE - 30, 300) configWith:self.pushConfig];
        _beautySettingView.delegate = self;
        [self.view addSubview:_beautySettingView];
    }
    return _beautySettingView;
}

- (ScrollChatView *)chatView {
    if(!_chatView) {
        _chatView = [[ScrollChatView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptView.frame), WIDE - 100, HIGHT - CGRectGetMaxY(self.promptView.frame) - 60 - Indicator_H)];
        _chatView.speed = 3;
        _chatView.padding = 5;
        _chatView.yx_delegate =self;
        [self.view addSubview:_chatView];
    }
    return _chatView;
}

- (BottomChatView *)bottomView {
    if(!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:@"BottomChatView" owner:self options:nil].lastObject;
        _bottomView.x = 0;
        _bottomView.y = HIGHT - Indicator_H - 60;
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (AllGoodsListView *)goodListView {
    if(!_goodListView) {
        _goodListView = [[AllGoodsListView alloc]initWithFrame:CGRectMake(0, HIGHT, WIDE, HIGHT/2)];
        _goodListView.tag = 1111;
        @WeakSelf(self);
        _goodListView.needloadWindowBlock = ^{
            weakSelf.onwindowView.cycGoodsView.lbId = weakSelf.boardcastId;
        };
        [self.view addSubview:_goodListView];
    }
    return _goodListView;
}

- (GoodsonWindowView *)onwindowView {
    if(!_onwindowView) {
        _onwindowView = [[NSBundle mainBundle]loadNibNamed:@"GoodsonWindowView" owner:self options:nil].lastObject;
        _onwindowView.x = 12;
        _onwindowView.y = 50 + NAV_H;
        @WeakSelf(self);
        _onwindowView.cycGoodsView.needReloadGoodsBlock = ^{
            [weakSelf.goodListView reloadData];
        };
        _onwindowView.cycGoodsView.needOpenWindowBlock = ^{
            [weakSelf.goodListView showWithlbId:weakSelf.boardcastId];
        };
        _onwindowView.cycGoodsView.sendSocketMesBlock = ^(NSArray *arr) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:arr forKey:@"updateProduct"];
            [weakSelf.socket emit:@"notice" with:@[[NSString dictionaryToJSONString:dic]]];
        };
        [self.view addSubview:_onwindowView];
    }
    return _onwindowView;
}

- (NSMutableArray *)chatListArray {
    if(!_chatListArray) {
        _chatListArray = [NSMutableArray array];
    }
    return _chatListArray;
}

- (StatusView *)statusView {
    if(!_statusView) {
        _statusView = [[StatusView alloc]initWithFrame:CGRectMake(12, NAV_H, 100, 45)];
    }
    return _statusView;
}

- (PromptView *)promptView {
    if(!_promptView) {
        _promptView = [[PromptView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.onwindowView.frame)+3, 130, 25)];
        [self.view addSubview:_promptView];
    }
    return _promptView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self.view viewWithTag:1111]) {
        if(self.goodListView.y <= HIGHT/2) {
            [self.goodListView dismiss];
        }
    }
    [self hideOtherView];
}

- (void)hideOtherView {
    if([[UIApplication sharedApplication].keyWindow viewWithTag:2222]) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:2222] removeFromSuperview];
    }
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
