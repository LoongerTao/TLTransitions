//
//  TLTransitionDelegate.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  view vontroller transition delegate / navigation controller delegate

#import "TLGlobalConfig.h"
@protocol TLAnimatorProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface TLTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

// 交互手势(滑动方向即动画方向)。 必须在手势唤醒的时候(UIGestureRecognizerStateBegan)赋值，否则提前赋值会导致转场失败
@property (nonatomic, weak) UIPanGestureRecognizer * _Nullable interactiveRecognizer;

// 临时交互手势的方向（每次唤醒手势都需要重新设置）--> 只生效一次（优先级最高）
@property (nonatomic, assign) TLDirection tempInteractiveDirection;

/// 采用单例模式是为了实现，多级Push转场，防止后面的转场覆盖前面的，导致pop动画被后面的取代
+ (instancetype)sharedInstace;
+ (void)addAnimator:(id<TLAnimatorProtocol>)animator  forKey:(UIViewController *)key;
+ (void)removeAnimatorForKey:(UIViewController *)key;
+ (id<TLAnimatorProtocol>)animatorForKey:(UIViewController *)key;

@end

NS_ASSUME_NONNULL_END
