//
//  TLPresentingManager.h
//  
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.

//================================================//
// View Controller 的自定义转场
//================================================//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLPresentingManager : UIPresentationController
/**
 * 转场的控制器(需要手动调用dismiss),animateTransition属性有值时为自定义转场动画，会覆盖本方法的动画设置
 * @param vc 要转场的控制器，会被强引用，dismiss时释放
 * @param tType 转场动画类型
 *          `kCATransitionFade`
 *          `kCATransitionMoveIn`
 *          `kCATransitionPush`
 *          `kCATransitionReveal`
 * @param subtype 转场方向
 *          `kCATransitionFromRight`
 *          `kCATransitionFromLeft`
 *          `kCATransitionFromTop`
 *          `kCATransitionFromBottom`
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)presentToViewController:(UIViewController *)vc
                          animationType:(CATransitionType)tType
                                subtype:(CATransitionType)subtype;
@end

NS_ASSUME_NONNULL_END
