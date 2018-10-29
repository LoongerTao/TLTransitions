//
//  TLTransition.h
//  TLPopViewController
//
//  Created by 故乡的云 on 2018/8/1.
//  Copyright © 2018年 Gxdy. All rights reserved.
//  present 转场

#import "TLGlobalConfig.h"

// MARK: -
// MARK: - TLTransition

// * 通过modal方法，将一个View绑定到固定的控制器(TLPopViewController)进行显示
// * 适用于弹出式界面(面向View)

/**
 * 自适应位置情况下的显示样式
 */
typedef enum : NSUInteger {
    TLPopTypeActionSheet = 0,    // ActionSheet动画样式，底部弹出，靠底部显示
    TLPopTypeAlert = 1,          // AlertView动画样式，淡化居中显示
    
} TLPopType;


@class TLPopViewController;
@interface TLTransition : UIPresentationController <UIViewControllerTransitioningDelegate>

/// 需要展示的View，自动水平居中，TLPopTypeAlert时，垂直居中
@property(nonatomic, assign) TLPopType pType;

/// 需要展示的View，布局以keyWindow坐标为标准
@property(nonatomic, strong) UIView *popView;
/// 是否允许点击灰色蒙板处来dismiss，默认YES
@property(nonatomic, assign) BOOL allowTapDismiss;
/// 圆角，默认16
@property(nonatomic, assign) CGFloat cornerRadius;
/// 隐藏阴影layer，默认NO
@property(nonatomic, assign) BOOL hideShadowLayer;
/// 键盘显示与隐藏监听，default：YES (TLPopTypeActionSheetb类型不支持)
@property(nonatomic, assign) BOOL allowObserverForKeyBoard;

/**
 * 转场形式显示popView
 * 自适应位置
 * ⚠️调用该方法时，请先设定好popView的frame
 *
 * @param popView 要显示的View
 * @param pType 显示类型
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)showView:(UIView *)popView popType:(TLPopType)pType;

/**
 * 转场形式显示popView
 * 指定位置
 * ⚠️调用该方法时，请先设定好popView的frame
 *
 * @param popView 要显示的View
 * @param point popView的最终坐标（相对mainScreen）
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)showView:(UIView *)popView toPoint:(CGPoint)point;

/**
 * 显示popView, 由InitialFrame(初始) --过渡到--> FinalFrame(最终)
 * @param popView 要显示的View
 * @param iFrame present前的frame(初始)
 * @param fFrame presented后的frame(最终)
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)showView:(UIView *)popView
            initialFrame:(CGRect)iFrame
              finalFrame:(CGRect)fFrame;
/**
 * 隐藏popView
 * 如果TLPopTransition没有被引用，则在隐藏后会自动释放
 * 如果popView没有被引用，在隐藏后也会自动释放
 */
- (void)dismiss;

/**
 * 实时更新view的size ，显示后也可以更新
 */
- (void)updateContentSize;

/**
 * 当前设备是不是iPhone X
 */
+ (BOOL)isIPhoneX;
@end






// * 自定义控制器的Present 动画 （面向UIViewController）

/*
 typedef enum : NSUInteger {
 
 TLAnimationTypeBottomMoveIn = 0,    // 新视图从旧视图底部平移进入，默认
 TLAnimationTypeTopMoveIn,           // 新视图从旧视图顶部平移进入
 TLAnimationTypeScale,               // 定点缩放（X、Y）
 TLAnimationTypeScale2,              // 定点缩放（X、Y）frame
 TLAnimationTypeSpread,              // 定点上下展开（Y）
 TLAnimationTypeBottomSpread,        // 新视图从旧视图底部向上撑开，
 TLAnimationTypeTopSpread,           // 新视图从旧视图顶部向下撑开
 TLAnimationTypeDownsweep,           // 幕布落下效果
 TLAnimationTypeRotation,            // 旋转翻页样式
 TLAnimationTypeRightMoveIn,         // 新视图从旧视图右边平移进入
 
 
 } TLAnimationType;
 */

@interface TLTransition (UIViewController)
///** 视图被展现的最终frame */
//@property (nonatomic,assign) CGRect presentedFrame;
///** 视图被展现前的初始frame */
//@property (nonatomic,assign) CGRect willPresentFrame;
//
///** 转场动画类型 */
//@property (nonatomic,assign) TLAnimationType aType;
///** dismiss 使能,默认：YES */
//@property (nonatomic,assign) BOOL dismissEnable;
//
///** anchorPoint 缩放/展开/旋转样式 锚点，默认中心(0.5,0.5) */
//@property (nonatomic,assign) CGPoint anchorPoint;
//
@end
