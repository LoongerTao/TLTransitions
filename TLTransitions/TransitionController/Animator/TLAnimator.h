//
//  TLAnimator.h
//   https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/21.
//  Copyright © 2018 故乡的云. All rights reserved.
//  个人收集的一些动画

#import "TLAnimatorProtocol.h"

// 下面所以计算frame或point都需要根据实际情况调整：相对keyWindow或相对viewController.view [因为不同情况下，参考会有所差异]
typedef enum : NSUInteger {
    TLAnimatorTypeOpen  = 0,        // 开门， 用`removeScaleAnimation`属性可以取消缩放
    TLAnimatorTypeOpen2 = 1,        // 四块中间绽放
    TLAnimatorTypeBevel = 2,        // 右边斜角切入,`只支持present/dismiss转场`
    TLAnimatorTypeTiltRight = 3,    // 向右边倾斜旋转
    TLAnimatorTypeTiltLeft = 4,     // 向左边倾斜旋转
    TLAnimatorTypeFrame = 5,        // 指定初始frame和最终frame【需根据情况对initialFrame、finalFrame初始化】
    TLAnimatorTypeRectScale = 6,    // 指定一个rect范围，对其进行缩放和平移【需对fromRect、toRect初始化】,【Push时rectView初始化】
    TLAnimatorTypeCircular = 7,     // 圆形转场，可以指定center（默认，屏幕中心）
    TLAnimatorTypeFlip = 9,         // 翻转（`只支持push/pop`）、翻页...，通过animationOptions属性设置动画样式
    // 如果dismiss需要TLAnimatorTypeFlip效果，可以使用
    // `UIViewController+Transitioning.h` 中的 `- presentViewController: transitionStyle: completion:`
    //  style 设置为：UIModalTransitionStyleFlipHorizontal
    
    TLAnimatorTypeSlidingDrawer,     // 抽屉效果（类似QQ个人信息页面）。初始化slidEnabled = NO，可以禁止toViewController滑动
    TLAnimatorTypeCards,             // 发牌效果
} TLAnimatorType;

NS_ASSUME_NONNULL_BEGIN

@interface TLAnimator : NSObject <TLAnimatorProtocol>
@property(nonatomic, assign) TLAnimatorType type;

//****** 仅在 TLAnimatorTypeOpen 模式下有效 ******//

/// 移除缩放动画效果，默认：NO
@property(nonatomic, assign) BOOL removeScaleAnimation;



//****** 仅在TLAnimatorTypeFrame模式下有效 ******//

/// 开始转场的frame，默认：[center, sizeZero]
@property(nonatomic, assign) CGRect initialFrame;
/// 转场结束的frame，默认：系统默认. 
@property(nonatomic, assign) CGRect finalFrame;



//****** 仅在TLAnimatorTypeRectScale模式下有效 ******//

/// 开始转场的frame，默认：[center, sizeZero]
@property(nonatomic, assign) CGRect fromRect;
/// 转场结束的frame，默认：系统默认finalFrame.
@property(nonatomic, assign) CGRect toRect;
/// 只显示和缩放fromRect区域，其他区域隐藏。默认：NO，fromRect区域以外也显示，并跟随缩放平移
@property(nonatomic, assign) BOOL isOnlyShowRangeForRect;
/// 缩放平移的View[rectView = 赋值的Viewf的快照]，Push的时候必传（push时没能截图成功）
@property(nonatomic, strong) UIView *rectView;



//****** TLAnimatorTypeCircular模式下有效 ******//

/// 圆形转场的center（默认，屏幕中心）
@property(nonatomic, assign) CGPoint center;
/// 默认初始半径（默认：0）
@property(nonatomic, assign) CGFloat startRadius;



//****** TLAnimatorTypeFlip模式下有效 ******//

/* UIViewAnimationOptions 有效值
UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20, // default
UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
*/
// 动画效果，取值范围如上
@property(nonatomic, assign) UIViewAnimationOptions animationOptions;



//****** TLAnimatorTypeSlidingDrawer模式下有效 ******//

// 动画效果，允许 To view controller 跟随滑动，。默认：YES
@property(nonatomic,getter=isSlidEnabled) BOOL slidEnabled;

+ (instancetype)animatorWithType:(TLAnimatorType)type;
@end

NS_ASSUME_NONNULL_END
