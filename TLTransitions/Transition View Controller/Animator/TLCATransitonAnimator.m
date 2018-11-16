//
//  TLCATranstionAndCustomAnimator.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/14.
//  Copyright © 2018 故乡的云. All rights reserved.
//  CATranstion Animator

#import "TLCATransitonAnimator.h"

@interface TLCATransitonAnimator ()<CAAnimationDelegate>
{
    id<UIViewControllerContextTransitioning> _transitionContext;
    BOOL _isPresenting;
}

@end

@implementation TLCATransitonAnimator

#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;

- (TLDirection)directionForDragging; {
    return _directionOfDismiss;
}

#pragma mark - init
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

+ (instancetype)animatorWithPresentedViewController:(UIViewController *)presentedViewController
                           presentingViewController:(UIViewController *)presentingViewController
                                     transitionType:(CATransitionType)tType
                                          direction:(TLDirection)direction
                            transitionTypeOfDismiss:(CATransitionType)tTypeOfDismiss
                                 directionOfDismiss:(TLDirection)directionOfDismiss
{
    TLCATransitonAnimator *animator = [[self alloc] initWithPresentedViewController:presentedViewController presentingViewController: presentingViewController];
    animator.tType = tType;
    animator.direction = direction;
    animator.tTypeOfDismiss = tTypeOfDismiss;
    animator.directionOfDismiss = directionOfDismiss;
    return animator;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
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
    
    BOOL isPresenting;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresenting = (toIndex > fromIndex);
    }else {
        isPresenting = (toViewController.presentingViewController == fromViewController);
    }
    
    _isPresenting = isPresenting;
    if (isPresenting)
        [containerView addSubview:toView];
    
    if (!isPresenting) { // dismiss
        if (self.isPushOrPop) {
            [containerView addSubview:toView];
        }else {
            // 对于dismiss动画，我们希望From视图滑开，显示toView。
            // 因此，我们必须将toView放在containerView上，下面则是创建一个toView快照，并将其当作toView
            UIImage *toViewSnapshot = snapshotImage(toViewController.view);
            toView = [[UIImageView alloc] initWithImage:toViewSnapshot];
            [containerView addSubview:toView];
            toView.tag = 100;
        }
    }
    
    _transitionContext = transitionContext;
    CATransition *animation = [CATransition animation];
    animation.duration = [self transitionDuration:transitionContext];
    //        NSString *fName = isPresenting ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut;
    //        animation.timingFunction = [CAMediaTimingFunction functionWithName:fName];
    animation.type = isPresenting ? self.tType : self.tTypeOfDismiss;
    animation.subtype = getSubtype(isPresenting ? self.direction : self.directionOfDismiss);
    animation.delegate = self;
    animation.repeatCount = 1;
    
    UIView *targetView = _isPresenting ? toView : fromView; // 目标
    [targetView.window.layer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!_isPresenting) {
        UIView *view = [_transitionContext.containerView viewWithTag:100];
        if (view) {
            [view removeFromSuperview];
        }
    }
    if(flag){
        BOOL wasCancelled = [_transitionContext transitionWasCancelled];
        [_transitionContext completeTransition:!wasCancelled];
        _transitionContext = nil;
    }else {
        [_transitionContext completeTransition:NO];
        _transitionContext = nil;
    }
}



@end
