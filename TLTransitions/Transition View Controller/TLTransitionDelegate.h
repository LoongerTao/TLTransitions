//
//  TLTransitionDelegate.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  view vontroller transition delegate / navigation controller delegate

#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

/// 动画负责者
@property(nonatomic, strong, readonly) id<TLAnimatorProtocol> animator;
/// Push Or Pop(default: NO ,present)
@property (nonatomic, assign, readonly) BOOL isPushOrPop;


// 交互手势(滑动方向即动画方向)。 必须在手势唤醒的时候赋值，否则提前赋值会导致转场失败
@property (nonatomic, weak) UIScreenEdgePanGestureRecognizer * _Nullable popGestureRecognizer;

- (instancetype)initWithAnimator:(nonnull id <TLAnimatorProtocol>)animator isPushOrPop:(BOOL)isPushOrPop NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
