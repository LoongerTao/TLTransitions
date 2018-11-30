//
//  UIViewController+Transitioning.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "UIViewController+Transitioning.h"
#import <objc/runtime.h>
#import "TLTransitionDelegate.h"
#import "TLCATransitonAnimator.h"
#import "TLSwipeAnimator.h"
#import "TLCustomAnimator.h"
#import "TLAnimatorProtocol.h"
#import "TLSystemAnimator.h"

#pragma mark-
#pragma mark UIViewController (Transitioning)

@implementation UIViewController (Transitioning)
#pragma mark Runtime 方法交换
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [UIViewController class];
        Method method1 = class_getInstanceMethod(cls, NSSelectorFromString(@"dealloc"));
        Method method2 = class_getInstanceMethod(cls, @selector(tl_dealloc));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)tl_dealloc{
    
    tl_Log(@"%@ %s", [self class], __func__);
    [TLTransitionDelegate removeAnimatorForKey:self];
    
    [self tl_dealloc];
}

#pragma mark Runtime 对象关联
- (void)setTransitionDelegate:(TLTransitionDelegate * _Nonnull)transitionDelegate {
    objc_setAssociatedObject(self, @selector(transitionDelegate), transitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TLTransitionDelegate *)transitionDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWillPresentViewController:(UIViewController * _Nullable)willPresentViewController{
    objc_setAssociatedObject(self, @selector(willPresentViewController), willPresentViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)willPresentViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDisableInteractivePopGestureRecognizer:(BOOL)disableInteractivePopGestureRecognizer {
    objc_setAssociatedObject(self,
                             @selector(disableInteractivePopGestureRecognizer),
                             @(disableInteractivePopGestureRecognizer),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disableInteractivePopGestureRecognizer {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark 注册手势
// push or present
- (void)registerInteractiveTransitionToViewController:(UIViewController *)viewController animator:(id <TLAnimatorProtocol>)animator

{
    // 手势
    TLDirection direction = animator.interactiveDirectionOfPush;
    if (direction < TLDirectionToTop) {
        if ([animator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
            direction = [animator interactiveDirectionOfPop];
        }
    }
    SEL sel = @selector(interactivePushRecognizerAction:);
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:sel];
    interactiveTransitionRecognizer.edges = [self getEdgeWithDirection:direction];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.45f;
    }
    
    TLTransitionDelegate *tDelegate = [TLTransitionDelegate sharedInstace];
    [TLTransitionDelegate addAnimator:animator forKey:viewController];
   
    viewController.transitionDelegate = tDelegate;
    self.willPresentViewController = viewController;
    
    if(animator.isPushOrPop) {
        self.navigationController.delegate = tDelegate;
    }else {
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        viewController.transitioningDelegate = tDelegate;
    }
    
    // 注册手势
    if(animator.interactiveDirectionOfPush > TLDirectionToTop &&
       animator.interactiveDirectionOfPush != animator.interactiveDirectionOfPop){
        
        [viewController registerInteractivePopRecognizerWithDirection: animator.interactiveDirectionOfPop];
    }
}

- (void)interactivePushRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.transitionDelegate == nil) {
            return;
        }
        
        id <TLAnimatorProtocol>animator = [TLTransitionDelegate animatorForKey:self.willPresentViewController];
        NSAssert(animator, @"animator = nil,异常");
        if (animator == nil) return;
        
        if ([animator respondsToSelector:@selector(percentOfFinishInteractiveTransition)] &&
            [animator percentOfFinishInteractiveTransition] <= 0) {
            // 不支持百分比控制
            self.willPresentViewController.transitionDelegate.interactiveRecognizer = nil;
        }else {
            self.willPresentViewController.transitionDelegate.interactiveRecognizer = gestureRecognizer;
        }
        
        if (animator.isPushOrPop){
            NSAssert(![self isMemberOfClass:[UINavigationController class]], @"%s 方法n不能用UINavigationController发起调用，请直接用view controllerd调用", __func__);
            NSAssert(self.navigationController, (@"控制器 %@ 没有navigationController，无法push"), self);
            NSAssert(![animator isMemberOfClass:[TLSystemAnimator class]], (@"TLSystemAnimator 只支持modal"), self);
            [self.navigationController pushViewController:self.willPresentViewController animated:YES];
        }else {
            [self presentViewController:self.willPresentViewController animated:YES completion:nil];
        }
    }
}


// register pop or dismiss interactive recognizer for transition
- (UIScreenEdgePanGestureRecognizer *)registerInteractivePopRecognizerWithDirection:(TLDirection)direction {
    
    if (self.disableInteractivePopGestureRecognizer) return nil;
    
    SEL sel = @selector(interactivePopRecognizerAction:);
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:sel];
    interactiveTransitionRecognizer.edges = [self getEdgeWithDirection:direction];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    return interactiveTransitionRecognizer;
}

- (UIRectEdge)getEdgeWithDirection:(TLDirection)direction {
    return direction == TLDirectionToLeft ? UIRectEdgeRight : UIRectEdgeLeft;
}

- (void)interactivePopRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.transitionDelegate == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        id <TLAnimatorProtocol>animator = [TLTransitionDelegate animatorForKey:self];
        NSAssert(animator, @"animator = nil,异常");
        if (animator == nil) return;
        
        if ([animator respondsToSelector:@selector(percentOfFinishInteractiveTransition)] &&
            [animator percentOfFinishInteractiveTransition] <= 0) {
            // 不支持百分比控制
            self.transitionDelegate.interactiveRecognizer = nil;
        }else {
            self.transitionDelegate.interactiveRecognizer = gestureRecognizer;
        }
        
        if (animator.isPushOrPop){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark API
#pragma mark - modal
- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   completion:(void (^ __nullable)(void))completion
{
    vc.modalTransitionStyle = style;
    [self presentViewController:vc animated:YES completion:completion];
    
    [vc registerInteractivePopRecognizerWithDirection:TLDirectionToBottom];
}

- (void)presentViewController:(UIViewController *)viewController
                     animator:(id<TLAnimatorProtocol>)animator
                   completion:(void (^ __nullable)(void))completion;
{
    animator.isPushOrPop = NO;
    if([animator isMemberOfClass:[TLSystemAnimator class]]) {
        TLSystemAnimator *anim = (TLSystemAnimator *)animator;
        [self presentViewController:viewController transitionStyle:anim.style completion:completion];
        return;
    }
    
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.45f;
    }
    
    TLDirection dir = TLDirectionToRight;
    if ([animator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
        dir = [animator interactiveDirectionOfPop];
    }
    TLTransitionDelegate *tDelegate = [TLTransitionDelegate sharedInstace];
    [TLTransitionDelegate addAnimator:animator forKey:viewController];
    
    [viewController registerInteractivePopRecognizerWithDirection: dir];
    viewController.transitionDelegate = tDelegate;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = tDelegate;
    [self presentViewController:viewController animated:YES completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
                    swipeType:(TLSwipeType)swipeType
             presentDirection:(TLDirection)presentDirection
             dismissDirection:(TLDirection)dismissDirection
                   completion:(void (^ __nullable)(void))completion
{
    TLSwipeAnimator *animator = [[TLSwipeAnimator alloc] init];
    animator.isPushOrPop = NO;
    animator.swipeType = swipeType;
    animator.pushDirection = presentDirection;
    animator.popDirection = dismissDirection;
    
    [self presentViewController:vc animator:animator completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
               transitionType:(TLTransitionType)tType
                    direction:(TLDirection)direction
             dismissDirection:(TLDirection)directionOfDismiss
                   completion:(void (^ __nullable)(void))completion
{
    TLCATransitonAnimator *animator;
    animator = [TLCATransitonAnimator animatorWithTransitionType:tType
                                                       direction:direction
                                         transitionTypeOfDismiss:tType
                                              directionOfDismiss:directionOfDismiss];
    
    [self presentViewController:vc animator:animator completion:completion];
}

- (void)presentViewController:(UIViewController *)vc
              customAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                   completion:(void (^ __nullable)(void))completion
{
    TLCustomAnimator *animator = [TLCustomAnimator animatorWithAnimation:animation];
    [self presentViewController:vc animator:animator completion:completion];
}

#pragma mark - Push / pop
- (void)pushViewController:(UIViewController *)viewController animator:(id<TLAnimatorProtocol>)animator
{
    // 不能是UINavigationController
    NSAssert(![self isMemberOfClass:[UINavigationController class]], @"%s 方法n不能用UINavigationController发起调用，请直接用view controllerd调用", __func__);
    NSAssert(self.navigationController, (@"控制器 %@ 没有navigationController，无法push"), self);
    NSAssert(![animator isMemberOfClass:[TLSystemAnimator class]], (@"TLSystemAnimator 只支持modal"), self);
    
    animator.isPushOrPop = YES;
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.45f;
    }
    
    TLDirection dir = TLDirectionToRight;
    if ([animator respondsToSelector:@selector(interactiveDirectionOfPop)]) {
        dir = [animator interactiveDirectionOfPop];
    }
    [viewController registerInteractivePopRecognizerWithDirection: dir];
    
    [TLTransitionDelegate addAnimator:animator forKey:viewController];
    TLTransitionDelegate *tDelegate = [TLTransitionDelegate sharedInstace];
    
    viewController.transitionDelegate = tDelegate;
    self.navigationController.delegate = tDelegate;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)pushViewController:(UIViewController *)vc
                swipeType:(TLSwipeType)swipeType
            pushDirection:(TLDirection)pushDirection
             popDirection:(TLDirection)popDirection
{
    TLSwipeAnimator *animator = [[TLSwipeAnimator alloc] init];
    animator.isPushOrPop = YES;
    animator.swipeType = swipeType;
    animator.pushDirection = pushDirection;
    animator.popDirection = popDirection;

    [self pushViewController:vc animator:animator];
}

- (void)pushViewController:(UIViewController *)vc
            transitionType:(TLTransitionType)tType
                 direction:(TLDirection)direction
          dismissDirection:(TLDirection)directionOfPop
{
    TLCATransitonAnimator *animator;
    animator = [TLCATransitonAnimator animatorWithTransitionType:tType
                                                       direction:direction
                                         transitionTypeOfDismiss:tType
                                              directionOfDismiss:directionOfPop];    
    [self pushViewController:vc animator:animator];
}

- (void)pushViewController:(UIViewController *)vc
           customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPush))animation
{    
    TLCustomAnimator *animator = [TLCustomAnimator animatorWithAnimation:animation];
    animator.animation = animation;
   
    [self pushViewController:vc animator:animator];
}


@end
