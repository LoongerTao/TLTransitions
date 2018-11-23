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
- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer
                          edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// 动画完成多少百分比后，释放手指可以完成转场,少于该值将取消转场。取值范围：[0 ，1），默认：0.5
@property(nonatomic, assign) CGFloat percentOfFinishInteractiveTransition;
@end

NS_ASSUME_NONNULL_END
