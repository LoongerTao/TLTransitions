//
//  TowViewController.m
//  Example
//
//  Created by 故乡的云 on 2018/10/30.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TowViewController.h"
#import "UIViewController+Presenting.h"
@interface TowViewController ()

@end

@implementation TowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self presentViewController:[ThreeViewController new] transitionStyle:1 completion:^{
//        NSLog(@"----completion---");
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TowViewControllerDidDealloc" object:nil];
}

@end
