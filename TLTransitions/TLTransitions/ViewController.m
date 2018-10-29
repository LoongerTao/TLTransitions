//
//  ViewController.m
//  TLTransitions
//
//  Created by 故乡的云 on 2018/10/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "ViewController.h"
#import "TLTransition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAlertView:(UIButton *)sender {
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 200.f);
    [TLTransition showView:[self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)]
                   popType:TLPopTypeAlert];
}

- (IBAction)showActionSheetView:(UIButton *)sender {
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width, 240.f);
    [TLTransition showView:[self creatViewWithBounds:bounds color:tl_Color(218, 248, 120)]
                   popType:TLPopTypeActionSheet];
}

- (UIView *)creatViewWithBounds:(CGRect)bounds color:(UIColor *)color {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectZero];
    BView.backgroundColor = color;
    BView.bounds = bounds;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"View B";
    titleLabel.font = [UIFont systemFontOfSize:80];
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(BView.bounds.size.width * 0.5, BView.bounds.size.height * 0.5);
    [BView addSubview:titleLabel];
    
    return BView;
}
@end
