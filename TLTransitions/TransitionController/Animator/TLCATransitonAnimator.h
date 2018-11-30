//
//  TLCATranstionAndCustomAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/14.
//  Copyright © 2018 故乡的云. All rights reserved.
//  CATransition Animator

#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * CATransiton类型动画不支持交互百分比控制，所以侧滑只能唤起dismiss/pop，不能控制进度
 */
@interface TLCATransitonAnimator : NSObject <TLAnimatorProtocol>
// 此处不继承UIPresentationController，
// 1. 是为了解除循环引用（toVc --> transitionDelegate（单例） --> animatior --> toVc）
// 2. 此处需求只需要遵守基本协议即可，不继承UIPresentationController也没影响

@property(nonatomic, assign) TLTransitionType tType;
@property(nonatomic, assign) TLDirection direction;
@property(nonatomic, assign) TLTransitionType tTypeOfDismiss;
@property(nonatomic, assign) TLDirection directionOfDismiss;

+ (instancetype)animatorWithTransitionType:(TLTransitionType)tType
                                 direction:(TLDirection)direction
                   transitionTypeOfDismiss:(TLTransitionType)tTypeOfDismiss
                        directionOfDismiss:(TLDirection)directionOfDismiss;
@end

NS_ASSUME_NONNULL_END
