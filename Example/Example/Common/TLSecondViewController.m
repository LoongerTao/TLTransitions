//
//  TLSecondViewController.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/30.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLSecondViewController.h"
#import "TLTransitions.h"
#import "TLCodeViewConroller.h"

@interface TLSecondViewController ()
@property(nonatomic, weak) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *presentBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation TLSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"Controller B";
    
    self.imgView.hidden = !_isShowImage;
    self.presentBtn.hidden = !_isShowBtn;
    
    if (_isShowBtn) {
        
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
        
        
        TLAnimatorType type = TLAnimatorTypeSlidingDrawer;
        TLAnimator *animator = [TLAnimator animatorWithType:type];
        animator.transitionDuration = 0.35f;
       
        // 必须初始化的属性
        animator.isPushOrPop = NO;
        animator.interactiveDirectionOfPush = TLDirectionToRight;
        
        [self registerInteractiveTransitionToViewController:vc animator:animator];
    }
}

- (IBAction)dismiss:(id)sender {
    if (self.navigationController.childViewControllers.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)present:(UIButton *)sender {
    
    TLSecondViewController *vc = [[TLSecondViewController alloc] init];
    vc.textLabel.text = @"C";
    vc.view.backgroundColor = [UIColor yellowColor];
    TLAnimatorType type = TLAnimatorTypeSlidingDrawer;
    TLAnimator *animator = [TLAnimator animatorWithType:type];
    animator.transitionDuration = 0.35f;
    
    [self presentViewController:vc animator:animator completion:^{
        vc.textLabel.text = @"C";
    }];
}

- (IBAction)showCode:(UIButton *)sender {
    TLCodeViewConroller *codeVc = [TLCodeViewConroller new];
    codeVc.imgName = _imgName;
    TLSystemAnimator *anm = [TLSystemAnimator animatorWithStyle:0 fullScreen:NO];
    [self presentViewController:codeVc animator:anm completion:nil];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLSecondViewControllerDidDealloc" object:nil];
}

@end
