//
//  TLCATranstionAndCustomAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/14.
//  Copyright © 2018 故乡的云. All rights reserved.
//  CATransition Animator

#import "TLGlobalConfig.h"
#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * CATransiton类型动画不支持交互百分比控制，所以侧滑只能唤起dismiss/pop，不能控制进度
 */

@interface TLCATransitonAnimator : UIPresentationController <TLAnimatorProtocol>
/*
* CATransitionType 转场动画类型（本质NSString类型）
*          `kCATransitionFade`
*          `kCATransitionMoveIn`
*          `kCATransitionPush`
*          `kCATransitionReveal`
*          其它官方私有API：@"cube"、@"suckEffect"、@"oglFlip"、@"rippleEffect"、@"pageCurl"、@"pageUnCurl"、
*          @"cameraIrisHollowOpen"、@"cameraIrisHollowClose"
*/

@property(nonatomic, assign) CATransitionType tType;
@property(nonatomic, assign) TLDirection direction;
@property(nonatomic, assign) CATransitionType tTypeOfDismiss;
@property(nonatomic, assign) TLDirection directionOfDismiss;

// 请用 - initWithPresentedViewController: presentingViewController: 方法创建实例 或类方法
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)animatorWithPresentedViewController:(UIViewController *)presentedViewController
                           presentingViewController:(UIViewController *)presentingViewController
                                     transitionType:(CATransitionType)tType
                                          direction:(TLDirection)direction
                            transitionTypeOfDismiss:(CATransitionType)tTypeOfDismiss
                                 directionOfDismiss:(TLDirection)directionOfDismiss;
@end

NS_ASSUME_NONNULL_END
