//
//  UIViewController+Presenting.h
//  
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//
//================================================//
// 面向UIViewController
//================================================//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Presenting) 

/**
 * 转场控制器
 * @param vc 要转场的控制器，会被强引用，dismiss时释放
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
 * 转场控制器
 * @param vc 要转场的控制器，会被强引用，dismiss时释放
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
 */
- (void)presentToViewController:(UIViewController *)vc
                  transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
                     completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器
 * @param vc 要转场的控制器，会被强引用，dismiss时释放
 * @param tType present动画类型
 * @param subtype present方向
 * @param tTypeForDismiss dismiss动画类型
 * @param subtypeForDismiss dismiss方向
 * @param completion 完成转场的回调
 */
- (void)presentToViewController:(UIViewController *)vc
                 transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
          dismissTransitionType:(CATransitionType)tTypeForDismiss
                 dismissSubtype:(CATransitionSubtype)subtypeForDismiss
                     completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器
 * @param vc 要转场的控制器，会被强引用，dismiss时释放
 * @param animation 自定义动画（分presenting和dismiss）
 *        NOTE: isPresenting = YES，Present；isPresenting = NO，Dismiss，
                不需要再给transitionContext.containerView添加subview
 *              ⚠️动画结束一定要调用[transitionContext completeTransition:YES];
 *
 * @param completion 完成转场的回调
 */
- (void)presentToViewController:(UIViewController *)vc
                customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                     completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
