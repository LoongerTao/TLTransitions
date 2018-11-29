//
//  TLSecondViewController.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/30.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLSecondViewController.h"
#import "TLTransitions.h"

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
        
        TLSecondViewController *vc = [[TLSecondViewController alloc] init];
        vc.textLabel.text = @"C";
        vc.view.backgroundColor = [UIColor yellowColor];
        TLAnimatorType type = TLAnimatorTypeSlidingDrawer;
        TLAnimator *animator = [TLAnimator animatorWithType:type];
        animator.transitionDuration = 0.35f;
        
//        [self registerInteractiveModalRecognizer:YES
//                                     toDirection:TLDirectionToRight
//                                toViewController:vc
//                                        animator:animator];
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



- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLSecondViewControllerDidDealloc" object:nil];
}

@end
