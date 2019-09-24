//
//  TestViewController.m
//  Example
//
//  Created by 故乡的云 on 2019/9/24.
//  Copyright © 2019 故乡的云. All rights reserved.
//

#import "TestViewController.h"
#import "TestView.h"
#import "TLScreenEdgePanGestureRecognizer.h"

@interface TestViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1. 在父类统一集成，子类通过_swipeDismissEnable属性开启
        self.swipeDismissEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestView *view = [[TestView alloc] initWithFrame:CGRectMake(100, 100, 300, 400)];
    view.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:view];
    
    TestView *subView = [[TestView alloc] initWithFrame:CGRectInset(view.bounds, 20, 20)];
    subView.backgroundColor = [UIColor systemPinkColor];
    [view addSubview:subView];
    
    // 2. 创建侧滑手势
    if (self.swipeDismissEnable)
    {
        TLScreenEdgePanGestureRecognizer *edgePan;
        edgePan = [[TLScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        // 可以拓展为其它侧边滑动手势（如：右侧边滑动进行present...）
        edgePan.edges = UIRectEdgeLeft;
        [view addGestureRecognizer:edgePan];
    }
    self.view.backgroundColor = [UIColor systemYellowColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

// MARK: - 侧滑Dismiss
-(void)dismiss:(UIScreenEdgePanGestureRecognizer *)sender
{
//    if (self.swipeDismissEnable && sender.state == UIGestureRecognizerStateBegan)
//    {
        // 可以此处可以做出判断是需要执行Dismiss操作还是Pop操作
        // 此处以Dismiss为列
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    
    NSLog(@"%s",__func__);
}





@end
