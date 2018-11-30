//
//  TLSystemAnimator.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//  系统动画，只支持modal

#import "TLSystemAnimator.h"

@implementation TLSystemAnimator

+ (instancetype)animatorWithTransitionStyle:(UIModalTransitionStyle)style {
    TLSystemAnimator *anmt = [self new];
    anmt.style = style;
    return anmt;
}



#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (TLDirection)interactiveDirectionOfPop {
    return TLDirectionToRight;
}

//
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

@end
