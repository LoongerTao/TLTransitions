//
//  TLAnimatorTemplate.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  自定义 Animator 参考模版

#import "TLAnimatorTemplate.h"

@implementation TLAnimatorTemplate

#pragma mark - TLAnimatorProtocol (必须实现的协议内容)
@synthesize transitionDuration;
@synthesize isPushOrPop;

- (TLDirection)directionForDragging; {
    return TLDirectionToRight; // 滑动方向
}


#pragma mark - init
/** 如果继承 UIPresentationController 就需要实现下面方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];

    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }

    return self;
}
*/

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    // 获取View Controller
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 获取View
    UIView *containerView = transitionContext.containerView;
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+ fromView/toView可能为nil
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    // 进场或出场判断（Presenting or dismiss）
    BOOL isPresenting;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresenting = (toIndex > fromIndex);
    }else {
        isPresenting = (toViewController.presentingViewController == fromViewController);
    }
    
    // 将要执行动画的view添加到transitionContext.containerView,(根据动画需求添加fromView和toView)
    if (isPresenting)
        [containerView addSubview:toView];
    
    // 要执行动画
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            // ...
        } else {
            // ...
        }
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        
        if (wasCancelled)
            [toView removeFromSuperview];
        
        // 动画结束必须调用- completeTransition: 告知动画结束
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
