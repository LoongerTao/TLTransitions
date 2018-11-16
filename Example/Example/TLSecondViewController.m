//
//  TLSecondViewController.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/30.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLSecondViewController.h"

@interface TLSecondViewController ()

@end

@implementation TLSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Controller B";
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.navigationController.childViewControllers.count > 0) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}

- (IBAction)dismiss:(id)sender {
    if (self.navigationController.childViewControllers.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLSecondViewControllerDidDealloc" object:nil];
}

@end
