#import "TLTransitions.h"





// 所在头文件
#import "UIViewController+Transitioning.h"

// 对应API
/**
 * push 转场控制器。
 * @param viewController 要转场的控制器
 * @param animator 转场动画管理对象
 *        目前提供“TLSwipeAnimator”、“TLCATransitionAnimator”、“TLCuStomAnimator” 、 “TLAnimator”供选择，
 *        也可以由开发者自己写一个这样的对象，需要 严格遵守 TLAnimatorProtocal协议（可以参考模版TLAnimatorTemplate）
 */
- (void)pushViewController:(UIViewController *)viewController animator:(id<TLAnimatorProtocol>)animator;

// 案例
TLAnimator *animator = [TLAnimator animatorWithType:TLAnimatorTypeRectScale];
UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
CGRect frame = [cell convertRect:cell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
animator.fromRect = frame;
animator.toRect = CGRectMake(0, tl_ScreenH - 210, tl_ScreenW, 210);
animator.rectView = cell.imageView;
animator.isOnlyShowRangeForRect = indexPath.row >= TLAnimatorTypeRectScale;
vc.isShowImage = YES;


[self pushViewController:[[TLSecondViewController alloc] init] animator:animator];
