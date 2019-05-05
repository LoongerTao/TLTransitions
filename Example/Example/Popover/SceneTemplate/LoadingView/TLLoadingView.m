//
//  TLLoadingView.m
//  Example
//
//  Created by 故乡的云 on 2019/5/5.
//  Copyright © 2019 故乡的云. All rights reserved.
//

#import "TLLoadingView.h"
#import "TLTransition.h"

@interface TLLoadingView ()
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, weak) TLTransition *transition;

@end

@implementation TLLoadingView

static TLLoadingView *LOADINGVIEW = nil;

/// 默认显示2秒，无标题
+ (instancetype)show {
    return [self showWithDuration:2.f];
}

+ (void)hide {
    [LOADINGVIEW hide];
}
- (void)hide {
    if (LOADINGVIEW) {
        [LOADINGVIEW.transition dismiss];
        LOADINGVIEW = nil;
    }
}

+ (instancetype)showWithDuration:(NSTimeInterval)duration {
    NSAssert(!LOADINGVIEW, (@"TLLoadingView组件，同一时间只允许有一个实例"), self);
        
    TLLoadingView *loadView = [self new];
    LOADINGVIEW = loadView;
    
    [loadView setup];
    [loadView layoutSubviews];
    
    loadView.transition = [TLTransition showView:loadView popType:TLPopTypeAlert];
    loadView.transition.allowTapDismiss = NO;
    loadView.transition.cornerRadius = 10;
    loadView.transition.hideShadowLayer = YES;
    
    if(duration > 0){
        [LOADINGVIEW performSelector:@selector(hide) withObject:nil afterDelay:duration];
    }
    
    return LOADINGVIEW;
}

- (void)setup {
    CGFloat sizeWH = 60.f;
    CGRect bounds = CGRectMake(200, 200, sizeWH, sizeWH);
    self.frame = bounds;
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor orangeColor];
    
    CGFloat w = 3.f;
    CGFloat margin = 5.f;
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 3, 10);
    layer.cornerRadius = 1.0;
    layer.position = CGPointMake(sizeWH * 0.5f - (w + margin) * 4 * 0.5, sizeWH * 0.5f);
    layer.backgroundColor = self.tintColor.CGColor;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale.y";
    anim.toValue = @(3);
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.45;
    anim.autoreverses = YES;
    anim.removedOnCompletion = NO;
    [layer addAnimation:anim forKey:@"scaleY"];
    
    CAReplicatorLayer *repLayer = [CAReplicatorLayer layer];
    [self.layer addSublayer:repLayer];
    [repLayer addSublayer:layer];
    
    repLayer.instanceCount = 5;
    repLayer.instanceTransform = CATransform3DMakeTranslation(margin + w, 0, 0);
    repLayer.instanceDelay = 0.15;
}

@end
