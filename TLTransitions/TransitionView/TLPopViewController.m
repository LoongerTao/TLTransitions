//
//  TLPopViewController.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/8/3.
//  Copyright © 2018年 Gxdy. All rights reserved.
//

#import "TLPopViewController.h"

@interface TLPopViewController ()

@end

@implementation TLPopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
}

// 当视图控制器的特征集合被其父控件更改时，将调用此方法。
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    // 指定视图大小
    self.preferredContentSize = self.popView.bounds.size;
}


- (void)setPopView:(UIView *)popView {
    _popView = popView;
    [self.view addSubview:popView];
    self.view.backgroundColor = popView.backgroundColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = _popView.frame;
    frame.origin = CGPointZero;
    _popView.frame = frame;
}

- (void)updateContentSize {
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (void)dealloc{
    tl_LogFunc
}
@end
