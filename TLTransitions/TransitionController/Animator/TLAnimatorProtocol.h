//
//  TLAnimatorProtocol.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/14.
//  Copyright © 2018 故乡的云. All rights reserved.
//  自定义转场动画协议

#import "TLGlobalConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TLAnimatorProtocol <UIViewControllerAnimatedTransitioning>

@required

/// 动画时间(默认值：0.45s，最小值必须大于0.01f)
@property(nonatomic, assign) NSTimeInterval transitionDuration;
/// Push Or Pop(default: NO ,present)
@property (nonatomic, assign) BOOL isPushOrPop;

/// 侧滑dismiss/pop的方向。
- (TLDirection)directionForDragging;

@optional
/// 手势动画完成多少百分比后，释放手指可以完成转场,少于该值将取消转场。取值范围：[0 ，1），默认：0.5 ,小于等于0表示不支持百分比控制
- (CGFloat)percentOfFinishInteractiveTransition;
@end

NS_ASSUME_NONNULL_END

