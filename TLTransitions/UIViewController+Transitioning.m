//
//  UIViewController+Transitioning.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "UIViewController+Transitioning.h"
#import "TLSwipeAnimator.h"
#import <objc/runtime.h>

/// 动画类型
typedef enum : NSUInteger {
    TLPresentationAnimationTypeSwipe,      // 平移进入
    TLPresentationAnimationTypeTransition, // CATransition
    TLPresentationAnimationTypeCustom,     // 自定义
} TLPresentationAnimationType;

/// 自定义动画样式
typedef void(^TLAnimateTransition)(id <UIViewControllerContextTransitioning>, BOOL);

@interface TLPresentationController : UIPresentationController
<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
{
    id<UIViewControllerContextTransitioning> _transitionContext;
    BOOL _isPresenting;
}

@property(nonatomic, assign) TLPresentationAnimationType animationType;

// Swipe 进入方向
@property (nonatomic, readwrite) UIRectEdge targetEdge;
/// 进出反向
@property (nonatomic, assign) BOOL isReverse;


// CATransition 动画类型参数
@property(nonatomic, assign) CATransitionType tType;
@property(nonatomic, assign) CATransitionSubtype subtype;
@property(nonatomic, assign) CATransitionType tTypeOfDismiss;
@property(nonatomic, assign) CATransitionSubtype subtypeOfDismiss;
@property(nonatomic, weak) UIView *superviewOfPresentingView;

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


#pragma mark - UIViewControllerTransitioningDelegate (present)
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

#pragma mark UINavigationControllerDelegate - (push/pop)
//  push/pop Animator.
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.presentingViewController.transitionDuration : 0.f;
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

    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if(self.animationType != TLPresentationAnimationTypeSwipe){
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    _isPresenting = isPresenting;
    if (isPresenting)
        [containerView addSubview:toView];
    
    
    
    if(self.animationType == TLPresentationAnimationTypeSwipe) {
        // 向量
        CGVector offset = CGVectorMake(0.f, 1.f); // UIRectEdgeTop
        if (self.targetEdge == UIRectEdgeTop)
            ;
        else if (self.targetEdge == UIRectEdgeBottom)
            offset = CGVectorMake(0.f, -1.f);
        else if (self.targetEdge == UIRectEdgeLeft)
            offset = CGVectorMake(1.f, 0.f);
        else if (self.targetEdge == UIRectEdgeRight)
            offset = CGVectorMake(-1.f, 0.f);
        else
            NSAssert(NO, @"targetEdge 必须是 UIRectEdgeTop、UIRectEdgeBottom、UIRectEdgeLeft、UIRectEdgeRight 中的一个");
        
        if (isPresenting) {
            fromView.frame = fromFrame;
            toView.frame = CGRectOffset(toFrame, toFrame.size.width * offset.dx * -1,
                                        toFrame.size.height * offset.dy * -1);
        } else {
            fromView.frame = fromFrame;
            toView.frame = toFrame;
        }
        
        [UIView animateWithDuration:transitionDuration animations:^{
            if (isPresenting)
                toView.frame = toFrame;
            else {
                if (self.isReverse) {
                    fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width * offset.dx  * -1,
                                                  fromFrame.size.height * offset.dy * -1);
                }else {
                    fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width * offset.dx,
                                                  fromFrame.size.height * offset.dy);
                }
            }
            
        } completion:^(BOOL finished) {
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            if (wasCancelled)
                [toView removeFromSuperview];
            
            [transitionContext completeTransition:!wasCancelled];
        }];
    }else if (self.animationType == TLPresentationAnimationTypeTransition) {

        if (!isPresenting) { // dismiss
            // 对于dismiss动画，我们希望From视图滑开，显示toView。
            // 因此，我们必须将toView放在containerView上，同时动画s结束后要将toView添加回原来的superview上
            toView = toViewController.view; // 保证有值
            self.superviewOfPresentingView = toView.superview;
            [containerView addSubview:toView];
        }
        
        _transitionContext = transitionContext;
        CATransition *animation = [CATransition animation];
        animation.duration = [self transitionDuration:transitionContext];
//        NSString *fName = isPresenting ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:fName];
        animation.type = isPresenting ? self.tType : self.tTypeOfDismiss;
        animation.subtype = isPresenting ? self.subtype : self.subtypeOfDismiss;
        animation.delegate = self;
        
        UIView *targetView = _isPresenting ? toView : fromView; // 目标
        [targetView.window.layer addAnimation:animation forKey:nil];
        
    }else if(self.animationType == TLPresentationAnimationTypeCustom) {

        self.animation(transitionContext, isPresenting);
    }
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!_isPresenting)
        [self.superviewOfPresentingView addSubview: self.presentingViewController.view];
    
    [_transitionContext completeTransition:YES];
    _transitionContext = nil;
}

@end



#pragma mark-
#pragma mark -
#pragma mark UIViewController (Transitioning)

@implementation UIViewController (Transitioning)
/*
#pragma mark Runtime 方法交换
+ (void)load{
    // 保证只能交换一次，避免多次交换导致最终又交换回来了
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIViewController");
        Method method1 = class_getInstanceMethod(cls, @selector(dismissViewControllerAnimated:completion:));
        Method method2 = class_getInstanceMethod(cls, @selector(tl_dismissViewControllerAnimated:completion:));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)tl_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    ((TLSwipeAnimator *)_animator).gestureRecognizer = nil;
    [self tl_dismissViewControllerAnimated:flag completion:completion];
}
*/

#pragma mark Runtime 对象关联
- (void)setTransitionDuration:(NSTimeInterval)transitionDuration
{
    objc_setAssociatedObject(self, @selector(transitionDuration), @(transitionDuration), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)transitionDuration
{
    NSTimeInterval d = [objc_getAssociatedObject(self, _cmd) doubleValue];
    return d <= 0 ? 0.45f : d;
}

- (void)setDisableInteractivePopGestureRecognizer:(BOOL)disableInteractivePopGestureRecognizer {
    objc_setAssociatedObject(self,
                             @selector(disableInteractivePopGestureRecognizer),
                             @(disableInteractivePopGestureRecognizer),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disableInteractivePopGestureRecognizer {
    return [objc_getAssociatedObject(self, _cmd) boolValue];;
}

#pragma mark 注册手势
// pop / dismiss interactive recognizer for transition
- (void)registerInteractivePopRecognizerDirectionType:(TLDirectionType)directionType {
    if (self.disableInteractivePopGestureRecognizer) return;
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactivePopRecognizerAction:)];
    interactiveTransitionRecognizer.edges = [self getEdgeWithDirectionType:directionType];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

- (void)interactivePopRecognizerAction:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
//    if (self.disableInteractivePopGestureRecognizer) return;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        ((TLSwipeAnimator *)_animator).gestureRecognizer = gestureRecognizer;
        if (((TLSwipeAnimator *)_animator).isPushOrPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIRectEdge)getEdgeWithDirectionType:(TLDirectionType)directionType {
    return directionType == TLDirectionTypeLeft ? UIRectEdgeRight : UIRectEdgeLeft;
}

#pragma mark API
- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   completion:(void (^ __nullable)(void))completion
{
    vc.modalTransitionStyle = style;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
              swipeTargetEdge:(UIRectEdge)targetEdge
             reverseOfDismiss:(BOOL)isReverse
                   completion:(void (^ __nullable)(void))completion
{
    // NS_VALID_UNTIL_END_OF_SCOPE : 表明存储在某些局部变量(栈)中的值,在优化时不被编会译器强制释放
    TLPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[TLPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    presentationController.animationType = TLPresentationAnimationTypeSwipe;
    presentationController.targetEdge = targetEdge;
    presentationController.isReverse = isReverse;
  
    vc.transitioningDelegate = presentationController;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
                    swipeType:(TLSwipeType)swipeType
             presentDirection:(TLDirectionType)presentDirection
             dismissDirection:(TLDirectionType)dismissDirection
                   completion:(void (^ __nullable)(void))completion
{
    _animator = [[TLSwipeAnimator alloc] init];
    TLSwipeAnimator *animator = (TLSwipeAnimator *)_animator;
    animator.isPushOrPop = NO;
    animator.swipeType = swipeType;
    animator.pushDirection = presentDirection;
    animator.popDirection = dismissDirection;
    animator.transitionDuration = self.transitionDuration;
    [vc registerInteractivePopRecognizerDirectionType: dismissDirection];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = animator;
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
    TLPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[TLPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    presentationController.animationType = TLPresentationAnimationTypeCustom;
    presentationController.animation = animation;
    
    vc.transitioningDelegate = presentationController;
    [self presentViewController:vc animated:YES completion:completion];
}


// 临时保存，用于pop
id <UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate> _animator = nil;

-(void)pushViewController:(UIViewController *)vc
                swipeType:(TLSwipeType)swipeType
            pushDirection:(TLDirectionType)pushDirection
             popDirection:(TLDirectionType)popDirection
{
    BOOL falg = ![self isMemberOfClass:[UINavigationController class]]; // 不是UINavigationController
    NSAssert(falg, @"%s 方法n不能用UINavigationController发起调用，请直接用view controllerd调用", __func__);
    NSAssert(self.navigationController, (@"控制器 %@ 没有navigationController，无法push"), self);
    
    _animator = [[TLSwipeAnimator alloc] init];
    TLSwipeAnimator *animator = (TLSwipeAnimator *)_animator;
    animator.isPushOrPop = YES;
    animator.swipeType = swipeType;
    animator.pushDirection = pushDirection;
    animator.popDirection = popDirection;
    animator.transitionDuration = self.transitionDuration;
    [vc registerInteractivePopRecognizerDirectionType: popDirection];

    self.navigationController.delegate = _animator;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc{
    _animator = nil;
    tl_LogFunc;
}


@end
