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

#pragma mark-
#pragma mark UIViewController (Transitioning)

@implementation UIViewController (Transitioning)

#pragma mark Runtime 对象关联
- (void)setTransitionDelegate:(TLTransitionDelegate * _Nonnull)transitionDelegate {
    objc_setAssociatedObject(self, @selector(transitionDelegate), transitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TLTransitionDelegate *)transitionDelegate {
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

- (void)interactivePopRecognizerAction:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
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
            self.transitionDelegate.popGestureRecognizer = nil;
        }else {
            self.transitionDelegate.popGestureRecognizer = gestureRecognizer;
        }
        
        if (animator.isPushOrPop){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark API
#pragma mark - present / dismiss
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
                   completion:(void (^)(void))completion
{
    animator.isPushOrPop = NO;
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.45f;
    }
    
    TLDirection dir = TLDirectionToRight;
    if ([animator respondsToSelector:@selector(directionForDragging)]) {
        dir = [animator directionForDragging];
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
               transitionType:(CATransitionType)tType
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
    BOOL falg = ![self isMemberOfClass:[UINavigationController class]]; // 不能是UINavigationController
    NSAssert(falg, @"%s 方法n不能用UINavigationController发起调用，请直接用view controllerd调用", __func__);
    NSAssert(self.navigationController, (@"控制器 %@ 没有navigationController，无法push"), self);
    
    animator.isPushOrPop = YES;
    if(animator.transitionDuration == 0){ // 默认值
        animator.transitionDuration = 0.45f;
    }
    
    TLDirection dir = TLDirectionToRight;
    if ([animator respondsToSelector:@selector(directionForDragging)]) {
        dir = [animator directionForDragging];
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
            transitionType:(CATransitionType)tType
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

- (void)dealloc{
    tl_Log(@"%@ %s", [self class], __func__);

    [TLTransitionDelegate removeAnimatorForKey:self];
}


@end
