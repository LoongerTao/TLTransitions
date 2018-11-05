# TLTransitions

- 基于`UIPresentationController`的组件，旨在快速实现控制器/View的转场，并支持自定义动画
- 说明：
    - View的转场：对应类`TLTransition`
    - Present/Dismiss/Push/Pop：对应分类`UIViewController+Transitioning`
   

### V 1.1.0

#### 效果图（录屏效果不好，有重影图 1-3：view ，4：present， 5：push）
![preview.gif（录屏效果不好，有重影）](https://upload-images.jianshu.io/upload_images/3333500-363b429b780964f3.gif?imageMogr2/auto-orient/strip) ![preview2.gif(键盘监听)](https://upload-images.jianshu.io/upload_images/3333500-d02d308d81d693b6.gif?imageMogr2/auto-orient/strip) 
![view.gif](https://upload-images.jianshu.io/upload_images/3333500-86257a1a7e8239fc.gif?imageMogr2/auto-orient/strip) ![present/dismiss.gif](https://upload-images.jianshu.io/upload_images/3333500-ea5726ef46174f98.gif?imageMogr2/auto-orient/strip) ![push/pop.gif](https://upload-images.jianshu.io/upload_images/3333500-5738597b55a6eb2e.gif?imageMogr2/auto-orient/strip)

### pod
`pod 'TLTransitions', '~> 1.1.0'`

#### 一.View的转场API与使用
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
- 使用见demo


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
```objc
[_transition dismiss];
```

#### 一.控制器的转场API（present/push）
- 具体使用见demo 案列

```objc
#import"UIViewController+Transitioning.h"

/// 转场动画时长，可以在执行present前根据不同动画类型进行调整。默认：0.45f,最小0.01。
@property(nonatomic, assign) NSTimeInterval transitionDuration;
```

##### 1.Present / Dismiss
```objc
/**
 * 转场控制器(官方原生类型)
 * @param vc 要转场的控制器
 * @param style 转场动画类型
 *          `UIModalTransitionStyleCoverVertical=0, 默认方式，竖向上推`
 *          `UIModalTransitionStyleFlipHorizontal, 水平反转`
 *          `UIModalTransitionStyleCrossDissolve, 隐出隐现`
 *          `UIModalTransitionStylePartialCurl, 部分翻页效果`
 * @param completion 完成转场的回调
 */
- (void)presentViewController:(UIViewController *)vc
              transitionStyle:(UIModalTransitionStyle)style
                   completion:(void (^ __nullable)(void))completion;

/**
 * 以滑动的方式转场控制器
 * @param vc 要转场的控制器
 * @param presentDirection present方向（指向）
 * @param dismissDirection dismiss方向（指向）
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentViewController:(UIViewController *)vc
                    swipeType:(TLSwipeType)swipeType
                presentDirection:(TLDirectionType)presentDirection
                 dismissDirection:(TLDirectionType)dismissDirection
                   completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器
 * @param vc 要转场的控制器
 * @param tType 转场动画类型（本质NSString类型）
 *          `kCATransitionFade`
 *          `kCATransitionMoveIn`
 *          `kCATransitionPush`
 *          `kCATransitionReveal`
 *          其它官方私有API：@"cube"、@"suckEffect"、@"oglFlip"、@"rippleEffect"、@"pageCurl"、@"pageUnCurl"、
 *          @"cameraIrisHollowOpen"、@"cameraIrisHollowClose"
 * @param subtype 转场方向（本质NSString类型）
 *          `kCATransitionFromRight`
 *          `kCATransitionFromLeft`
 *          `kCATransitionFromTop`
 *          `kCATransitionFromBottom`
  * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentToViewController:(UIViewController *)vc
                  transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
                     completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器
 * @param vc 要转场的控制器
 * @param tType present动画类型
 * @param subtype present方向
 * @param tTypeForDismiss dismiss动画类型
 * @param subtypeForDismiss dismiss方向
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentToViewController:(UIViewController *)vc
                 transitionType:(CATransitionType)tType
                        subtype:(CATransitionSubtype)subtype
          dismissTransitionType:(CATransitionType)tTypeForDismiss
                 dismissSubtype:(CATransitionSubtype)subtypeForDismiss
                     completion:(void (^ __nullable)(void))completion;

/**
 * 转场控制器
 * @param vc 要转场的控制器
 * @param animation 自定义动画（分presenting和dismiss）
 *        isPresenting = YES，Present；isPresenting = NO，Dismiss，
          不需要再给transitionContext.containerView添加subview
 *        ⚠️ 动画结束一定要调用[transitionContext completeTransition:YES];
 *
 * @param completion 完成转场的回调
 * NOTE: 由于自定义情况下，系统不会将当前c控制器（self）从窗口移除，所以dismiss后，系统不会调用`- viewDidAppear:`和`- viewWillAppear:`等方法
 */
- (void)presentToViewController:(UIViewController *)vc
                customAnimation:(void (^)( id<UIViewControllerContextTransitioning> transitionContext, BOOL isPresenting))animation
                     completion:(void (^ __nullable)(void))completion;
```

##### 2.Push / Pop
```objc
/**
 * 以滑动的方式转场控制器(Push / Pop)
 * @param vc 要转场的控制器
 * @param pushDirection push方向（指向）
 * @param popDirection pop方向（指向）
 * NOTE: 手动Pop --> [self.navigationController popViewControllerAnimated:YES];
 */
- (void)pushViewController:(UIViewController *)vc
                 swipeType:(TLSwipeType)swipeType
             pushDirection:(TLDirectionType)pushDirection
              popDirection:(TLDirectionType)popDirection;
```              
