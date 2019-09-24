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

+ (instancetype)animatorWithStyle:(UIModalTransitionStyle)style fullScreen:(BOOL)isFullScreen {
    TLSystemAnimator *anmt = [self new];
    anmt.style = style;
    if (@available(iOS 13.0, *)) {
        anmt.isFullScreen = isFullScreen;
        NSAssert(
                 style != UIModalTransitionStylePartialCurl,
                 @"%s iOS 13+ 不支持 UIModalTransitionStylePartialCurl", __func__
                 );
    }else {
        anmt.isFullScreen = YES;
    }
    
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
