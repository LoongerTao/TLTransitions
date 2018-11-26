//
//  TLTransition.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/8/1.
//  Copyright © 2018年 Gxdy. All rights reserved.
//  present 转场


//================================================//
// 面向UIView
// * 通过modal方法，将一个View绑定到固定的控制器(TLPopViewController)进行显示
// * 适用于弹出式界面(popover)
//================================================//

#import "TLGlobalConfig.h"



/**
 * 自适应位置情况下的显示样式,可以配合animateTransition属性使用 */
typedef enum : NSUInteger {
    TLPopTypeActionSheet = 0,    // ActionSheet动画样式，底部弹出，靠底部显示
    TLPopTypeAlert = 1,          // AlertView动画样式，淡化居中显示
    TLPopTypeAlert2 = 2,         // f顶部掉下来、弹性，居中显示
} TLPopType;

/// 自定义动画样式
typedef void(^TLAnimateForTransition)(id <UIViewControllerContextTransitioning> transitionContext);

@class TLPopViewController;
@interface TLTransition : UIPresentationController <UIViewControllerTransitioningDelegate>
/// 是否允许点击灰色蒙板处来dismiss，默认YES
@property(nonatomic, assign) BOOL allowTapDismiss;
/// 圆角，默认16
@property(nonatomic, assign) CGFloat cornerRadius;
/// 隐藏阴影layer，默认NO
@property(nonatomic, assign) BOOL hideShadowLayer;
/// 键盘显示与隐藏监听，default：YES
@property(nonatomic, assign) BOOL allowObserverForKeyBoard;

/// 转场动画时间，默认0.35s
@property(nonatomic, assign) NSTimeInterval transitionDuration;
/// 自定义动画样式(注意需要准守规则,可参考demo或文档)
@property(nonatomic, copy) TLAnimateForTransition animateTransition;

/// 栈顶控制器
+ (UIViewController *)topController;

/// 当前设备是不是iPhone X系列
+ (BOOL)isIPhoneX;


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
 * 指定位置(在view超出屏幕范围情况下会自动匹配边界【调整origin】，以保证view整体都在屏幕显示)
 * ⚠️调用该方法时，请先设定好popView的frame
 *
 * @param popView 要显示的View
 * @param point popView的最终坐标（origin相对mainScreen）
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

@end








