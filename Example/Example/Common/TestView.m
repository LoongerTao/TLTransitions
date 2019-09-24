//
//  TestView.m
//  Example
//
//  Created by 故乡的云 on 2019/9/24.
//  Copyright © 2019 故乡的云. All rights reserved.
//

#import "TestView.h"

@implementation TestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitTestView = [super hitTest:point withEvent:event];
    return hitTestView;
}

@end
