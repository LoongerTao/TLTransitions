//
//  TLSwipeAnimator.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/2.
//  Copyright © 2018 故乡的云. All rights reserved.
//  滑动边缘区域进入和退出

#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLSwipeAnimator : NSObject <TLAnimatorProtocol>

/// push方向/present
@property (nonatomic, readwrite) TLDirection pushDirection;
/// pop方向/dismiss
@property (nonatomic, readwrite) TLDirection popDirection;
/// 滑入方式
@property (nonatomic, assign) TLSwipeType swipeType;

+ (instancetype)animatorWithSwipeType:(TLSwipeType)swipeType
                        pushDirection:(TLDirection)pushDirection
                         popDirection:(TLDirection)popDirection;

@end

NS_ASSUME_NONNULL_END
