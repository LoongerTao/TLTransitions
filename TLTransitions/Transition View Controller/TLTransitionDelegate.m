//
//  TLTransitionDelegate.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  view vontroller transition delegate / navigation controller delegate

#import "TLTransitionDelegate.h"
#import "TLGlobalConfig.h"
#import "TLPercentDrivenInteractiveTransition.h"

@implementation TLTransitionDelegate

- (instancetype)initWithAnimator:(nonnull id<TLAnimatorProtocol>)animator isPushOrPop:(BOOL)isPushOrPop{
    
    self = [super init];
    if (self) {
        _animator = animator;
        if ([animator respondsToSelector:@selector(setTransitionDuration:)]) {
            animator.transitionDuration = 0.45;
        }
        _isPushOrPop = isPushOrPop;
        if ([self.animator respondsToSelector:@selector(setIsPushOrPop:)]) {
            _animator.isPushOrPop = isPushOrPop;
        }
    }
    return self;
}

- (instancetype)init {
    NSString *reason = @"Use -initWithAnimator:popGestureRecognizer:";
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

// push / pop
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return _animator;
}

#pragma mark 转场手势交互管理者（push / pop）
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
#warning push 或者 pop 判断
    if (_popGestureRecognizer) {
        UIRectEdge edge =  [self getPopEdge];
        TLPercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_popGestureRecognizer edgeForDragging: edge];
        _popGestureRecognizer = nil; // 防止交互取消后，采用按钮等直接返回的情况冲突
        return interactiveTransition;
    } else {
        return nil;
    }
}

// present / dismiss
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return _animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return _animator;
}

#pragma mark 转场手势交互管理者（present / dismiss）
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
//    if (_popGestureRecognizer) {
//        UIRectEdge edge = [self getPopEdge];
//        TLPercentDrivenInteractiveTransition *interactiveTransition;
//        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_popGestureRecognizer edgeForDragging: edge];
//        _popGestureRecognizer = nil;
//        return interactiveTransition;
//    } else {
        return nil;
//    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (_popGestureRecognizer) {
        UIRectEdge edge = [self getPopEdge];
        TLPercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_popGestureRecognizer edgeForDragging: edge];
        _popGestureRecognizer = nil;
        return interactiveTransition;
    } else {
        return nil;
    }
}

- (UIRectEdge)getPopEdge {
    UIRectEdge edge = UIRectEdgeLeft;
    if ([_animator respondsToSelector:@selector(directionForDragging)]) {
        edge = getRectEdge([_animator directionForDragging]);
    }
    return edge;
}

- (void)dealloc {
    tl_LogFunc;
}
@end
