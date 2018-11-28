//
//  TLPercentDrivenInteractiveTransition.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/9.
//  Copyright © 2018 故乡的云. All rights reserved.
//  手势交互百分比控制

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer
                          edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// 动画完成多少百分比后，释放手指可以完成转场,少于该值将取消转场。取值范围：[0 ，1），默认：0.5
@property(nonatomic, assign) CGFloat percentOfFinishInteractiveTransition;
/// 动画完成多少百分比后，直接完成转场（默认：0 表示不启用）（0 ，1]
@property(nonatomic, assign) CGFloat percentOfFinished;
/// 用来调节完成完成百分比，数值越大越快（默认：0，小于0.5 表示不启用）
@property(nonatomic, assign) CGFloat speedOfPercent;
@end

NS_ASSUME_NONNULL_END
