//
//  TLPercentDrivenInteractiveTransition.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/9.
//  Copyright © 2018 故乡的云. All rights reserved.
//  手势交互百分比控制

#import "TLPercentDrivenInteractiveTransition.h"

@interface TLPercentDrivenInteractiveTransition ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak, readonly) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;
@end

@implementation TLPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge
{
    NSAssert(edge == UIRectEdgeTop || edge == UIRectEdgeBottom ||
             edge == UIRectEdgeLeft || edge == UIRectEdgeRight,
             @"edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        _percentOfFinishInteractiveTransition = 0.5;
        
        // 添加Self作为手势识别器的观察者，以便该对象在用户移动手指时接收更新。
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (instancetype)init
{
    NSString *reason = @"Use -initWithGestureRecognizer:edgeForDragging:";
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}


- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 保存 transitionContext
    self.transitionContext = transitionContext;
    
    [super startInteractiveTransition:transitionContext];
}


// 返回交互过渡完成的百分比。
- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    // 因为视图控制器将作为动画的一部分在屏幕上或从屏幕上滑动，因此我们希望将计算建立在不移动视图的坐标空间：transitionContext.containerView。
    UIView *containerView = self.transitionContext.containerView;
    
    CGPoint locationInSourceView = [gesture locationInView:containerView];
    CGFloat width = CGRectGetWidth(containerView.bounds);
    CGFloat height = CGRectGetHeight(containerView.bounds);
    
    CGFloat percent = 0.f;
    
    if ([gesture isMemberOfClass: [UIScreenEdgePanGestureRecognizer class]]) {
        if (self.edge == UIRectEdgeRight) {
            percent = (width - locationInSourceView.x) / width;
            
        } else {
            // 垂直方向的转场以左侧滑作为依据
            percent = locationInSourceView.x / width;
        }
        
    }else {
        
        if (self.edge == UIRectEdgeRight) {
            percent = (width - locationInSourceView.x) / width;
            
        } else if (self.edge == UIRectEdgeLeft) {
            // 垂直方向的转场以左侧滑作为依据
            percent = locationInSourceView.x / width;
    
        } else if (self.edge == UIRectEdgeBottom) {
            percent = (height - locationInSourceView.y) / height;
    
        }else if (self.edge == UIRectEdgeTop) {
            percent = locationInSourceView.y / height;
        }
    }
    
    if (_speedOfPercent >= 0.2) {
        percent *= _speedOfPercent;
    }
    
    return percent;
}


// Action method for the gestureRecognizer.
- (void)gestureRecognizeDidUpdate:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            // 开始状态由视图控制器处理。触发 presentation or dismissal.
            break;
        case UIGestureRecognizerStateChanged:
            if(_percentOfFinished > 0 && [self percentForGesture:gestureRecognizer] >= _percentOfFinished) {
                [self finishInteractiveTransition];
            }else {
                // 拖动中,更新百分比
                [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            }
            break;
        case UIGestureRecognizerStateEnded:
            
            // 根据拖动比例决定是否转场
            if ([self percentForGesture:gestureRecognizer] >= _percentOfFinishInteractiveTransition)
                [self finishInteractiveTransition];
            else
                [self cancelInteractiveTransition];
            break;
        default:
            // 手势被打断，取消转场
            [self cancelInteractiveTransition];
            break;
    }
}

@end
