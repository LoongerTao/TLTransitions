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

#import <UIKit/UIKit.h>
#import "TLGlobalConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Transitioning)<UINavigationControllerDelegate>

/// 转场动画时长，可以在执行present前根据不同动画类型进行调整。默认：0.45f,最小0.01。
@property(nonatomic, assign) NSTimeInterval transitionDuration;

// 当pop/dismiss的方向为TLDirectionTypeLeft（向左动画退场）时，通过右侧滑（屏幕右侧向左滑动）启动交互；其它则都是通过左侧滑启动交互
/// 侧滑pop/dismiss交互手势启用开关。默认：NO，以下API有明确标注支持的都可使用交互手势进行pop/dismiss。
@property(nonatomic, assign) BOOL disableInteractivePopGestureRecognizer;


#pragma mark - Present / Dismiss
/**
 * 转场控制器(官方原生类型)。不支持 侧滑进行dismiss操作
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
 * 以滑动的方式转场控制器。不支持 侧滑进行dismiss操作
 * @param vc 要转场的控制器
 * @param targetEdge 滑动方向，必须是 UIRectEdgeTop、UIRectEdgeBottom、UIRectEdgeLeft、UIRectEdgeRight 中的一个
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
              swipeTargetEdge:(UIRectEdge)targetEdge
            reverseOfDismiss:(BOOL)isReverse
                   completion:(void (^ __nullable)(void))completion TL_DEPRECATED("过期，请使用`-presentViewController: swipeType: pushDirection: popDirection: completion:`");

/**
 * 以滑动的方式转场控制器。支持侧滑进行dismiss操作，在present操作前设置`vc`的`disableInteractivePopGestureRecognizer = YES`，可以禁止侧滑交互
 * @param vc 要转场的控制器
 * @param presentDirection present方向（指向）
 * @param dismissDirection dismiss方向（指向）
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
                    swipeType:(TLSwipeType)swipeType
                presentDirection:(TLDirectionType)presentDirection
                 dismissDirection:(TLDirectionType)dismissDirection
                   completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器。不支持 侧滑进行dismiss操作
 * @param vc 要转场的控制器
 * @param tType 转场动画类型（本质NSString类型）
 *          `kCATransitionFade`
 *          `kCATransitionMoveIn`
 *          `kCATransitionPush`
 *          `kCATransitionReveal`
 *          其它官方私有API：@"cube"、@"suckEffect"、@"oglFlip"、@"rippleEffect"、@"pageCurl"、@"pageUnCurl"、
 *          @"cameraIrisHollowOpen"、@"cameraIrisHollowClose"
 * @param subtype 转场方向（本质NSString类型）
 *          `kCATransitionFromRight`
 *          `kCATransitionFromLeft`
 *          `kCATransitionFromTop`
 *          `kCATransitionFromBottom`
  * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentToViewController:(UIViewController *)vc
                  transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
                     completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器。不支持 侧滑进行dismiss操作
 * @param vc 要转场的控制器
 * @param tType present动画类型
 * @param subtype present方向
 * @param tTypeForDismiss dismiss动画类型
 * @param subtypeForDismiss dismiss方向
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentToViewController:(UIViewController *)vc
                 transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
          dismissTransitionType:(CATransitionType)tTypeForDismiss
                 dismissSubtype:(CATransitionSubtype)subtypeForDismiss
                     completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器。不支持 侧滑进行dismiss操作
 * @param vc 要转场的控制器
 * @param animation 自定义动画（分presenting和dismiss）
 *        isPresenting = YES，Present；isPresenting = NO，Dismiss，
          不需要再给transitionContext.containerView添加subview
 *        ⚠️ 动画结束一定要调用[transitionContext completeTransition:YES];
 *
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentToViewController:(UIViewController *)vc
                customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                     completion:(void (^ __nullable)(void))completion;


#pragma mark - Push / Pop
/**
 * 以滑动的方式转场控制器(Push / Pop)。支持侧滑进行pop操作，在push操作前设置`vc`的`disableInteractivePopGestureRecognizer = YES`，可以禁止侧滑交互
 * @param vc 要转场的控制器
 * @param pushDirection push方向（指向）
 * @param popDirection pop方向（指向）
 * NOTE: 手动Pop --> [self.navigationController popViewControllerAnimated:YES];
 */
- (void)pushViewController:(UIViewController *)vc
                 swipeType:(TLSwipeType)swipeType
             pushDirection:(TLDirectionType)pushDirection
              popDirection:(TLDirectionType)popDirection;
@end

NS_ASSUME_NONNULL_END
