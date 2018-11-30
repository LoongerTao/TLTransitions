//
//  TLAnimatorTemplate.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  自定义 Animator 参考模版


#import "TLAnimatorTemplate.h"

#ifdef NO_BUILDING // 本文件不参与编译
@implementation TLAnimatorTemplate

#pragma mark - TLAnimatorProtocol (必须实现的协议内容)
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (TLDirection)interactiveDirectionOfPop {
    return TLDirectionToRight; // 滑动方向
}

#pragma mark - 可选协议
/*
- (CGFloat)percentOfFinishInteractiveTransition {
    return 0.5;
}
*/

#pragma mark - UIViewControllerAnimatedTransitioning
// 动画时间
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    // 获取View Controller
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 获取View
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+
        // 这种情况下 fromView/toView可能为nil，但是是安全的，建议的获取方法
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        // 强制获取，保证能获取到View
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    // 进场或出场判断（Presenting/Push or dismiss/pop）
    BOOL isPresenting;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresenting = (toIndex > fromIndex);
    }else {
        isPresenting = (toViewController.presentingViewController == fromViewController);
    }
    
    /** containerView：所有动画都在它上面执行，需要执行动画的view都需要添加到其上（作为subview）(可根据动画需求添加fromView和toView)
     *
     *  注意：随意添加或移除fromView或toView到containerView 是一件危险的事情。可能导致一系列的异常
     *
     *  所以建议的操作（个人经验）：
     *  1. 先将转场必须的view添加到containerView上，并根据动画需求进行隐藏，动画结束后在显示。也可以在动画结束后再将转场必须的view添加到containerView上。注意：fromView和toView可能默认就已经添加到containerView上，所以需要做好显示和隐藏工作
     *  2. 动画则全部利用UIView+UISnapshotting分类提供的方法对要进行动画的view复制一份快照，并对快照包装。然后用快照来代替fromView和toView执行动画。
     *  快照API：`- snapshotViewAfterScreenUpdates:`、`- resizableSnapshotViewFromRect: afterScreenUpdates: withCapInsets:`
     *  一些特俗情况下快照是获取不成功的，需根据情况变通
     */
    UIView *containerView = transitionContext.containerView;
    if(isPresenting || (!isPresenting && self->isPushOrPop)) { // 保证顺利转场的视图添加
        [containerView addSubview:toView];
    }
   
    // 将快照添加到containerView
    
    // 此处对快照views进行包装，如添加圆角、阴影、遮照（模糊）...
    
    // 此处可以设置转场开始，views的最终样式（frame，transform,...）
    
    // 要执行动画
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            // ...
        } else {
            // ...
        }
        
    } completion:^(BOOL finished) {
        // 现场还原操作（移除快照views、显示toView和fromView）
        toView.hidden = NO;
        fromView.hidden = NO;
        
        // 此处可以设置，toView的最终样式（frame，transform,...）
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled){
//            [toView removeFromSuperview]; // 官方demo说特定情况需要调用这句，解决一些BUG，（本人没有遇到过这种情况），所以还是根据实际情况决定
        }
        
        // 动画结束必须调用- completeTransition: 告知动画结束
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end

#endif

