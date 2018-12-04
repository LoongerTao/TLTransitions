//
//  TLCodeViewConroller.m
//  Example
//
//  Created by 故乡的云 on 2018/12/4.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLCodeViewConroller.h"

@interface TLCodeViewConroller () {
    UIButton *_btn;
}
@property(nonatomic, weak) UIImageView *codeView;
@end

@implementation TLCodeViewConroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:codeView];
    _codeView = codeView;
    _codeView.userInteractionEnabled = YES;
    _codeView.contentMode = UIViewContentModeScaleAspectFit;
    _codeView.image = [UIImage imageNamed:_imgName];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_codeView.bounds.size.width - 60, 0, 60, 30)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_codeView addSubview:btn];
    _btn = btn;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.view.bounds.size.width > self.view.bounds.size.height) {
        _codeView.transform = CGAffineTransformMakeRotation(0);
    }else {
        _codeView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    if (@available(iOS 11.0, *)) {
        _codeView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    } else {
        _codeView.frame = self.view.bounds;
    }
    _btn.frame = CGRectMake(_codeView.bounds.size.width - 60, 0, 60, 30);
    
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    _codeView.image = [UIImage imageNamed:imgName];
}

@end
