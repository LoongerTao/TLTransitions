//
//  TLSystemAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//  系统动画，只支持modal

#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLSystemAnimator : NSObject <TLAnimatorProtocol>
/*
typedef NS_ENUM(NSInteger, UIModalTransitionStyle) {
    UIModalTransitionStyleCoverVertical = 0,
    UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
    UIModalTransitionStyleCrossDissolve,
    UIModalTransitionStylePartialCurl NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
};
 */
@property(nonatomic, assign) UIModalTransitionStyle style;

+ (instancetype)animatorWithTransitionStyle:(UIModalTransitionStyle)style;
@end

NS_ASSUME_NONNULL_END
