//
//  TLTransitionDelegate.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  view vontroller transition delegate / navigation controller delegate

#import "TLTransitionDelegate.h"
#import "TLPercentDrivenInteractiveTransition.h"
#import "TLAnimatorProtocol.h"

@interface TLTransitionDelegate ()
@property(nonatomic, strong) id<TLAnimatorProtocol> currentAnimator;
/// 动画负责者集合
@property(nonatomic, strong) NSMutableDictionary <NSString *, id<TLAnimatorProtocol>>*animators;
@end

@implementation TLTransitionDelegate

static TLTransitionDelegate *_instace;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedInstace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (NSMutableDictionary<NSString *,id<TLAnimatorProtocol>> *)animators {
    if (_animators == nil) {
        _animators = [NSMutableDictionary dictionary];
    }
    return  _animators;
}

+ (void)addAnimator:(id<TLAnimatorProtocol>)animator  forKey:(UIViewController *)key {
    NSString *KEY = [self keyWithViewController:key];
    
    NSLog(@"add KEY: %@",KEY);
    
    [[[self sharedInstace] animators] setObject:animator forKey:KEY];
    _instace.currentAnimator = animator;
}

+ (void)removeAnimatorForKey:(UIViewController *)key {
    NSString *KEY = [self keyWithViewController:key];
    if ([[[[self sharedInstace] animators] allKeys] containsObject:KEY]) {
        [[[self sharedInstace] animators] removeObjectForKey:KEY];
        _instace.currentAnimator = nil;
    }
}

+ (id<TLAnimatorProtocol>)animatorForKey:(UIViewController *)key {
    NSString *KEY = [self keyWithViewController:key];
    if ([[[[self sharedInstace] animators] allKeys] containsObject:KEY]) {
        _instace.currentAnimator = [[[self sharedInstace] animators] objectForKey:KEY];
        return  _instace.currentAnimator;
    }
    return nil;
}

+ (NSString *)keyWithViewController:(UIViewController *)viewController {
    BOOL flag = [viewController isKindOfClass:[UIViewController class]];
    NSAssert(flag, @"key: %@ 不是UIViewController类型]", viewController);

    return [NSString stringWithFormat:@"%p", viewController];
}

// push / pop
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    UIViewController *key;
    if(operation == UINavigationControllerOperationPush) {
        key = toVC;
    }else if (operation == UINavigationControllerOperationPop) {
        key = fromVC;
    }else {
        return nil;
    }
    return [[self class] animatorForKey:key];
}

#pragma mark 转场手势交互管理者（push / pop）
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    id <TLAnimatorProtocol> tempAnimator = (id<TLAnimatorProtocol>)animationController;
    return [self interactiveTransitionWithAnimator:tempAnimator];
}

// present / dismiss
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[self class] animatorForKey:presented];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[self class] animatorForKey:dismissed];
}

#pragma mark 转场手势交互管理者（present / dismiss）
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    id <TLAnimatorProtocol> tempAnimator =  (id<TLAnimatorProtocol>)animator;
    return [self interactiveTransitionWithAnimator:tempAnimator];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    
    id <TLAnimatorProtocol> tempAnimator =  (id<TLAnimatorProtocol>)animator;
    return [self interactiveTransitionWithAnimator:tempAnimator];
}

- (TLPercentDrivenInteractiveTransition *)interactiveTransitionWithAnimator:(id <TLAnimatorProtocol>)animator {
    if (_interactiveRecognizer) {
        UIRectEdge edge = [self getPopEdge];
        TLPercentDrivenInteractiveTransition *interactiveTransition;
        interactiveTransition = [[TLPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:_interactiveRecognizer edgeForDragging: edge];
        _interactiveRecognizer = nil;
        
        if ([animator respondsToSelector:@selector(percentOfFinishInteractiveTransition)]) {
            CGFloat percent = [animator percentOfFinishInteractiveTransition];
            interactiveTransition.percentOfFinishInteractiveTransition = percent;
        }
        if ([animator respondsToSelector:@selector(percentOfFinished)]) {
            interactiveTransition.percentOfFinished = [animator percentOfFinished];
        }
        if ([animator respondsToSelector:@selector(speedOfPercent)]) {
            interactiveTransition.speedOfPercent = [animator speedOfPercent];
        }
        
        
        return interactiveTransition;
    } else {
        return nil;
    }
}

- (UIRectEdge)getPopEdge {
    if(_popGestureRecognizerDirection >= TLDirectionToTop && _popGestureRecognizerDirection <= TLDirectionToRight ){
        UIRectEdge edge = getRectEdge(_popGestureRecognizerDirection);
        _popGestureRecognizerDirection = -1;
        return edge;
    }
    
    UIRectEdge edge = UIRectEdgeLeft;
    if ([_instace.currentAnimator respondsToSelector:@selector(directionForDragging)]) {
        edge = getRectEdge([ _instace.currentAnimator directionForDragging]);
    }
    return edge;
}

- (void)dealloc {
    tl_LogFunc;
}
@end
