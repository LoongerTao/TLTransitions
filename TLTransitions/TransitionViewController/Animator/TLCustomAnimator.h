//
//  TLCustomAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  Custom Animator

#import "TLAnimatorProtocol.h"

/// 自定义动画样式
typedef void(^TLTransitionAnimation)(id <UIViewControllerContextTransitioning>, BOOL);

NS_ASSUME_NONNULL_BEGIN

@interface TLCustomAnimator : NSObject <TLAnimatorProtocol>
@property(nonatomic, copy) TLTransitionAnimation animation;

+ (instancetype)animatorWithAnimation:(void (^)(id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation;
@end

NS_ASSUME_NONNULL_END
