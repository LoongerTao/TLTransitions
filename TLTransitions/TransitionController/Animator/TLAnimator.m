//
//  TLAnimator.m
//   https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/21.
//  Copyright © 2018 故乡的云. All rights reserved.
//  个人收集的一些动画

#import "TLAnimator.h"

typedef void(^TLAnimationCompletion)(BOOL flag);

@interface TLAnimator ()<CAAnimationDelegate>

/// CAAnimation 完成回调
@property(nonatomic, copy) TLAnimationCompletion animationCompletion;
@end


@implementation TLAnimator


#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;

- (TLDirection)directionForDragging; {
    if (self.type == TLAnimatorTypeTiltLeft){
        return TLDirectionToLeft;
    }
    return TLDirectionToRight; // 滑动方向
}

- (CGFloat)percentOfFinishInteractiveTransition {
    if (self.type == TLAnimatorTypeTiltLeft || self.type == TLAnimatorTypeTiltRight){
        return 0.29f;
    }
    if (self.type == TLAnimatorCircular){
        return 0.f;
    }
    
    return 0.5f;
}

#pragma mark - creat instance
+ (instancetype)animatorWithType:(TLAnimatorType)type {
    TLAnimator *anmator = [self new];
    anmator.type = type;
    if (type == TLAnimatorTypeFrame) {
        anmator.initialFrame = CGRectMake(tl_ScreenW * 0.5f, tl_ScreenH * 0.5f, 0.f, 0.f);
    }
   
    return anmator;
}

- (void)setRectView:(UIView *)rectView {
    _rectView = [rectView snapshotViewAfterScreenUpdates:NO];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isPresenting;
    if(self.isPushOrPop) {
        NSInteger toIndex = [toViewController.navigationController.viewControllers indexOfObject:toViewController];
        NSInteger fromIndex = [fromViewController.navigationController.viewControllers indexOfObject:fromViewController];
        isPresenting = (toIndex > fromIndex);
    }else {
        isPresenting = (toViewController.presentingViewController == fromViewController);
    }
    
    !isPresenting ? nil : [toViewController.view setFrame:[transitionContext finalFrameForViewController: toViewController]];
    
    switch (_type) {
        case TLAnimatorTypeOpen:
            [self openTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeOpen2:
            [self open2TypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeBevel:
            if (isPushOrPop) {
                NSLog(@"TLAnimatorTypeBevel: 不支持Push/pop转场");
                [transitionContext.containerView addSubview:toViewController.view];
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                [transitionContext completeTransition:!wasCancelled];
            }else {
                [self bevelTypeTransition:transitionContext presenting:isPresenting];
            }
            break;
        case TLAnimatorTypeTiltRight:
        case TLAnimatorTypeTiltLeft:
            [self tiltTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeFrame:
            [self frameTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorRectScale:
            [self rectScaleTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorCircular:
            [self circularTypeTransition:transitionContext presenting:isPresenting];
            break;
        default:
            break;
    }
}

#pragma mark - TLAnimatorTypeOpen
- (void)openTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;;
    
    UIView *tragetView = isPresenting ? fromView : toView;
    CGRect rect = tragetView.bounds;
    rect.size.width *= .5f;
    // 如bview是不可见的：afterScreenUpdates必须为YES
    UIView *leftView = [tragetView resizableSnapshotViewFromRect:rect afterScreenUpdates:self.isPushOrPop withCapInsets:UIEdgeInsetsZero];
    
    rect = CGRectOffset(rect, rect.size.width, 0.f);
    UIView *rightView = [tragetView resizableSnapshotViewFromRect:rect afterScreenUpdates:self.isPushOrPop withCapInsets:UIEdgeInsetsZero];
    rightView.frame = CGRectOffset(leftView.frame, leftView.frame.size.width, 0.f);;
    
    UIView *containerView = transitionContext.containerView;
    // 注意层次关系
    if (isPresenting) {
        [containerView addSubview:toView];
    }else {
        if (self.isPushOrPop) {
            [containerView insertSubview:toView atIndex:0];
        }
    }
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    if (!isPresenting) {
        leftView.frame = CGRectOffset(leftView.frame, -leftView.frame.size.width, 0.f);
        rightView.frame = CGRectOffset(rightView.frame, rightView.frame.size.width, 0.f);
    }
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            leftView.frame = CGRectOffset(leftView.frame, -leftView.frame.size.width, 0.f);
            rightView.frame = CGRectOffset(rightView.frame, rightView.frame.size.width, 0.f);
        } else {
            leftView.frame = CGRectOffset(leftView.frame, leftView.frame.size.width, 0.f);
            rightView.frame = CGRectOffset(rightView.frame, -rightView.frame.size.width, 0.f);
        }
        
    } completion:^(BOOL finished) {

        [leftView removeFromSuperview];
        [rightView removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}


#pragma mark - TLAnimatorTypeOpen2
- (void)open2TypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;;
    
    
    UIView *tragetView = isPresenting ? fromView : toView;
    CGRect rect = tragetView.bounds;
    rect.size.width *= .5f;
    rect.size.height *= .5f;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    UIView *leftTopView = [tragetView resizableSnapshotViewFromRect:rect afterScreenUpdates:self.isPushOrPop withCapInsets:UIEdgeInsetsZero];
    
    rect = CGRectOffset(rect, W, 0.f);
    
    UIView *rightTopView = [tragetView resizableSnapshotViewFromRect:rect afterScreenUpdates:self.isPushOrPop withCapInsets:UIEdgeInsetsZero];
    rightTopView.frame = CGRectOffset(leftTopView.frame, W, 0.f);
    
    rect = CGRectOffset(rect, -W, H);
    UIView *leftBottomView = [tragetView resizableSnapshotViewFromRect:rect afterScreenUpdates:self.isPushOrPop withCapInsets:UIEdgeInsetsZero];
    leftBottomView.frame = CGRectOffset(leftTopView.frame, 0.f, H);
    
    rect = CGRectOffset(rect, W, 0.f);
    UIView *rightBottomView = [tragetView resizableSnapshotViewFromRect:rect afterScreenUpdates:self.isPushOrPop withCapInsets:UIEdgeInsetsZero];
    rightBottomView.frame = CGRectOffset(leftBottomView.frame, W, 0.f);
    
    
    UIView *containerView = transitionContext.containerView;
    // 注意层次关系
    if (isPresenting) {
        [containerView addSubview:toView];
    }else {
        if (self.isPushOrPop) {
            [containerView insertSubview:toView atIndex:0];
        }
    }
    [containerView addSubview:leftTopView];
    [containerView addSubview:rightTopView];
    [containerView addSubview:leftBottomView];
    [containerView addSubview:rightBottomView];
    
    if (!isPresenting) {
        leftTopView.frame = CGRectOffset(leftTopView.frame, -W, -H);
        rightTopView.frame = CGRectOffset(rightTopView.frame,  W, -H);
        leftBottomView.frame = CGRectOffset(leftBottomView.frame,  -W, H);
        rightBottomView.frame = CGRectOffset(rightBottomView.frame,  W, H);
    }
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            leftTopView.frame = CGRectOffset(leftTopView.frame, -W, -H);
            rightTopView.frame = CGRectOffset(rightTopView.frame,  W, -H);
            leftBottomView.frame = CGRectOffset(leftBottomView.frame,  -W, H);
            rightBottomView.frame = CGRectOffset(rightBottomView.frame,  W, H);
        } else {
            leftTopView.frame = CGRectOffset(leftTopView.frame, W, H);
            rightTopView.frame = CGRectOffset(rightTopView.frame,  -W, H);
            leftBottomView.frame = CGRectOffset(leftBottomView.frame,  W, -H);
            rightBottomView.frame = CGRectOffset(rightBottomView.frame,  -W, -H);
        }
        
    } completion:^(BOOL finished) {
        
        [leftTopView removeFromSuperview];
        [rightTopView removeFromSuperview];
        [leftBottomView removeFromSuperview];
        [rightBottomView removeFromSuperview];
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

#pragma mark - TLAnimatorTypeBevel
- (void)bevelTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;;
    UIView *containerView = transitionContext.containerView;
    UIView *animateView = isPresenting ? toView : fromView;
    animateView = [animateView snapshotViewAfterScreenUpdates:isPresenting];
    [containerView addSubview:animateView];
    isPresenting ? nil : [fromView setHidden:YES];
   
    CGFloat W = animateView.bounds.size.width;
    CGFloat H = animateView.bounds.size.height;
    animateView.layer.anchorPoint = CGPointMake(0, 0.5);
    
    CATransform3D identity = CATransform3DIdentity;
    identity.m34 = -1.0 / 500.0;
    CATransform3D rotateTransform = CATransform3DRotate(identity, M_PI/4, 0, 1, 0);
    
    if (isPresenting) {
        animateView.layer.position = CGPointMake(W, H * 0.5);
        animateView.layer.transform = rotateTransform;
    }else {
        animateView.layer.position = CGPointMake(0, H * 0.5);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isPresenting) {
            animateView.layer.position = CGPointMake(0, H * 0.5);
            animateView.layer.transform = CATransform3DIdentity;
        }else {
            animateView.layer.position = CGPointMake(W, H * 0.5);
            animateView.layer.transform = rotateTransform;
        }
    } completion:^(BOOL finished) {
        [animateView removeFromSuperview];
        isPresenting ? [containerView addSubview:toView] : (fromView.hidden = NO);
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - TLAnimatorTypetilt
- (void)tiltTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = transitionContext.containerView;
    if(!isPresenting && self->isPushOrPop) {
        [containerView addSubview:toView];
    }
    UIView *animateView = isPresenting ? toView : fromView;
    animateView = [animateView snapshotViewAfterScreenUpdates:isPresenting];
    [containerView addSubview:animateView];
    isPresenting ? nil : [fromView setHidden:YES];
    
    CGFloat W = animateView.bounds.size.width;
    CGFloat H = animateView.bounds.size.height;
    CGFloat angle = self.type == TLAnimatorTypeTiltLeft ? -M_PI_2 : M_PI_2;
    animateView.layer.anchorPoint = CGPointMake(0.5, 2);
    animateView.layer.position = CGPointMake(W * animateView.layer.anchorPoint.x, H * animateView.layer.anchorPoint.y);
    animateView.transform = isPresenting ? CGAffineTransformMakeRotation(angle) : CGAffineTransformIdentity;
   
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        animateView.transform = !isPresenting ? CGAffineTransformMakeRotation(angle) : CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [animateView removeFromSuperview];
        isPresenting ? [containerView addSubview:toView] : (fromView.hidden = NO);
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - TLAnimatorTypeFrame
- (void)frameTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = transitionContext.containerView;
    if(!isPresenting && self->isPushOrPop) {
        [containerView addSubview:toView];
    }
    UIView *animateView = isPresenting ? toView : fromView;
    animateView = [animateView snapshotViewAfterScreenUpdates:isPresenting];
    [containerView addSubview:animateView];
    isPresenting ? nil : [fromView setHidden:YES];
    
    if(CGRectEqualToRect(self.finalFrame, CGRectNull) || CGRectEqualToRect(self.finalFrame, CGRectZero)) {
        self.finalFrame = [transitionContext finalFrameForViewController: [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]];
    }
    animateView.frame = isPresenting ? self.initialFrame : self.finalFrame;
    animateView.contentMode = UIViewContentModeScaleAspectFill;
    animateView.clipsToBounds = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        animateView.frame = !isPresenting ? self.initialFrame : self.finalFrame;
    } completion:^(BOOL finished) {
        [animateView removeFromSuperview];
        if(isPresenting) {
            [containerView addSubview:toView];
            toView.frame = self.finalFrame;
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - TLAnimatorTypeRectScale
- (void)rectScaleTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    if(CGRectEqualToRect(self.fromRect, CGRectNull) || CGRectEqualToRect(self.fromRect, CGRectZero)) {
        NSAssert(NO, @"TLAnimatorRectScale类型必须初始化fromRect");
    }
    if(CGRectEqualToRect(self.toRect, CGRectNull) || CGRectEqualToRect(self.toRect, CGRectZero)) {
        NSAssert(NO, @"TLAnimatorRectScale类型必须初始化toRect");
    }
    if(self.isPushOrPop && _rectView == nil) {
        NSAssert(NO, @"TLAnimatorRectScale类型必须初始化rectView");
    }
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *traget = isPresenting ? fromView : toView;
    UIView *containerView = transitionContext.containerView;
    if (isPresenting) {
        containerView.backgroundColor = toView.backgroundColor;
        [toView setHidden:YES];
        if (self.isPushOrPop) {
            [fromView setHidden:YES];
        }
    }else {
        [fromView setHidden:YES];
    }
   
    [traget layoutIfNeeded];
    [traget setNeedsDisplay];
    UIView *bgView;
    if(_isOnlyShowRangeForRect) {
        bgView = [[UIView alloc] init];
        bgView.frame = containerView.bounds;
    }else {
        bgView = [traget snapshotViewAfterScreenUpdates:!isPresenting];
    }
    [containerView addSubview:bgView];
    CGFloat W = bgView.bounds.size.width;
    CGFloat H = bgView.bounds.size.height;
    CGFloat anchorPointX = _fromRect.origin.x / W;  // _fromRect.origin作为anchorPoint
    CGFloat anchorPointY = _fromRect.origin.y / H ;
    CGPoint anchorPoint = CGPointMake(anchorPointX, anchorPointY);
    bgView.layer.anchorPoint = anchorPoint;
    bgView.layer.position = CGPointMake(anchorPoint.x * W, anchorPoint.y * H);
    
    UIView *rectView;
    if (_rectView) {
        rectView = _rectView;
    }else {
        rectView = [traget resizableSnapshotViewFromRect:_fromRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        _rectView = rectView;
    }
    [containerView addSubview:rectView];
    rectView.layer.anchorPoint = CGPointZero;
    rectView.layer.position = _fromRect.origin;
    
    CGFloat tx = _toRect.origin.x - _fromRect.origin.x;
    CGFloat ty = _toRect.origin.y - _fromRect.origin.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
    
    CGFloat scaleX = _toRect.size.width / _fromRect.size.width;
    CGFloat scaleY = _toRect.size.height / _fromRect.size.height;
    transform = CGAffineTransformScale(transform, scaleX, scaleY);
   
    bgView.transform = !isPresenting ? transform : CGAffineTransformIdentity;
    if(_isOnlyShowRangeForRect) {
        bgView.backgroundColor = fromView.backgroundColor ? fromView.backgroundColor : tl_WhiteTintColor;;
    }else {
        bgView.alpha = isPresenting ? 1.f : 0.f;
    }
    rectView.transform = bgView.transform;
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        bgView.transform = isPresenting ? transform : CGAffineTransformIdentity;
        if(self->_isOnlyShowRangeForRect) {
            bgView.backgroundColor = toView.backgroundColor ? toView.backgroundColor : tl_WhiteTintColor;
        }else{
            bgView.alpha = !isPresenting ? 1.f : 0.f;
        }
        rectView.transform = bgView.transform;
    } completion:^(BOOL finished) {
        if(isPresenting || (!isPresenting && self->isPushOrPop)) {
            [containerView addSubview:toView];
        }
        [rectView removeFromSuperview];
        [bgView removeFromSuperview];
        isPresenting ? [toView setHidden:NO] : [fromView setHidden:NO];
        if (self.isPushOrPop) {
            [fromView setHidden:NO];
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - TLAnimatorTypeCircular
- (void)circularTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
   
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *traget = isPresenting ? toVC : fromVC;
    UIView *containerView = transitionContext.containerView;
    if(isPresenting) {
        [containerView addSubview:toVC.view];
    }
    if (!isPresenting && self->isPushOrPop) {
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }
    
    if (CGPointEqualToPoint(_center, CGPointZero)) {
        _center = traget.view.center;
    }
    
    CGFloat W = traget.view.frame.size.width;
    CGFloat H = traget.view.frame.size.height;
    
    CGFloat x = MAX(_center.x, W - _center.x);
    CGFloat y = MAX(_center.y, H - _center.y);
    CGFloat endRadius = sqrt(x * x + y * y);
    
    CGFloat radius = isPresenting ? self->_startRadius : endRadius;
    CGFloat radius2 = !isPresenting ? self->_startRadius : endRadius;
    CGRect rect = CGRectMake(_center.x - radius, _center.y - radius, radius * 2, radius * 2);
    CGRect rect2 = CGRectMake(_center.x - radius2, _center.y - radius2, radius2 * 2, radius2 * 2);
    CGPathRef path = CGPathCreateWithEllipseInRect(rect, nil);
    CGPathRef path2 = CGPathCreateWithEllipseInRect(rect2, nil);
    
    CABasicAnimation *anm = [CABasicAnimation animationWithKeyPath:@"path"];
    anm.fromValue =  (__bridge id _Nullable)(path);
    anm.toValue = (__bridge id _Nullable)(path2);
    anm.duration = [self transitionDuration:transitionContext];
    anm.delegate = self;
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    traget.view.layer.mask = mask;

    mask.path = path2;
    mask.fillRule = kCAFillRuleEvenOdd;
    [mask addAnimation:anm forKey:@"path"];
    [mask setNeedsDisplay];
    __weak typeof(self) wself = self;
    self.animationCompletion = ^(BOOL flag) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
        
        wself.animationCompletion = nil;
    };
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationCompletion) {
        self.animationCompletion(flag);
    }
}
@end
