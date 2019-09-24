//
//  TLRegisterInteractiveController.m
//  Example
//
//  Created by 故乡的云 on 2018/11/30.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLRegisterInteractiveController.h"
#import "TLTransitions.h"
#import "TLCodeViewConroller.h"

@interface TLRegisterInteractiveController ()

@end

@implementation TLRegisterInteractiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"注册手势";
    UILabel *label = [[UILabel alloc] init];
    if (_isModal) {
        label.text = @"右边向左侧滑可以Presentation操作";
    }else {
        label.text = @"右边向左侧滑可以Push操作";
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
    
    UILabel *label2 = [[UILabel alloc] init];
    if (_isModal) {
        label2.text = @"左边向右侧滑可以Dismiss操作";
    }else {
        label2.text = @"左边向右滑可以Pop操作";
    }
    [label2 sizeToFit];
    label2.center = vc.view.layer.position;
    [vc.view addSubview:label2];
    
    
    // 注册手势
    TLSwipeAnimator *animator = [TLSwipeAnimator animatorWithSwipeType:TLSwipeTypeInAndOut pushDirection:TLDirectionToLeft popDirection:TLDirectionToRight];
    animator.transitionDuration = 0.35f;
    // 必须初始化的属性
    animator.isPushOrPop = !_isModal;
    animator.interactiveDirectionOfPush = TLDirectionToLeft;
    
    [self registerInteractiveTransitionToViewController:vc animator:animator];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    btn.center = CGPointMake(self.view.bounds.size.width * 0.5, 200);
    [btn setTitle:@"查看代码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(showCode:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn];
}

- (IBAction)showCode:(UIButton *)sender {
    TLCodeViewConroller *codeVc = [TLCodeViewConroller new];
    codeVc.imgName = @"registerInteractive";
    TLCATransitonAnimator *anm = [TLCATransitonAnimator animatorWithTransitionType:TLTransitionFade
                                                                         direction:TLDirectionToLeft
                                                           transitionTypeOfDismiss:TLTransitionFade
                                                                directionOfDismiss:TLDirectionToRight];
    [self presentViewController:codeVc animator:anm completion:nil];
}
@end
