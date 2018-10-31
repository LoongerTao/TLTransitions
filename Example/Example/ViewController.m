//
//  ViewController.m
//  Example
//
//  Created by 故乡的云 on 2018/10/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "ViewController.h"
#import "TLTransition.h"
#import "TowViewController.h"
#import "ThreeViewController.h"
#import "UIViewController+Presenting.h"

@interface ViewController ()<CAAnimationDelegate>{
    UIView *_bView;
    UILabel *_titleLabel;
    TLTransition *_transition;
    
    id<UIViewControllerContextTransitioning> _transitionContext;
    CATransition *_anim1;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (IBAction)presentViewController {
    TowViewController *vc = [[TowViewController alloc] init];
//    [TLTransition presentToViewController:vc animationType:kCATransitionPush subtype:kCATransitionFromRight];
    
//    ThreeViewController *vc = [[ThreeViewController alloc] init];
//    [TLTransition presentToViewController:vc animationType:kCATransitionReveal subtype:kCATransitionFromRight];
    
//    [self presentViewController:vc animated:YES completion:nil];

    
//    [self presentViewController:vc transitionStyle:3 completion:^{
//        NSLog(@"----completion---");
//    }];
    
    //    CA_EXTERN CATransitionType const kCATransitionFade
    //    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
    //    CA_EXTERN CATransitionType const kCATransitionMoveIn
    //    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
    //    CA_EXTERN CATransitionType const kCATransitionPush
    //    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
    //    CA_EXTERN CATransitionType const kCATransitionReveal
    //    API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

    [self presentToViewController:vc transitionType:@"cube" subtype:kCATransitionFromRight completion:^{
         NSLog(@"----completion---");
    }];
}


// TLPopTypeAlert
- (IBAction)alertType:(UIButton *)sender {
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(218, 248, 120)];
    
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.backgroundColor = tl_Color(255, 255, 255);
    textFiled.bounds = CGRectMake(0, 0, bView.bounds.size.width * 0.8f, 30.f);
    textFiled.center = CGPointMake(bView.bounds.size.width * 0.5, bView.bounds.size.height * 0.2);
    [bView addSubview:textFiled];
    
    [TLTransition showView:bView popType:TLPopTypeAlert];
}

// TLPopTypeActionSheet
- (IBAction)actionSheetType:(UIButton *)sender {
    
    
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)];
    _transition = [TLTransition showView:bView popType:TLPopTypeActionSheet];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bView addGestureRecognizer:tap];
}

// to point
- (IBAction)pointType:(UIButton *)sender {
    
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 100.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(120, 248, 180)];
    [TLTransition showView:bView toPoint:CGPointMake(-50, -50)];
}

// frame1->frame2
- (IBAction)frameType:(UIButton *)sender {
    
    CGRect initialFrame = sender.frame;
    CGRect finalFrame = CGRectMake(30, 400, self.view.bounds.size.width * 0.8f, 200.f);
    UIView *bView = [self creatViewWithBounds:initialFrame color:tl_Color(250, 250, 250)];
    [TLTransition showView:bView initialFrame:initialFrame finalFrame:finalFrame];
}

// 自定义动画
- (IBAction)customAnimateTransition:(UIButton *)sender {
    __weak typeof(self) wself = self;
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)];
    _transition = [TLTransition showView:bView popType:TLPopTypeAlert];
    
    NSTimeInterval duration = _transition.transitionDuration;
    _transition.animateTransition = ^(id<UIViewControllerContextTransitioning> transitionContext) {
        
        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        UIView *fromView;
        UIView *toView;
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = transitionContext.containerView;
        if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
            fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        } else {
            fromView = fromViewController.view;
            toView = toViewController.view;
        }
        
        if(toView){ // Present
            
            // 注意: 一定要将视图添加到容器上
            [containerView addSubview:toView];
            
            // UIView动画
            // 动画前的样式
            // code...
//            [UIView animateWithDuration:duration animations:^{
//
//                // 最终的样式
//                // code...
//
//            } completion:^(BOOL finished) {
//                // 必须执行：告诉transitionContext 动画执行完毕
//                [transitionContext completeTransition:YES];
//            }];
            
            // 或CATransition
            self->_transitionContext = transitionContext;
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself;
            anim.duration = duration;
            anim.type = @"push"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [toView.layer addAnimation:anim forKey:nil];
            
        }else { // dismiss
            
            [containerView addSubview:fromView];
            // UIView动画
            // 动画前的样式
            // code...
//            [UIView animateWithDuration:duration animations:^{
//
//                // 最终的样式
//                // code...
//
//            } completion:^(BOOL finished) {
//                [transitionContext completeTransition:YES];
//            }];
            
            // 或CATransition
            self->_transitionContext = transitionContext;
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself;
            anim.duration = 1.0;//duration;
            anim.type = @"cube"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [fromView.layer addAnimation:anim forKey:nil];
        };
    };
}

- (UIView *)creatViewWithBounds:(CGRect)bounds color:(UIColor *)color {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectZero];
    BView.backgroundColor = color;
    BView.bounds = bounds;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [BView addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.text = @"View B";
    titleLabel.font = [UIFont systemFontOfSize:80];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = BView.bounds;
    
    _bView = BView;
    [BView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    return BView;
}

- (void)tap {
    CGRect rect = _bView.bounds;
    rect.size.height += 1;
    _bView.bounds = rect;
    [_transition updateContentSize];
    
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        _titleLabel.frame = _titleLabel.superview.bounds;
    }
}

/// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:YES];
}

- (void)dealloc {
    [_bView removeObserver:self forKeyPath:@"frame"];
}
@end
