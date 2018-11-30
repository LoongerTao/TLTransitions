//
//  TLCustomAnimator.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  Custom Animator

#import "TLCustomAnimator.h"

@implementation TLCustomAnimator

#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (TLDirection)interactiveDirectionOfPop {
    return TLDirectionToRight;
}

+ (instancetype)animatorWithAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation {
    TLCustomAnimator *animator = [self new];
    animator.animation = animation;
    
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
    
    BOOL isPresentingOrPush;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresentingOrPush = (toIndex > fromIndex);
    }else {
        isPresentingOrPush = (toViewController.presentingViewController == fromViewController);
    }
    
    if (isPresentingOrPush) {
        toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    }
    
    if (self.animation) {
         self.animation(transitionContext, isPresentingOrPush);
    }else {
        NSAssert(NO, @"TLCustomAnimator： animation属性没有赋值");
    }
}

@end


