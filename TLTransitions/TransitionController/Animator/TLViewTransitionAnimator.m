//
//  TLViewTransitionAnimator.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLViewTransitionAnimator.h"

@implementation TLViewTransitionAnimator

#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;

- (TLDirection)directionForDragging; {
    return TLDirectionToRight;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    BOOL isPresentingOrPush;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresentingOrPush = (toIndex > fromIndex);
    }else {
        isPresentingOrPush = (toViewController.presentingViewController == fromViewController);
    }
    
    if (!isPushOrPop) {
        if (isPresentingOrPush) {
            fromView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
        }else {
            toView = [toViewController.view snapshotViewAfterScreenUpdates:NO];
        }
    }
    
    if (isPresentingOrPush) {
        [containerView addSubview:fromView];
        [containerView insertSubview:toView belowSubview:fromView];
    }else {
        [containerView insertSubview:toView belowSubview:fromView];
    }

    [UIView transitionFromView:fromView
                        toView:toView
                      duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished)
    {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            [toView removeFromSuperview];
        }
        if (!self->isPushOrPop) {
            if (isPresentingOrPush) {
                [fromView removeFromSuperview];
            }else {
                [toView removeFromSuperview];
            }
        }
        [transitionContext completeTransition:!wasCancelled];
    }];

}

//    UIViewAnimationOptionTransitionNone            = 0 << 20, // default
//    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
//    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
//    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
//    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
//    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
//    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
//    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,

//    [UIView transitionWithView:toView
//                      duration:[self transitionDuration:transitionContext]
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^
//    {
//
//    } completion:^(BOOL finished) {
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
//        if (wasCancelled) {
//            [toView removeFromSuperview];
//
//            [transitionContext completeTransition:!wasCancelled];
//        }
//    }];
-(void)dealloc {
    tl_LogFunc;
}

@end
