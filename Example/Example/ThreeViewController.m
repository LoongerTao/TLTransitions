//
//  ThreeViewController.m
//  Example
//
//  Created by 故乡的云 on 2018/10/31.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "ThreeViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor magentaColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];

    titleLabel.text = @"Controller C";
    titleLabel.font = [UIFont systemFontOfSize:40];
    titleLabel.textColor = [UIColor cyanColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = self.view.bounds;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
