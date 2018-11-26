//
//  TLAnimator.h
//   https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/21.
//  Copyright © 2018 故乡的云. All rights reserved.
//  个人收集的一些动画

#import "TLAnimatorProtocol.h"


typedef enum : NSUInteger {
    TLAnimatorTypeOpen  = 0,    // 开门
    TLAnimatorTypeOpen2,        // 四块中间绽放
    TLAnimatorTypeBevel,        // 右边斜角切入,只支持present/dismiss转场
    TLAnimatorTypeTiltRight,    // 向右边倾斜旋转
    TLAnimatorTypeTiltLeft,     // 向左边倾斜旋转
    TLAnimatorTypeFrame,        // 指定初始frame和最终frame（相对keyWindow）【需根据情况对initialFrame、finalFrame初始化】
    TLAnimatorRectScale,        // 指定一个rect范围，对其进行缩放和平移【需对fromRect、toRect初始化】,【Push时rectView初始化】
    TLAnimatorCircular,         // 圆形转场，可以指定center（默认，屏幕中心）
} TLAnimatorType;

NS_ASSUME_NONNULL_BEGIN

@interface TLAnimator : NSObject <TLAnimatorProtocol>
@property(nonatomic, assign) TLAnimatorType type;

//****** 仅在TLAnimatorTypeFrame模式下有效 ******//
/// 开始转场的frame，默认：[center, sizeZero]
@property(nonatomic, assign) CGRect initialFrame;
/// 转场结束的frame，默认：系统默认. 
@property(nonatomic, assign) CGRect finalFrame;

//****** 仅在TLAnimatorRectScale模式下有效 ******//
/// 开始转场的frame，默认：[center, sizeZero]
@property(nonatomic, assign) CGRect fromRect;
/// 转场结束的frame，默认：系统默认finalFrame.
@property(nonatomic, assign) CGRect toRect;
/// 只显示和缩放fromRect区域，其他区域隐藏。默认：NO，fromRect区域以外也显示，并跟随缩放平移
@property(nonatomic, assign) BOOL isOnlyShowRangeForRect;
/// 缩放平移的View[rectView = 赋值的Viewf的快照]，Push的时候必传（push时没能截图成功）
@property(nonatomic, strong) UIView *rectView;

//****** TLAnimatorCircular模式下有效 ******//
/// 圆形转场的center（默认，屏幕中心）
@property(nonatomic, assign) CGPoint center;
/// 默认初始半径（默认：0）
@property(nonatomic, assign) CGFloat startRadius;

+ (instancetype)animatorWithType:(TLAnimatorType)type;
@end

NS_ASSUME_NONNULL_END
