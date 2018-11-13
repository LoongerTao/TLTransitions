//
//  TLSwipeAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/2.
//  Copyright © 2018 故乡的云. All rights reserved.
//  滑动边缘区域进入和退出

#import <UIKit/UIKit.h>
#import "TLGlobalConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLSwipeAnimator : NSObject
<
UIViewControllerAnimatedTransitioning,
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate
>

/// 动画时间
@property(nonatomic, assign) NSTimeInterval transitionDuration;
/// push方向/present
@property (nonatomic, readwrite) TLDirectionType pushDirection;
/// pop方向/dismiss
@property (nonatomic, readwrite) TLDirectionType popDirection;
/// 滑入方式
@property (nonatomic, assign) TLSwipeType swipeType;
/// Push Or Pop(default: NO ,present)
@property (nonatomic, assign) BOOL isPushOrPop;

// 交互手势(滑动方向即动画方向)
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * _Nullable gestureRecognizer;
@end


@interface TLSwipeTransitionInteractionController : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
