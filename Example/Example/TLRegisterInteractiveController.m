//
//  TLRegisterInteractiveController.m
//  Example
//
//  Created by 故乡的云 on 2018/11/30.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLRegisterInteractiveController.h"
#import "TLTransitions.h"

@interface TLRegisterInteractiveController ()

@end

@implementation TLRegisterInteractiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"注册手势";
    UILabel *label = [[UILabel alloc] init];
    if (_isModal) {
        label.text = @"右侧滑可以Presentation操作";
    }else {
        label.text = @"右侧滑可以Push操作";
    }
    [label sizeToFit];
    label.center = self.view.layer.position;
    [self.view addSubview:label];
    
    // 要注册转场的View Controller
    UIViewController *vc = [[UIViewController alloc] init];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = vc.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor redColor].CGColor,
                       (id)[UIColor greenColor].CGColor,
                       (id)[UIColor blueColor].CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    gradient.locations = @[@0.0, @0.5, @1.0];
    [vc.view.layer addSublayer:gradient];
    
    
    // 注册手势
    TLSwipeAnimator *animator = [TLSwipeAnimator animatorWithSwipeType:TLSwipeTypeInAndOut pushDirection:TLDirectionToLeft popDirection:TLDirectionToRight];
    animator.transitionDuration = 0.35f;
    // 必须初始化的属性
    animator.isPushOrPop = !_isModal;
    animator.interactiveDirectionOfPush = TLDirectionToLeft;
    
    [self registerInteractiveTransitionToViewController:vc animator:animator];
}

@end
