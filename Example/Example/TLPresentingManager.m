//
//  TLPresentingManager.m
//  
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLPresentingManager.h"
#import "TLGlobalConfig.h"

@implementation TLPresentingManager


//@property(nonatomic, assign) CATransitionType tType;
//@property(nonatomic, assign) CATransitionSubtype subtype;
//@property(nonatomic, strong) UIViewController *presentController;
//@property(nonatomic, strong) id <UIViewControllerContextTransitioning>transitionContext;


//+ (instancetype)presentToViewController:(UIViewController *)vc
//                          animationType:(CATransitionType)tType
//                                subtype:(CATransitionType)subtype
//{
//    UIViewController *topVc = [self topController];
//
//
//    [topVc presentViewController:vc animated:YES completion:nil];
//    return pt;
//}

//// showTypePoint
//- (void)showTypeViewControllerAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
//                             fromViewController:(UIViewController *)fromViewController
//                               toViewController:(UIViewController *)toViewController
//                                  containerView:(UIView *)containerView
//                                       fromView:(UIView *)fromView
//                                         toView:(UIView *)toView
//{
//    self.transitionContext = transitionContext;
//    BOOL isPresenting = (fromViewController == self.presentingViewController);
//    UIView *view = isPresenting ? toViewController.view : fromViewController.view;
//    [containerView addSubview:view];
//
//    CATransition *anim = [CATransition animation];
//    anim.delegate = self;
//    anim.duration = [self transitionDuration:transitionContext];
//    anim.type = self.tType;
//    anim.subtype = self.subtype;
//    if(!isPresenting) {
//        //        anim.endProgress = 0.5;
//
//    }
//    [view.layer addAnimation:anim forKey:nil];
//}

#pragma mark - CAAnimationDelegate
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self.transitionContext completeTransition:YES];
//    self.transitionContext = nil;
//}


- (void)dealloc{
    tl_LogFunc
}

@end
