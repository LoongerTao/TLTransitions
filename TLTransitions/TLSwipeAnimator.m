//
//  TLSwipeAnimator.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/2.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLSwipeAnimator.h"
#import "TLPercentDrivenInteractiveTransition.h"

@implementation TLSwipeAnimator

// push / pop
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (_gestureRecognizer) {
        UIRectEdge edge = [self getEdgeWithDirectionType:_popDirection];
        TLPercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_gestureRecognizer edgeForDragging: edge];
        _gestureRecognizer = nil; // 防止交互取消后，采用按钮等直接返回的情况冲突
        return interactiveTransition;
    } else {
        return nil;
    }
}

// present / dismiss
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark 转场手势交互管理者
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (_gestureRecognizer) {
        UIRectEdge edge = [self getEdgeWithDirectionType:_pushDirection];
        TLPercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_gestureRecognizer edgeForDragging: edge];
        _gestureRecognizer = nil;
        return interactiveTransition;
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (_gestureRecognizer) {
        UIRectEdge edge = [self getEdgeWithDirectionType:_popDirection];
        TLPercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_gestureRecognizer edgeForDragging: edge];
        _gestureRecognizer = nil;
        return interactiveTransition;
    } else {
        return nil;
    }
}

- (UIRectEdge)getEdgeWithDirectionType:(TLDirectionType)directionType {
    UIRectEdge edge = UIRectEdgeTop;
    if (directionType == TLDirectionTypeTop) {
        edge = UIRectEdgeBottom;
    }else if (directionType == TLDirectionTypeLeft){
        edge = UIRectEdgeRight;
    }else if (directionType == TLDirectionTypeRight){
        edge = UIRectEdgeLeft;
    }
    return edge;
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
    
    // 1. TLSwipeTypeIn 在dismiss时需保证fromView和toView都有值
    // 2. TLSwipeTypeOut 在presetting和dismiss时需保证fromView和toView都有值
    if (!self.isPushOrPop && ((self.swipeType == TLSwipeTypeIn && !isPresentingOrPush) || self.swipeType == TLSwipeTypeOut)) {
        fromView = [self getViewWithConetoller:fromViewController];
        toView = [self getViewWithConetoller:toViewController];
    }
    
    tl_Log(@"to:%p, fromV:%p, toSuper:%p, fromSuper: %p",toView,fromView,toView.superview,fromView.superview);
    
    
    
    // CGVector 向量
    CGVector offset = [self getOffsetIsPush:isPresentingOrPush];
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *topView = nil; // 用动画的View
    UIView *bottomView = nil;
    UIView *superViewOfToView = toView.superview;
    UIView *superViewOfFromView = fromView.superview;
    if (isPresentingOrPush) {
        switch (self.swipeType) {
            case TLSwipeTypeInAndOut:
            case TLSwipeTypeIn:
                [containerView addSubview:toView];
                topView = toView;
                bottomView = fromView;
                break;
            case TLSwipeTypeOut:
                [containerView addSubview:fromView];
                topView = fromView;
                bottomView = toView;
                [containerView insertSubview:bottomView belowSubview:topView];
                break;
            default:
                NSAssert(NO, @"swipeType: %zi 越界[0...2]", self.swipeType);
                break;
        }
    } else {
        switch (self.swipeType) {
            case TLSwipeTypeInAndOut:
            case TLSwipeTypeOut:
                [containerView insertSubview:toView belowSubview:fromView];
                topView = fromView;
                bottomView = toView;
                break;
            case TLSwipeTypeIn:
                [containerView addSubview:toView];
                topView = toView;
                bottomView = fromView;
                break;
            default:
                NSAssert(NO, @"swipeType: %zi 越界[0...2]", self.swipeType);
                break;
        }
    }
    if ([topView isEqual:toView]) {
        topView.frame = [self initialFrameWhithFrame:toFrame offset:offset presentOrPush:isPresentingOrPush];
        bottomView.frame = fromFrame;
    }else{
        topView.frame = [self initialFrameWhithFrame:fromFrame offset:offset presentOrPush:isPresentingOrPush];
        bottomView.frame = toFrame;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        CGRect frame = [topView isEqual:toView] ? toFrame : fromFrame;
        topView.frame = [self finalFrameWhithFrame:frame offset:offset presentOrPush:isPresentingOrPush];
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            if (self->_swipeType != TLSwipeTypeInAndOut) {
                [superViewOfToView addSubview:toView];
            }else{
                [toView removeFromSuperview];
            }
        }else {
            // presenting or dismiss
            if (!self->_isPushOrPop) {
                // presenting
                if (isPresentingOrPush) {
                    if (self->_swipeType == TLSwipeTypeOut) {
                        [superViewOfFromView addSubview:fromView];
                    }
                }else { // dismiss
                    if (self->_swipeType != TLSwipeTypeInAndOut) {
                        [superViewOfToView addSubview:toView];
                    }
                }
            }
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (UIView *)getViewWithConetoller:(UIViewController *)viewController {
    if ([viewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        return nav.topViewController.view;
    }else{
        return viewController.view;
    }
}

- (CGVector)getOffsetIsPush:(BOOL)isPush {
    TLDirectionType directionType = isPush ? self.pushDirection : self.popDirection;
    CGVector offset;
    if (directionType == TLDirectionTypeTop){ // 坐标轴为第四象限（为正数）
        offset = CGVectorMake(0.f, -1.f);
    }else if (directionType == TLDirectionTypeBottom){
        offset = CGVectorMake(0.f, 1.f);
    }else if (directionType == TLDirectionTypeLeft){
        offset = CGVectorMake(-1.f, 0.f);
    }else if (directionType == TLDirectionTypeRight){
        offset = CGVectorMake(1.f, 0.f);
    }else{
        if (isPush) {
             NSAssert(NO, @"pushDirection: %zi 越界[0...3]", directionType);
        }else {
            NSAssert(NO, @"popDirection: %zi 越界[0...3]", directionType);
        }
        offset = CGVectorMake(0.f, 1.f); // 这句代码去警告
    }
    return offset;
}

- (CGRect)initialFrameWhithFrame:(CGRect)frame offset:(CGVector)offset presentOrPush:(BOOL)isPresentOrPush {
    NSInteger flag = 0;
    NSInteger vectorValue = offset.dx == 0 ? offset.dy : offset.dx;
    vectorValue = vectorValue > 0 ? -vectorValue : vectorValue;
    if (isPresentOrPush) {
        flag = self.swipeType == TLSwipeTypeOut ? 0 : vectorValue;
        
    }else {
        flag = self.swipeType == TLSwipeTypeIn ? vectorValue : 0;
    }
    
    CGFloat offsetX = frame.size.width * offset.dx * flag;
    CGFloat offsetY = frame.size.height * offset.dy * flag;
    return CGRectOffset(frame, offsetX, offsetY);
}

- (CGRect)finalFrameWhithFrame:(CGRect)frame offset:(CGVector)offset presentOrPush:(BOOL)isPresentOrPush {
    NSInteger flag = 0;
    NSInteger vectorValue = offset.dx == 0 ? offset.dy : offset.dx;
    vectorValue = vectorValue > 0 ? vectorValue : -vectorValue;
    if (isPresentOrPush) {
        flag = self.swipeType == TLSwipeTypeOut ? vectorValue : 0;
        
    }else {
        flag = self.swipeType == TLSwipeTypeIn ? 0 : vectorValue;
    }
    
    CGFloat offsetX = frame.size.width * offset.dx * flag;
    CGFloat offsetY = frame.size.height * offset.dy * flag;
    return CGRectOffset(frame, offsetX, offsetY);
}

-(void)dealloc {
    tl_LogFunc;
}
@end
