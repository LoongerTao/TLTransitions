//
//  TLViewTransitionAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  UIView Transition

#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * CATransiton类型动画不支持交互百分比控制，所以侧滑只能唤起dismiss/pop，不能控制进度
 */
@interface TLViewTransitionAnimator : NSObject <TLAnimatorProtocol>

@end

NS_ASSUME_NONNULL_END
