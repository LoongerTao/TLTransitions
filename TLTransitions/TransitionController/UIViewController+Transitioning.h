//
//  UIViewController+Transitioning.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//
//================================================//
// 面向UIViewController
//================================================//


#import "TLGlobalConfig.h"
@protocol TLAnimatorProtocol;
@class TLTransitionDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Transitioning)

/// 转场动画(面向present/push To View Controller)
@property(nonatomic, weak, readonly) TLTransitionDelegate *transitionDelegate;

@property(nonatomic, weak, readonly) UIViewController *willPresentViewController;

/** 侧滑pop/dismiss交互手势启用开关。默认开启（NO）
 * 1.特性：当pop/dismiss的方向为TLDirectionToLeft（向左动画退场）时，通过右侧滑（屏幕右侧向左滑动）启动交互；
 *        其它则都是通过左侧滑启动交互
 * 2.手势控制转场百分比： 当前只有TLSwipeAnimator类型动画支持转场百分比控制
 * 3.关闭： 在push操作前设置`vc`的`disableInteractivePopGestureRecognizer = YES`，可以禁止侧滑交互
 */
@property(nonatomic, assign) BOOL disableInteractivePopGestureRecognizer;

/** 注册手势，通过UIScreenEdgePanGestureRecognizer手势触发push/present
 * @param viewController 要转场的控制器
 * @param animator 动画管理对象  ⚠️：必须初始化`isPushOrPop`，`interactiveDirection`属性
 */
- (void)registerInteractiveTransitionToViewController:(UIViewController *)viewController
                                             animator:(id <TLAnimatorProtocol>)animator;


//====================== 👇下面2个API是通用API ==========================//

// NOTE：下面不同类型的Animator实现的转场效果有些类似，只是实现方案有所差异
/**
 * present 转场控制器。
 * @param viewController 要转场的控制器
 * @param animator 转场动画管理对象
 *        目前提供“TLSystemAnimator”、“TLSwipeAnimator”、“TLCATransitionAnimator”、“TLCuStomAnimator” 、 “TLAnimator”供选择，
 *        也可以由开发者自己写一个这样的对象，需要 严格遵守 TLAnimatorProtocal协议（可以参考模版TLAnimatorTemplate）
 * @param completion 完成转场的回调
 */
- (void)presentViewController:(UIViewController *)viewController
                     animator:(id<TLAnimatorProtocol>)animator
                   completion:(void (^ __nullable)(void))completion;

/**
 * push 转场控制器。
 * @param viewController 要转场的控制器
 * @param animator 转场动画管理对象
 *        目前提供“TLSwipeAnimator”、“TLCATransitionAnimator”、“TLCuStomAnimator” 、 “TLAnimator”供选择，
 *        也可以由开发者自己写一个这样的对象，需要 严格遵守 TLAnimatorProtocal协议（可以参考模版TLAnimatorTemplate）
 */
- (void)pushViewController:(UIViewController *)viewController animator:(id<TLAnimatorProtocol>)animator;


//====================== 👇下面的API是👆上面两个的简化使用 ==========================//
#pragma mark - Present / Dismiss
/**
 * 转场控制器(官方原生类型)。 对应TLSystemAnimator类型
 * @param vc 要转场的控制器
 * @param style 转场动画类型
 *          `UIModalTransitionStyleCoverVertical=0, 默认方式，竖向上推`
 *          `UIModalTransitionStyleFlipHorizontal, 水平反转`
 *          `UIModalTransitionStyleCrossDissolve, 隐出隐现`
 *          `UIModalTransitionStylePartialCurl, 部分翻页效果`
 * @param completion 完成转场的回调
 */
- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   completion:(void (^ __nullable)(void))completion;

/**
 * 以滑动的方式present转场控制器。
 * @param vc 要转场的控制器
 * @param presentDirection present方向（指向）
 * @param dismissDirection dismiss方向（指向）
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
                    swipeType:(TLSwipeType)swipeType
                presentDirection:(TLDirection)presentDirection
                 dismissDirection:(TLDirection)dismissDirection
                   completion:(void (^ __nullable)(void))completion;

/**
 * present转场控制器。
 * @param vc 要转场的控制器
 * @param tType TLTransitionType动画类型(其中部分为私有API，详将定义处)
 * @param direction present方向
 * @param directionOfDismiss dismiss方向
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
               transitionType:(TLTransitionType)tType
                    direction:(TLDirection)direction
             dismissDirection:(TLDirection)directionOfDismiss
                   completion:(void (^ __nullable)(void))completion;

/**
 * present转场控制器。
 * @param vc 要转场的控制器
 * @param animation 自定义动画（分presenting和dismiss）
 *        isPresenting = YES，Present；isPresenting = NO，Dismiss，
 *        ⚠️ 动画结束一定要调用[transitionContext completeTransition:YES];
 *
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
              customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                   completion:(void (^ __nullable)(void))completion;


#pragma mark - Push / Pop
/**
 * 以滑动的方式转场控制器(Push / Pop)。
 * @param vc 要转场的控制器
 * @param pushDirection push方向（指向）
 * @param popDirection pop方向（指向）
 * NOTE: 手动Pop --> [self.navigationController popViewControllerAnimated:YES];
 */
- (void)pushViewController:(UIViewController *)vc
                 swipeType:(TLSwipeType)swipeType
             pushDirection:(TLDirection)pushDirection
              popDirection:(TLDirection)popDirection;

/**
 * push 转场控制器。
 * @param vc 要转场的控制器
 * @param tType TLTransitionType动画类型(其中部分为私有API，详将定义处)
 * @param direction push方向
 * @param directionOfPop pop方向
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)pushViewController:(UIViewController *)vc
            transitionType:(TLTransitionType)tType
                 direction:(TLDirection)direction
          dismissDirection:(TLDirection)directionOfPop;

/**
 * push 转场控制器。
 * @param vc 要转场的控制器
 * @param animation 自定义动画
 *        isPush = YES，push；isPush = NO，pop，
 *        ⚠️ 动画结束一定要调用[transitionContext completeTransition:YES];
 */
- (void)pushViewController:(UIViewController *)vc
           customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPush))animation;


@end

NS_ASSUME_NONNULL_END
