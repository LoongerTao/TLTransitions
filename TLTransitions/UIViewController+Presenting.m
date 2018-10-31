//
//  UIViewController+Presenting.m
//  
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "UIViewController+Presenting.h"
/// 动画类型
typedef enum : NSUInteger {
    TLPresentationAnimationTypeNormal,     //
    TLPresentationAnimationTypeTransition, // CATransition
    TLPresentationAnimationTypeCustom,     // 自定义
} TLPresentationAnimationType;

/// 自定义动画样式
typedef void(^TLAnimateTransition)(id <UIViewControllerContextTransitioning>, BOOL);

@interface TLPresentationController : UIPresentationController
<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
{
    id<UIViewControllerContextTransitioning> _transitionContext;
}

@property(nonatomic, assign) TLPresentationAnimationType animationType;


// CATransition 动画类型参数
@property(nonatomic, assign) CATransitionType tType;
@property(nonatomic, assign) CATransitionSubtype subtype;
@property(nonatomic, assign) CATransitionType tTypeOfDismiss;
@property(nonatomic, assign) CATransitionSubtype subtypeOfDismiss;

/// 自定义动画样式
@property(nonatomic, copy) TLAnimateTransition animation;
@end


@implementation TLPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        presentedViewController.transitioningDelegate = self;
    }
    
    return self;
}


#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSAssert(self.presentedViewController == presented,
             @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? .35f : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    UIView *targetView = isPresenting ? toView : fromView; // 目标
    [containerView addSubview:targetView];
    
    if (self.animationType == TLPresentationAnimationTypeTransition) {
        _transitionContext = transitionContext;
        CATransition *animation = [CATransition animation];
        animation.duration = [self transitionDuration:transitionContext];
        NSString *fName = isPresenting ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:fName];
        animation.type = isPresenting ? self.tType : self.tTypeOfDismiss;
        animation.subtype = isPresenting ? self.subtype : self.subtypeOfDismiss;
        animation.delegate = self;
        [targetView.window.layer addAnimation:animation forKey:nil];
    }else if(self.animationType == TLPresentationAnimationTypeCustom) {
        self.animation(transitionContext, isPresenting);
    }
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.presentedView.window.layer removeAllAnimations];
    [_transitionContext completeTransition:YES];
    _transitionContext = nil;
}

@end



@implementation UIViewController (Presenting)


- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   completion:(void (^ __nullable)(void))completion
{
    vc.modalTransitionStyle = style;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)presentToViewController:(UIViewController *)vc
                  transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
                     completion:(void (^ __nullable)(void))completion
{
    [self presentToViewController:vc
                   transitionType:tType
                          subtype:subtype
            dismissTransitionType:tType
                   dismissSubtype:subtype
                       completion:completion];
}

- (void)presentToViewController:(UIViewController *)vc
                 transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
          dismissTransitionType:(CATransitionType)tTypeOfDismiss
                 dismissSubtype:(CATransitionSubtype)subtypeOfDismiss
                     completion:(void (^ __nullable)(void))completion
{
    // 该宏表明存储在某些局部变量(栈)中的值,在优化时不应该被编译器强制释放
    TLPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[TLPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    presentationController.animationType = TLPresentationAnimationTypeTransition;
    presentationController.tType = tType;
    presentationController.subtype = subtype;
    presentationController.tTypeOfDismiss = tTypeOfDismiss;
    presentationController.subtypeOfDismiss = subtypeOfDismiss;
    
    vc.transitioningDelegate = presentationController;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)presentToViewController:(UIViewController *)vc
                customAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                     completion:(void (^ __nullable)(void))completion
{
    // 该宏表明存储在某些局部变量(栈)中的值,在优化时不应该被编译器强制释放
    TLPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[TLPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    presentationController.animationType = TLPresentationAnimationTypeCustom;
    presentationController.animation = animation;
    
    vc.transitioningDelegate = presentationController;
    [self presentViewController:vc animated:YES completion:completion];
}

@end
