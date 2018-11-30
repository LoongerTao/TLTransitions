//
//  TLGlobalConfig.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/8/16.
//  Copyright © 2018年 Gdxy. All rights reserved.


#import <UIKit/UIKit.h>

// 方向,指向的方向（Top：bottom --> top，动画由Top：bottom到top）
typedef enum : NSUInteger {
    TLDirectionToTop = 1 << 0,
    TLDirectionToLeft = 1 << 1,
    TLDirectionToBottom = 1 << 2,
    TLDirectionToRight = 1 << 3,
} TLDirection;

// TLSwipeAnimator动画类型：如有控制器A和B， 操作： A push to B Or B pop to A
typedef enum : NSUInteger {
    TLSwipeTypeInAndOut = 0, // push：B从A的上面滑入，pop：B从A的上面抽出.
    TLSwipeTypeIn,           // push：B从A的上面滑入，pop：A从B的上面滑入.效果类似CATransition动画中的kCATransitionMoveIn
    TLSwipeTypeOut,          // push：A从B的上面抽出，pop：B从A的上面抽出.效果类似CATransition动画中的kCATransitionReveal
} TLSwipeType;

// TLCATransitonAnimator 动画类型，对应官方的CATransitionType
typedef enum : NSUInteger {
    TLTransitionFade,
    TLTransitionMoveIn,
    TLTransitionPush,
    TLTransitionReveal,
    
    // 以下是官方未公开的API（私有，可能影响上架）
    TLTransitionCube,
    TLTransitionSuckEffect,
    TLTransitionOglFlip,
    TLTransitionRippleEffect,
    TLTransitionPageCurl,
    TLTransitionPageUnCurl,
    TLTransitionCameraIrisHollowOpen,
    TLTransitionCameraIrisHollowClose,
} TLTransitionType;





// MARK: - 全局常量配置


// MARK: - 宏定义
#ifdef DEBUG
#define tl_Log(...) NSLog(__VA_ARGS__)
#else
#define tl_Log(...)
#endif

#define tl_LogFunc tl_Log(@"%s", __func__);
// 过期
#define TL_DEPRECATED(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)


/** RGB颜色 */
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define tl_Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/** 亮灰色背景主题 */
#define tl_LightGardBgColor [UIColor groupTableViewBackgroundColor]
/** 蓝色主题 */
#define tl_BlueTintColor UIColorFromRGBA(0x0b9cf0, 1.f)
/** 红色主题 */
#define tl_RedTintColor tl_Color(220, 0, 0)
/** 绿色主题 */
#define tl_GreenTintColor tl_Color(33, 205, 65)
/** 白色主题 */
#define tl_WhiteTintColor tl_Color(255, 255, 255)
/** 字体主题 */
#define tl_TextTintColor UIColorFromRGBA(0x333333, 1.f)
/** 灰色字体主题 */
#define tl_GardTextTintColor UIColorFromRGBA(0x666666, 1.f)


/** 屏幕宽度 */
#define tl_ScreenW ([UIScreen mainScreen].bounds.size.width)
/** 屏幕高度 */
#define tl_ScreenH ([UIScreen mainScreen].bounds.size.height)
/** 状态栏高度 */
#define tl_StatusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)
/** Nav Bar高度 */
#define tl_NavBarH (iMStatusBarH + 44.f)
/** Tab Bar高度 */
#define tl_TabBarH 44.f
/** iPhone X home bar */
#define tl_iPhoneXHomeBarH  (tl_isLandscape ? 21.f : 34.f)

/** 横屏 */
#define tl_isLandscape (tl_ScreenW > tl_ScreenH)
/** iPhoneX 系列(XR & X Max : 414, 896, X & Xs : 375, 812) */
#define tl_isIPhoneX (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) || \
                      CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) || \
                      CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) || \
                      CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)))


#pragma mark - 函数
UIRectEdge getRectEdge(TLDirection direction);
UIImage * snapshotImage(UIView *view);  // 快照，将View转换成图片
UIImage * resizableSnapshotImage(UIView *view, CGRect inRect);
