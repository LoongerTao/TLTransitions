//
//  TLPopViewController.m
//  OusiCanteen
//
//  Created by 故乡的云 on 2018/8/3.
//  Copyright © 2018年 何青. All rights reserved.
//

#import "TLPopViewController.h"

@interface TLPopViewController ()

@end

@implementation TLPopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    self.preferredContentSize = self.popView.bounds.size;
}


- (void)setPopView:(UIView *)popView {
    _popView = popView;
    [self.view addSubview:popView];
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
