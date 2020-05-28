//
//  UIViewController+BaseAction.m
//
//

#import "UIViewController+BaseAction.h"
#import <objc/runtime.h>

static void *PKey = &PKey;

@implementation UIViewController (BaseAction)

- (id)param{
    return objc_getAssociatedObject(self, &PKey);
}

- (void)setParam:(id)param{
    objc_setAssociatedObject(self, &PKey, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)pushVC:(NSString *)vcName animated:(BOOL)animated {
    [self pushVC:vcName param:nil animated:animated];
}

- (void)pushVC:(NSString *)vcName param:(id)param  animated:(BOOL)animated{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    UIViewController *vc = [class new];
    vc.param = param;
    [self.navigationController pushViewController:vc animated:animated];
}

/// 获取栈中最后一个vc
+ (UIViewController *)currentViewController{
    UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController ;
    return [self currentViewControllerFrom:rootVC];
}


+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *v = [nav.viewControllers lastObject];
        return [self currentViewControllerFrom:v];
    }else if([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabVC = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:[tabVC.viewControllers objectAtIndex:tabVC.selectedIndex]];
    }else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}


@end







