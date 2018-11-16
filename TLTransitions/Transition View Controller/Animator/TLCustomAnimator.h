//
//  TLCustomAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  Custom Animator

#import "TLAnimatorProtocol.h"

/// 自定义动画样式
typedef void(^TLAnimateTransition)(id <UIViewControllerContextTransitioning>, BOOL);

NS_ASSUME_NONNULL_BEGIN

@interface TLCustomAnimator : UIPresentationController <TLAnimatorProtocol>
@property(nonatomic, copy) TLAnimateTransition animation;

// 请用 - initWithPresentedViewController: presentingViewController: 方法创建实例
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
