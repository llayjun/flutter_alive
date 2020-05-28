#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"


@interface AppDelegate ()
<FlutterStreamHandler>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.backgroundColor = COLOR_FFFFFF;
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:UMengKey channel:nil];
    //    [MobClick setScenarioType:E_UM_GAME|E_UM_DPLUS];
    
//
    [[ChannelTool sharedManager]flutterBridgeOC];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];

    [self initEventChannelWithName:ShareChannelName];
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



//- (void)languageChanged:(NSNotification*)notification {
//    [ChannelTool sharedManager].primaryLanguageStr = [UIApplication sharedApplication].delegate.window.textInputMode.primaryLanguage;
//}


#pragma mark -- 原生->flutter
- (void)initEventChannelWithName:(NSString *)channelName {
    FlutterEventChannel *evenChannel = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:(FlutterViewController *)[UIViewController currentViewController]];
    [evenChannel setStreamHandler:self];
}


- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    if(events) {
        self.eventSink = events;
    }
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    //    self.eventSink = nil;
    return nil;
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = userActivity.webpageURL;
        if([webUrl.host isEqualToString:@"domain.com"]) {
            NSLog(@"**********");
        }else {
            [[UIApplication sharedApplication]openURL:webUrl];
        }
    }
    return YES;
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
