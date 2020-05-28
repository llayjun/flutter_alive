//
//  UIViewController+BaseAction.h
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (BaseAction)
@property (nonatomic, strong) id param;
- (void)pushVC:(NSString *)vcName animated:(BOOL)animated;
- (void)pushVC:(NSString *)vcName param:(id)param animated:(BOOL)animated;
//获取栈中最后一个vc
+ (UIViewController *)currentViewController;
+ (UIViewController *)currentViewControllerFrom:(UIViewController *)viewController;



@end
