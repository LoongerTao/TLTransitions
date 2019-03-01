//
//  TLAnimator.m
//   https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/21.
//  Copyright © 2018 故乡的云. All rights reserved.
//  个人收集的一些动画

#import "TLAnimator.h"
//#import "UIViewController+Transitioning.h"
//#import "TLTransitionDelegate.h"

typedef void(^TLAnimationCompletion)(BOOL flag);

@interface TLAnimator ()<CAAnimationDelegate>

@property(nonatomic, weak) UIViewController *presentingViewController; // 发起present的view controller
@property(nonatomic, weak) UIViewController *presentedViewController;  // 被present的view controller
@property(nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
/// CAAnimation 完成回调
@property(nonatomic, copy) TLAnimationCompletion animationCompletion;
@end


@implementation TLAnimator


#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (TLDirection)interactiveDirectionOfPop {
    if (self.type == TLAnimatorTypeTiltLeft || self.type == TLAnimatorTypeSlidingDrawer){
        return TLDirectionToLeft;
    }
    return TLDirectionToRight; // 滑动方向
}

- (CGFloat)percentOfFinishInteractiveTransition {
    if (self.type == TLAnimatorTypeTiltLeft || self.type == TLAnimatorTypeTiltRight){
        return 0.29f;
    }
    if (self.type == TLAnimatorTypeCircular || self.type == TLAnimatorTypeFlip){
        return 0.f;
    }
    if (self.type == TLAnimatorTypeSlidingDrawer){
        return 0.45;
    }
    
    return 0.5f;
}

- (CGFloat)speedOfPercent {
    if (self.type == TLAnimatorTypeTiltLeft || self.type == TLAnimatorTypeTiltRight){
        return 0.5f;
    }
    return 0;
}

#pragma mark - creat instance
+ (instancetype)animatorWithType:(TLAnimatorType)type {
    TLAnimator *anmator = [self new];
    anmator.type = type;
    if (type == TLAnimatorTypeFrame) {
        anmator.initialFrame = CGRectMake(tl_ScreenW * 0.5f, tl_ScreenH * 0.5f, 0.f, 0.f);
    }else if (type == TLAnimatorTypeFlip) {
        anmator.animationOptions = UIViewAnimationOptionTransitionFlipFromLeft;
    }else if (type == TLAnimatorTypeSlidingDrawer){
        anmator.slidEnabled = YES;
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
    
    if(isPresenting) {
        [toViewController.view setFrame:[transitionContext finalFrameForViewController: toViewController]];
    }
    
    switch (_type) {
        case TLAnimatorTypeOpen:
            [self openTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeOpen2:
            [self open2TypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeBevel:
            if (isPushOrPop) {
                NSAssert(NO, @"TLViewTransitionAnimator: 只支持present/dismiss转场");
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
        case TLAnimatorTypeRectScale:
            [self rectScaleTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeCircular:
            [self circularTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeFlip:
            [self flipTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeSlidingDrawer:
            [self slidingDrawerTypeTransition:transitionContext presenting:isPresenting];
            break;
        case TLAnimatorTypeCards:
            [self cardsTypeTransition:transitionContext presenting:isPresenting];
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
    rect.origin.y = tragetView.frame.origin.y;
    leftView.frame = rect;
  
    rect = CGRectOffset(rect, rect.size.width, 0.f);
    rect.origin.y = 0;
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
    
    // 3d缩放效果
    UIView *maskView;
    if (_removeScaleAnimation == NO) {
        maskView = [[UIView alloc] initWithFrame:containerView.bounds];
        UIColor *backgroundColor = [UIApplication sharedApplication].keyWindow.backgroundColor; // 用来遮住tragetView
        maskView.backgroundColor = backgroundColor ? backgroundColor : [UIColor blackColor];
        [containerView addSubview:maskView];
        [containerView sendSubviewToBack:maskView];
        [containerView sendSubviewToBack:tragetView];
        
        if (isPresenting) {
            CATransform3D transform3D = CATransform3DMakeTranslation(0, -30, -0);
            toView.layer.transform = CATransform3DScale(transform3D, 0.8f, 0.8f, 1);
        }
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            leftView.frame = CGRectOffset(leftView.frame, -leftView.frame.size.width, 0.f);
            rightView.frame = CGRectOffset(rightView.frame, rightView.frame.size.width, 0.f);
            if (maskView) {
                toView.layer.transform = CATransform3DIdentity;
            }
        } else {
            leftView.frame = CGRectOffset(leftView.frame, leftView.frame.size.width, 0.f);
            rightView.frame = CGRectOffset(rightView.frame, -rightView.frame.size.width, 0.f);
            if (maskView) {
                CATransform3D transform3D = CATransform3DMakeTranslation(0, -30, -0);
                fromView.layer.transform = CATransform3DScale(transform3D, 0.8f, 0.8f, 1);
            }
        }
        
    } completion:^(BOOL finished) {
        
        [leftView removeFromSuperview];
        [rightView removeFromSuperview];
        
        if (maskView) {
            if (!isPresenting) {
                fromView.layer.transform = CATransform3DIdentity;
            }
            [maskView removeFromSuperview];
        }
        
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
    rect.origin.y = tragetView.frame.origin.y;
    leftTopView.frame = rect;
    
    rect.origin.y = tragetView.bounds.origin.y;
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
    
    // 3d缩放效果
    _removeScaleAnimation = YES; // 效果不佳，暂时不开放
    UIView *maskView;
    if (_removeScaleAnimation == NO) {
        maskView = [[UIView alloc] initWithFrame:containerView.bounds];
        UIColor *backgroundColor = [UIApplication sharedApplication].keyWindow.backgroundColor; // 用来遮住tragetView
        maskView.backgroundColor = backgroundColor ? backgroundColor : [UIColor blackColor];
        [containerView addSubview:maskView];
        [containerView sendSubviewToBack:maskView];
        [containerView sendSubviewToBack:tragetView];
        
        if (isPresenting) {
            CATransform3D transform3D = CATransform3DMakeTranslation(0, -30, -0);
            toView.layer.transform = CATransform3DScale(transform3D, 0.8f, 0.8f, 1);
        }
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            leftTopView.frame = CGRectOffset(leftTopView.frame, -W, -H);
            rightTopView.frame = CGRectOffset(rightTopView.frame,  W, -H);
            leftBottomView.frame = CGRectOffset(leftBottomView.frame,  -W, H);
            rightBottomView.frame = CGRectOffset(rightBottomView.frame,  W, H);
            
            if (maskView) {
                toView.layer.transform = CATransform3DIdentity;
            }
            
        } else {
            leftTopView.frame = CGRectOffset(leftTopView.frame, W, H);
            rightTopView.frame = CGRectOffset(rightTopView.frame,  -W, H);
            leftBottomView.frame = CGRectOffset(leftBottomView.frame,  W, -H);
            rightBottomView.frame = CGRectOffset(rightBottomView.frame,  -W, -H);
            
            if (maskView) {
                CATransform3D transform3D = CATransform3DMakeTranslation(0, -30, -0);
                fromView.layer.transform = CATransform3DScale(transform3D, 0.8f, 0.8f, 1);
            }
        }
        
    } completion:^(BOOL finished) {
        
        [leftTopView removeFromSuperview];
        [rightTopView removeFromSuperview];
        [leftBottomView removeFromSuperview];
        [rightBottomView removeFromSuperview];
        
        if (maskView) {
            if (!isPresenting) {
                fromView.layer.transform = CATransform3DIdentity;
            }
            [maskView removeFromSuperview];
        }
        
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

#pragma mark - TLAnimatorTypeTilt
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
    CGFloat insetY = isPresenting ? toView.frame.origin.y : fromView.frame.origin.y;
    animateView.layer.position = CGPointMake(W * animateView.layer.anchorPoint.x, H * animateView.layer.anchorPoint.y + insetY);
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
        NSAssert(NO, @"TLAnimatorTypeRectScale类型必须初始化fromRect");
    }
    if(CGRectEqualToRect(self.toRect, CGRectNull) || CGRectEqualToRect(self.toRect, CGRectZero)) {
        NSAssert(NO, @"TLAnimatorTypeRectScale类型必须初始化toRect");
    }
    if(self.isPushOrPop && _rectView == nil) {
        NSAssert(NO, @"TLAnimatorTypeRectScale类型必须初始化rectView");
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    if(!_isOnlyShowRangeForRect) {
        UIView *sanpshot = [traget snapshotViewAfterScreenUpdates:!isPresenting];
        // 设置sanpshot.frame = traget.frame;是为了解决
        // viewWillAppear 中写入 self.navigationController.navigationBar.translucent = NO; 导致计算sanpshot traget.view
        // 有inset，而导致rect不对的问题
        sanpshot.frame = traget.frame;
        [bgView addSubview:sanpshot];
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

#pragma mark - TLAnimatorTypeFlip
- (void)flipTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting {
    NSAssert(self.isPushOrPop, @"TLViewTransitionAnimator: 只支持Push/pop转场");
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    BOOL isPush = isPresenting;
    UIView *sanpshotOfFromView;
    if (isPush) {
        sanpshotOfFromView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
        [containerView addSubview:sanpshotOfFromView];
        [containerView insertSubview:toView belowSubview:sanpshotOfFromView];
    }else {
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    UIViewAnimationOptions options = _animationOptions;
    if (!isPush) {
        switch (options) {
            case UIViewAnimationOptionTransitionFlipFromLeft:
                options = UIViewAnimationOptionTransitionFlipFromRight;
                break;
            case UIViewAnimationOptionTransitionFlipFromRight:
                options = UIViewAnimationOptionTransitionFlipFromLeft;
                break;
            case UIViewAnimationOptionTransitionCurlUp:
                options = UIViewAnimationOptionTransitionCurlDown;
                break;
            case UIViewAnimationOptionTransitionCurlDown:
                options = UIViewAnimationOptionTransitionCurlUp;
                break;
            case UIViewAnimationOptionTransitionFlipFromTop:
                options = UIViewAnimationOptionTransitionFlipFromBottom;
                break;
            case UIViewAnimationOptionTransitionFlipFromBottom:
                options = UIViewAnimationOptionTransitionFlipFromTop;
                break;
            default:
                break;
        }
    }
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:[self transitionDuration:transitionContext]
                       options:options
                    completion:^(BOOL finished)
     {
         if (isPush) {
             [sanpshotOfFromView removeFromSuperview];
         }
         
         BOOL wasCancelled = [transitionContext transitionWasCancelled];
         [transitionContext completeTransition:!wasCancelled];
     }];

}

#pragma mark - TLAnimatorSlidingDrawer
- (void)slidingDrawerTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting
{
//    NSAssert(self.isPushOrPop, @"TLViewTransitionAnimator: 只支持Push/pop转场");
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UIView *snapshot = isPresenting ? [fromView snapshotViewAfterScreenUpdates:NO] : [containerView viewWithTag:100];
    snapshot.tag = 100; // dismiss之后才会销毁

    if(isPresenting) {
        [containerView addSubview:toView];
        
        UIView *mask = [[UIView alloc] initWithFrame:snapshot.bounds];
        mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15f];
        mask.tag = 99;
        [snapshot addSubview:mask];
        
        snapshot.layer.shadowOpacity = 0.33f;
        snapshot.layer.shadowRadius = 5.f;
        snapshot.layer.shadowOffset = CGSizeMake(-3, -1.f) ;
    }
    [containerView addSubview:snapshot];
    
    CGFloat offsetX = tl_ScreenW - 100.f;
    [snapshot viewWithTag:99].alpha = isPresenting ? 0.f : 1.f;
    
    if (_slidEnabled) {
        UIView *slidView = isPresenting ? toView : fromView;
        CGFloat slidX = -slidView.bounds.size.width * 0.5;
        !isPresenting ? nil : [slidView setFrame: CGRectOffset(slidView.frame, slidX, 0.f)];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGFloat offsetX_Block = isPresenting ? offsetX : -offsetX;
        snapshot.frame = CGRectOffset(snapshot.frame, offsetX_Block, 0.f);
        [snapshot viewWithTag:99].alpha = !isPresenting ? 0.f : 1.f;
        if (self->_slidEnabled) {
            UIView *slidView = isPresenting ? toView : fromView;
            CGFloat slidX = isPresenting ? slidView.bounds.size.width * 0.5 : -slidView.bounds.size.width * 0.5;
            [slidView setFrame: CGRectOffset(slidView.frame, slidX, 0.f)];
        }
        
    } completion:^(BOOL finished) {
        if(!isPresenting && self->isPushOrPop) {
            [containerView addSubview:toView];
        }
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (!isPresenting && !wasCancelled) {
            [snapshot removeFromSuperview];
            if (containerView.gestureRecognizers.count) {
                [containerView removeGestureRecognizer: containerView.gestureRecognizers.firstObject];
            }
        }
        
        [transitionContext completeTransition:!wasCancelled];
        if (!wasCancelled && isPresenting) { // 添加手势
            self->_presentedViewController = toViewController;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapGestureRecognizerOfSlidingDrawerType:)];
            [snapshot addGestureRecognizer:tap];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPanGestureRecognizerOfSlidingDrawerType:)];
            [containerView addGestureRecognizer:pan];
        }
    }];
}

#pragma mark 手势 Gesture Recognizer
- (void)dismissTapGestureRecognizerOfSlidingDrawerType:(UITapGestureRecognizer *)tap {
    if(_presentedViewController) {
        [_presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismissPanGestureRecognizerOfSlidingDrawerType:(UIPanGestureRecognizer *)pan {
    if(_presentedViewController) {
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                UIView *containerView = pan.view;
                UIView *snapshot = [containerView viewWithTag:100];
                CGPoint locationInSourceView = [pan locationInView:containerView];
                if (CGRectContainsPoint(snapshot.frame, locationInSourceView)) {
                    // 使用KVO解决pod中头文件的循环依赖
                    [_presentedViewController setValue:@(TLDirectionToLeft) forKeyPath:@"transitionDelegate.tempInteractiveDirection"];
                    [_presentedViewController setValue:pan forKeyPath:@"transitionDelegate.interactiveRecognizer"];
//                    _presentedViewController.transitionDelegate.tempInteractiveDirection = TLDirectionToLeft;
//                    _presentedViewController.transitionDelegate.interactiveRecognizer = pan;
                    [_presentedViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - TLAnimatorCards
- (void)cardsTypeTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = containerView.bounds.size.height;
    toView.frame = offScreenFrame;
    
    UIView *superView = nil;
    if(!self.isPushOrPop && !isPresenting) {
        superView = toView.superview;
    }
    [containerView insertSubview:toView aboveSubview:fromView];
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0, -fromView.frame.size.height * 0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
            fromView.layer.transform = t1;
            fromView.alpha = 0.6;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.4f animations:^{
            fromView.layer.transform = t2;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
            toView.frame = CGRectOffset(toView.frame, 0.0, -30.0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
            toView.frame = frame;
            fromView.layer.transform = CATransform3DIdentity;
        }];
        
    } completion:^(BOOL finished) {
        fromView.alpha = 1;
        if(!self.isPushOrPop && !isPresenting) {
            [superView  addSubview:toView];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

/* 可以modal / pop还存在bug
#pragma mark - TLAnimatorCards2
- (void)cardsTypeTransition2:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)isPresenting
{
    if(isPresenting){
        [self cardsTypeTransition:transitionContext presenting:isPresenting];
        return;
    }
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offScreenFrame = frame;
//    offScreenFrame.origin.y = containerView.bounds.size.height;
    
//    fromView.frame = offScreenFrame;
    
    UIView *superView = nil;
    if(!self.isPushOrPop && !isPresenting) {
        superView = toView.superview;
    }
    [containerView addSubview:fromView];
    
    CGPoint position = toView.layer.position;
    
    
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/-600;
    t = CATransform3DTranslate (t, 0, 10, -120);
//    t = CATransform3DScale(t, 1, 1, 1);
    toView.layer.transform = t;
    
   
    CATransform3D t2 = CATransform3DRotate(t, 10 * M_PI/180.0f, 1, 0, 0);
    
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^
    {
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:.3f animations:^{
            toView.layer.anchorPoint = CGPointMake(0.5, 0);
            toView.layer.position = CGPointMake(position.x, 0);
            toView.layer.transform = t2;

        }];

        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.2f animations:^{
        
            toView.layer.transform = CATransform3DIdentity;

        }];

        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.3f animations:^{
          CGRect rect = offScreenFrame;
          rect.origin.y = containerView.bounds.size.height;
          fromView.frame = rect;
        }];
        
        
    } completion:^(BOOL finished) {
        toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toView.layer.position = position;
        if(!self.isPushOrPop && !isPresenting) {
            [superView  addSubview:toView];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
*/

#pragma mark - CABasicAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationCompletion) {
        self.animationCompletion(flag);
    }
}
@end
