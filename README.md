# TLTransitions

基于`UIPresentationController`的组件，旨在快速实现控制器/View的转场，并支持自定义动画

### V 1.0.0

#### 效果图（录屏效果不好，有重影）
![preview.gif（录屏效果不好，有重影）](https://upload-images.jianshu.io/upload_images/3333500-363b429b780964f3.gif?imageMogr2/auto-orient/strip) ![preview2.gif(键盘监听)](https://upload-images.jianshu.io/upload_images/3333500-d02d308d81d693b6.gif?imageMogr2/auto-orient/strip)

### pod
`pod 'TLTransitions', '~> 1.0.0'`

#### API与使用
```objc
#import "TLTransition.h"

/**
 * 转场形式显示popView
 * 自适应位置
 * ⚠️调用该方法时，请先设定好popView的frame/bounds/Size
 *
 * @param popView 要显示的View
 * @param pType 显示类型
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)showView:(UIView *)popView popType:(TLPopType)pType;
```
1. 支持将一个View以Alert弹框的形式显示到屏幕中间（可以支持键盘监听）
```objc
CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 200.f);
TLTransition showView:[self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)]
                   popType:TLPopTypeAlert];
```

2. 支持将一个View以ActionSheet底部弹框的形式显示到屏幕底部
```objc
CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width, 240.f);
[TLTransition showView:[self creatViewWithBounds:bounds color:tl_Color(218, 248, 120)]
                   popType:TLPopTypeActionSheet];
```

3. 将一个view显示到指定的位置
- API
```objc
/**
 * 转场形式显示popView
 * 指定位置(在view超出屏幕范围情况下会自动匹配边界【调整origin】，以保证view整体都在屏幕显示)
 * ⚠️调用该方法时，请先设定好popView的frame
 *
 * @param popView 要显示的View
 * @param point popView的最终坐标（origin相对mainScreen）
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)showView:(UIView *)popView toPoint:(CGPoint)point;
```
- 使用
```objc
CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 100.f);
UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(120, 248, 180)];
[TLTransition showView:bView toPoint:CGPointMake(50, 50)];
```

4. 将一个view由frame -动态切换成-> frame2
- API
```objc
/**
 * 显示popView, 由InitialFrame(初始) --过渡到--> FinalFrame(最终)
 * @param popView 要显示的View
 * @param iFrame present前的frame(初始)
 * @param fFrame presented后的frame(最终)
 * @return 返回转场代理TLPopTransition对象
 */
+ (instancetype)showView:(UIView *)popView
            initialFrame:(CGRect)iFrame
              finalFrame:(CGRect)fFrame;
```
- 使用
```objc
CGRect initialFrame = sender.frame;
CGRect finalFrame = CGRectMake(30, 400, self.view.bounds.size.width * 0.8f, 200.f);
UIView *bView = [self creatViewWithBounds:finalFrame color:tl_Color(250, 250, 250)];
[TLTransition showView:bView initialFrame:initialFrame finalFrame:finalFrame];
```

5. 自定义转场动画
- API
```objc
/// 自定义动画样式(注意需要准守的规则)
@property(nonatomic, copy) TLAnimateForTransition animateTransition;
```
- 使用
```objc
- (IBAction)customAnimateTransition:(UIButton *)sender {
    __weak typeof(self) wself = self;
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)];
    _transition = [TLTransition showView:bView popType:TLPopTypeAlert];
    
    NSTimeInterval duration = _transition.transitionDuration;
    _transition.animateTransition = ^(id<UIViewControllerContextTransitioning> transitionContext) {
        
        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        UIView *fromView;
        UIView *toView;
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = transitionContext.containerView;
        if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
            fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        } else {
            fromView = fromViewController.view;
            toView = toViewController.view;
        }
        
        if(toView){ // Present
            // 注意1: 一定要将视图添加到容器上
            [containerView addSubview:toView];
            
            // UIView动画
            // 动画前的样式
            // code...
//            [UIView animateWithDuration:duration animations:^{
//
//                // 最终的样式
//                // code...
//
//            } completion:^(BOOL finished) {
//                // 注意2: 必须执行，告诉transitionContext 动画执行完毕
//                [transitionContext completeTransition:YES];
//            }];
            
            // 或CATransition
            
            // 保存transitionContext，等动画结束时调用[transitionContext completeTransition:YES];
            self->_transitionContext = transitionContext; 
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself; // 设置代理，监听动画进度
            anim.duration = duration;
            anim.type = @"push"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [toView.layer addAnimation:anim forKey:nil];
            
        }else { // dismiss
            [containerView addSubview:fromView];
            
            // UIView动画
            // 动画前的样式
            // code...
//            [UIView animateWithDuration:duration animations:^{
//
//                // 最终的样式
//                // code...
//
//            } completion:^(BOOL finished) {
//                [transitionContext completeTransition:YES];
//            }];
            
            // 或CATransition
            
            self->_transitionContext = transitionContext;
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself;
            anim.duration = duration;
            anim.type = @"cube"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [fromView.layer addAnimation:anim forKey:nil];
        };
    };
}

/// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:YES];
}
```

6.动态更新size
- API
```objc
/**
 * 实时更新view的size ，显示后也可以更新
 */
- (void)updateContentSize;
```
- 使用
```
CGRect rect = _bView.bounds;
rect.size.height += 1;
_bView.bounds = rect;
[_transition updateContentSize];
```

7. 手动dismiss
- API
```objc
/**
 * 隐藏popView
 * 如果TLPopTransition没有被引用，则在隐藏后会自动释放
 * 如果popView没有被引用，在隐藏后也会自动释放
 */
- (void)dismiss;
```

- 使用
```
[_transition dismiss];
```
