# TLTransitions

### pod支持
```
pod 'TLTransitions', '~> 1.4.1'
```

### **1. 目的**
让繁琐的个性化控制器的转场(present/pop)和视图弹窗实现，变的简单快速（一句代码或几行即可搞定），并支持动画的自定义，支持通过手势转场（dismiss/pop）

### **2. 实现基础** 
- 控制器的转场基于协议`UIViewControllerTransitioningDelegate`,`UINavigationControllerDelegate`，`UIViewControllerAnimatedTransitioning`
 - View弹窗则是通过控制器的转场包装而来，同时还基于`UIPresentationController`

### **使用与说明**
####  1. View弹窗：
- 使用：对应`TLTransition`类的API，只要一行代码即可将一个已有的View进行显示，使用如下（`更多用法见demo`）
```objc
// popView是一个用户自定义的视图，并且已经设置好布局
[TLTransition showView:popView popType:TLPopTypeAlert];
```

- 可实现如下效果：
    1. 系统Alert样式的中间弹窗，并支持键简单的盘高度自适应（可关闭）
    
   ![alert.gif](https://upload-images.jianshu.io/upload_images/3333500-a1862b84e09c65cd.gif?imageMogr2/auto-orient/strip)

    2. 系统Action Sheet样式的底部弹窗
    
   ![actionSheet.gif](https://upload-images.jianshu.io/upload_images/3333500-b6f9d07cd39f6347.gif?imageMogr2/auto-orient/strip)

    3. 将一个view显示到指定的位置
    
   ![point.gif](https://upload-images.jianshu.io/upload_images/3333500-8400581effaabdaa.gif?imageMogr2/auto-orient/strip)

    4. 将一个view从frame1动画到frame2
    
   ![frame.gif](https://upload-images.jianshu.io/upload_images/3333500-ada674cbd225e62d.gif?imageMogr2/auto-orient/strip)

    5. 动画自定义，提供block将自定义动画传入即可
    
  ![customforview.gif](https://upload-images.jianshu.io/upload_images/3333500-1036eb2a60e89ae4.gif?imageMogr2/auto-orient/strip)

- 其他API
1. 动态更新size（效果如上面ActionSheet样式所示，仅限size，不能改变位置）

```objc
// 实时更新view的size ，显示后也可以更新
- (void)updateContentSize;

// 使用
CGRect rect = _bView.bounds;
rect.size.height += 1;
_bView.bounds = rect;
[_transition updateContentSize];
```
2. 手动dismiss(正常情况通过点击灰色区域进行dismiss，无需手动调用API)
```objc
/**
 * 隐藏popView
 * 如果TLTransition没有被引用，则在隐藏后会自动释放
 * 如果popView没有被引用，在隐藏后也会自动释放
 */
- (void)dismiss;

// 使用
[_transition dismiss];
```

#### 2. UIViewController转场：
- 控制器转场思维结构图
   ![思维结构图](https://upload-images.jianshu.io/upload_images/3333500-58489f3c2cb8e169.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 - API:
1. 所在类：分类`UIViewController+Transitioning`和遵守`TLTLAnimatorProtocol`协议的`Animator`类
2. 支持多种模式的动画(具体API见上述类头文件)：
  - present：`系统原生转场动画`（非自定义转场）、`Swipe系列`、`CATransition系列动画` 、`Cunstom Block模式`、`案例锦集`
 - push：`Swipe系列`、`CATransition系列` 、`Cunstom模式`、`案例锦集`
3. 支持自定义动画[Animator]（`非Cunstom模式`）
只要基于`TLTLAnimatorProtocol`协议即可，具体实现可参考模版`TLAnimatorTemplate`里面有一些思路与注意事项
4. 所以类型API都默认支持侧滑手势dismiss/pop，可以关闭（如果要手动dismiss/pop，只需调用原生API即可）
4. 部分转场效果图
- 原生present

![system.gif](https://upload-images.jianshu.io/upload_images/3333500-40355d0619cbb726.gif?imageMogr2/auto-orient/strip)

 - Swipe
 
![swipe.gif](https://upload-images.jianshu.io/upload_images/3333500-080df94e9d1cd8ec.gif?imageMogr2/auto-orient/strip)

- CATransition

![CATransition.gif](https://upload-images.jianshu.io/upload_images/3333500-6b16c504fca3dbca.gif?imageMogr2/auto-orient/strip)

- Cunstom

![custom.gif](https://upload-images.jianshu.io/upload_images/3333500-8727ef6aadda6a5d.gif?imageMogr2/auto-orient/strip)

- 锦集

![锦集.gif](https://upload-images.jianshu.io/upload_images/3333500-a935d0c0a257c0bf.gif?imageMogr2/auto-orient/strip)

5. 使用步骤与举例
可以一步实现，也可以分步实现
  a. 一步实现：
```objc
更多API的使用见demo

TLSecondViewController *vc = [[TLSecondViewController alloc] init];
 //  vc.disableInteractivePopGestureRecognizer = YES; // 关闭侧滑pop手势

// push (直接使用self发起API调用）
[self pushViewController: vc
               swipeType: TLSwipeTypeInAndOut
           pushDirection: TLDirectionToRight
            popDirection: TLDirectionToRight];

/** present
[self presentViewController:vc
                  swipeType: TLSwipeTypeInAndOut
           presentDirection:TLDirectionToRight
           dismissDirection:TLDirectionToRight
                 completion:^ {
                     // 完成回调
}];
*/
  ```
  b.分步实现（建议使用，更灵活、多样化、统一化）：
    1. 创建动画管理者
    2. 设置动画时间
    3. 设置手势使能
```objc
更多API的使用见demo

// 1.创建动画管理者
TLCATransitonAnimator *animator;
animator = [TLCATransitonAnimator animatorWithTransitionType:transitionType
                                                   direction:direction
                                     transitionTypeOfDismiss:transitionTypeOfDismiss
                                          directionOfDismiss:dismissDirection];
 // 2.动画时间
animator.transitionDuration = 3.0;

TLSecondViewController *vc = [[TLSecondViewController alloc] init];
// 3.关闭手势
vc.disableInteractivePopGestureRecognizer = YES; 

// 调用API转场
// push（直接使用self发起API调用）
[self pushViewController:vc animator:animator]; 

/** present
[self presentViewController:vc animator:animator completion:^{
        // 完成回调
  }];
*/
```

