//
//  ViewController.m
//  Example
//
//  Created by 故乡的云 on 2018/10/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "ViewController.h"
#import "TLTransition.h"
#import "TowViewController.h"
#import "UIViewController+Presenting.h"

@interface ViewController ()<CAAnimationDelegate>{
    UIView *_bView;
    UILabel *_titleLabel;
    TLTransition *_transition;
    
    id<UIViewControllerContextTransitioning> _transitionContext;
    CATransition *_anim1;
}

@property(nonatomic, weak) IBOutlet UISegmentedControl *directionsSgmt;
@property(nonatomic, weak) UISegmentedControl *sgmt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserverForName:@"TowViewControllerDidDealloc" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (self->_sgmt) {
            self->_sgmt.selectedSegmentIndex = self->_sgmt.numberOfSegments - 1;
        }
    }];
}

#pragma mark - Transitions Of View
// TLPopTypeAlert
- (IBAction)alertType:(UIButton *)sender {
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(218, 248, 120)];
    
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.backgroundColor = tl_Color(255, 255, 255);
    textFiled.bounds = CGRectMake(0, 0, bView.bounds.size.width * 0.8f, 30.f);
    textFiled.center = CGPointMake(bView.bounds.size.width * 0.5, bView.bounds.size.height * 0.2);
    [bView addSubview:textFiled];
    
    [TLTransition showView:bView popType:TLPopTypeAlert];
}

// TLPopTypeActionSheet
- (IBAction)actionSheetType:(UIButton *)sender {
    
    
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)];
    _transition = [TLTransition showView:bView popType:TLPopTypeActionSheet];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bView addGestureRecognizer:tap];
}

// to point
- (IBAction)pointType:(UIButton *)sender {
    
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 100.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(120, 248, 180)];
    [TLTransition showView:bView toPoint:CGPointMake(-50, -50)];
}

// frame1->frame2
- (IBAction)frameType:(UIButton *)sender {
    
    CGRect initialFrame = sender.frame;
    CGRect finalFrame = CGRectMake(30, 400, self.view.bounds.size.width * 0.8f, 200.f);
    UIView *bView = [self creatViewWithBounds:initialFrame color:tl_Color(250, 250, 250)];
    [TLTransition showView:bView initialFrame:initialFrame finalFrame:finalFrame];
}

// 自定义动画
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
            
            // 注意: 一定要将视图添加到容器上
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
//                // 必须执行：告诉transitionContext 动画执行完毕
//                [transitionContext completeTransition:YES];
//            }];
            
            // 或CATransition
            self->_transitionContext = transitionContext;
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself;
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
            anim.duration = 1.0;//duration;
            anim.type = @"cube"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [fromView.layer addAnimation:anim forKey:nil];
        };
    };
}

- (UIView *)creatViewWithBounds:(CGRect)bounds color:(UIColor *)color {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectZero];
    BView.backgroundColor = color;
    BView.bounds = bounds;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [BView addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.text = @"View B";
    titleLabel.font = [UIFont systemFontOfSize:80];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = BView.bounds;
    
    _bView = BView;
    [BView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    return BView;
}

- (void)tap {
    CGRect rect = _bView.bounds;
    rect.size.height += 1;
    _bView.bounds = rect;
    [_transition updateContentSize];
    
}


#pragma mark - Transitions Of View Controller

- (IBAction)systemTransitions:(UISegmentedControl *)sgmt {
    if (sgmt.selectedSegmentIndex == sgmt.numberOfSegments - 1) return;
    _sgmt = sgmt;
    
    TowViewController *vc = [[TowViewController alloc] init];
    [self presentViewController:vc transitionStyle:sgmt.selectedSegmentIndex completion:^{
        NSLog(@"system : completion---%zi",sgmt.selectedSegmentIndex);
    }];
    sgmt.selectedSegmentIndex = sgmt.numberOfSegments - 1;
}

- (IBAction)swipeTransitions:(UISegmentedControl *)sgmt {
    if (sgmt.selectedSegmentIndex == sgmt.numberOfSegments - 1) return;
    _sgmt = sgmt;
    
    TowViewController *vc = [[TowViewController alloc] init];
    //    UIRectEdgeTop    = 1 << 0,
    //    UIRectEdgeLeft   = 1 << 1,
    //    UIRectEdgeBottom = 1 << 2,
    //    UIRectEdgeRight  = 1 << 3,
    UIRectEdge targetEdge = 1 << sgmt.selectedSegmentIndex;
    [self presentViewController:vc
                swipeTargetEdge:targetEdge
               reverseOfDismiss:_directionsSgmt.selectedSegmentIndex == 1
                     completion:^{
        NSLog(@"system : completion---%zi",sgmt.selectedSegmentIndex);
    }];
}

- (IBAction)CATransitionType:(UISegmentedControl *)sgmt {
    if (sgmt.selectedSegmentIndex == sgmt.numberOfSegments - 1) return;
    _sgmt = sgmt;
    
    TowViewController *vc = [[TowViewController alloc] init];
    switch (sgmt.selectedSegmentIndex) {
        case 0:
        {
            [self presentToViewController:vc
                           transitionType:kCATransitionFade
                                  subtype:kCATransitionFromRight
                               completion:^{
                NSLog(@"CATransition : completion---%zi",sgmt.selectedSegmentIndex);
            }];
        }
            break;
        case 1:
        {
            [self presentToViewController:vc
                           transitionType:kCATransitionMoveIn
                                  subtype:kCATransitionFromLeft
                    dismissTransitionType:kCATransitionMoveIn
                           dismissSubtype:kCATransitionFromRight
                               completion:^{
                NSLog(@"CATransition (左进右) : completion---%zi",sgmt.selectedSegmentIndex);
            }];
        }
            break;
        case 2:
        {
            [self presentToViewController:vc
                           transitionType:kCATransitionPush
                                  subtype:kCATransitionFromRight
                               completion:^{
                                   NSLog(@"CATransition : completion---%zi",sgmt.selectedSegmentIndex);
            }];
        }
            break;
        case 3:
        {
            [self presentToViewController:vc
                           transitionType:kCATransitionReveal
                                  subtype:kCATransitionFromTop
                    dismissTransitionType:kCATransitionReveal
                           dismissSubtype:kCATransitionFromBottom
                               completion:^{
                                   NSLog(@"CATransition : completion---%zi",sgmt.selectedSegmentIndex);
            }];
        }
            break;
        case 4:
        {
            [self presentToViewController:vc
                           transitionType:@"cube"
                                  subtype:kCATransitionFromLeft
                    dismissTransitionType:@"cube"
                           dismissSubtype:kCATransitionFromRight
                               completion:^{
                                   NSLog(@"CATransition-cube : completion---%zi",sgmt.selectedSegmentIndex);
                               }];
        }
            break;
        case 5:
        {
            [self presentToViewController:vc
                           transitionType:@"suckEffect"
                                  subtype:kCATransitionFromTop
                               completion:^{
                                   NSLog(@"CATransition-suckEffect : completion---%zi",sgmt.selectedSegmentIndex);
                               }];
        }
            break;
        case 6:
        {
            [self presentToViewController:vc
                           transitionType:@"oglFlip"
                                  subtype:kCATransitionFromTop
                    dismissTransitionType:@"oglFlip"
                           dismissSubtype:kCATransitionFromBottom
                               completion:^{
                                   NSLog(@"CATransition-oglFlip : completion---%zi",sgmt.selectedSegmentIndex);
                               }];
        }
            break;
        case 7:
        {
            [self presentToViewController:vc
                           transitionType:@"rippleEffect"
                                  subtype:kCATransitionFromTop
                               completion:^{
                                   NSLog(@"CATransition-rippleEffect : completion---%zi",sgmt.selectedSegmentIndex);
                               }];
        }
            break;
        case 8:
        {
            [self presentToViewController:vc
                           transitionType:@"pageCurl"
                                  subtype:kCATransitionFromLeft
                    dismissTransitionType:@"pageUnCurl"
                           dismissSubtype:kCATransitionFromRight
                               completion:^{
                                   NSLog(@"CATransition-pageCurl-pageUnCurl : completion---%zi",sgmt.selectedSegmentIndex);
                               }];
        }
            break;
        case 9:
        {
            [self presentToViewController:vc
                           transitionType:@"cameraIrisHollowOpen"
                                  subtype:kCATransitionFromRight
                    dismissTransitionType:@"cameraIrisHollowClose"
                           dismissSubtype:kCATransitionFromRight
                               completion:^{
                                   NSLog(@"CATransition-cameraIrisHollowOpen-cameraIrisHollowClose : completion---%zi",sgmt.selectedSegmentIndex);
             }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)customTransitions:(UISegmentedControl *)sgmt {
    if (sgmt.selectedSegmentIndex == sgmt.numberOfSegments - 1) return;
    _sgmt = sgmt;
   
    TowViewController *vc = [[TowViewController alloc] init];
    [self presentToViewController:vc customAnimation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, BOOL isPresenting) {
       
        if (sgmt.selectedSegmentIndex == 0) {
            [self checkerboardAnimateTransition:transitionContext isPresenting:isPresenting];
        }else if (sgmt.selectedSegmentIndex == 1) {
            [self heartbeatAnimateTransition:transitionContext isPresenting:isPresenting];
        }else if (sgmt.selectedSegmentIndex == 2) {
            [self bounceAnimateTransition:transitionContext isPresenting:isPresenting];
        }
        
    } completion:^{
         NSLog(@"Custom : completion---%zi",sgmt.selectedSegmentIndex);
    }];
}

/// 心跳动画
- (void)heartbeatAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   isPresenting:(BOOL)isPresenting

{
    
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+ fromView/toView可能为nil
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    UIView *targetView = isPresenting  ? toView : fromView;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.toValue = @0.8;
    animation.repeatCount = 3;
    animation.duration = 0.3;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    _transitionContext = transitionContext;
    [targetView.window.layer addAnimation:animation forKey:nil];
}

/// 弹性动画
- (void)bounceAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                      isPresenting:(BOOL)isPresenting
{
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+ fromView/toView可能为nil
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    UIView *targetView = isPresenting  ? toView : fromView;
    if (isPresenting)
        targetView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    else
        targetView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    CGRect frame = targetView.frame;
    frame.origin.y = -frame.size.height;
    toView.frame = frame;
    [UIView animateWithDuration:1.0f
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5.0
                        options:0
                     animations:^{
                         CGRect frame = targetView.frame;
                         if (isPresenting) {
                             frame.origin.y = tl_ScreenH - 500;
                         }else {
                              frame.origin.y = 30;
                         }
                         
                         targetView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = targetView.frame;
//                         frame.origin.y = 0;
                         targetView.frame = frame;
                         [transitionContext completeTransition:YES];
//                         targetView.transform = CGAffineTransformIdentity;
                     }];
}



/// 官方demo动画
- (void)checkerboardAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                         isPresenting:(BOOL)isPresenting
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView * fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UIImage *fromViewSnapshot;
    __block UIImage *toViewSnapshot;
    
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
    [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    fromViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
        [toView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
        toViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    UIView *transitionContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    transitionContainer.opaque = YES;
    transitionContainer.backgroundColor = UIColor.redColor;//blackColor;
    [containerView addSubview:transitionContainer];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -900.0;
    transitionContainer.layer.sublayerTransform = t;
    
    CGFloat sliceSize = round(CGRectGetWidth(transitionContainer.frame) / 10.f);
    NSUInteger horizontalSlices = ceil(CGRectGetWidth(transitionContainer.frame) / sliceSize);
    NSUInteger verticalSlices = ceil(CGRectGetHeight(transitionContainer.frame) / sliceSize);
    
    const CGFloat transitionSpacing = 160.f;
    NSTimeInterval transitionDuration = 3;
    
    CGVector transitionVector;
    if (isPresenting) {
        transitionVector = CGVectorMake(CGRectGetMaxX(transitionContainer.bounds) - CGRectGetMinX(transitionContainer.bounds),
                                        CGRectGetMaxY(transitionContainer.bounds) - CGRectGetMinY(transitionContainer.bounds));
    } else {
        transitionVector = CGVectorMake(CGRectGetMinX(transitionContainer.bounds) - CGRectGetMaxX(transitionContainer.bounds),
                                        CGRectGetMinY(transitionContainer.bounds) - CGRectGetMaxY(transitionContainer.bounds));
    }
    
    CGFloat transitionVectorLength = sqrtf( transitionVector.dx * transitionVector.dx + transitionVector.dy * transitionVector.dy );
    CGVector transitionUnitVector = CGVectorMake(transitionVector.dx / transitionVectorLength, transitionVector.dy / transitionVectorLength);
    
    for (NSUInteger y = 0 ; y < verticalSlices; y++)
    {
        for (NSUInteger x = 0; x < horizontalSlices; x++)
        {
            CALayer *fromContentLayer = [CALayer new];
            fromContentLayer.frame = CGRectMake(x * sliceSize * -1.f, y * sliceSize * -1.f, containerView.bounds.size.width, containerView.bounds.size.height);
            fromContentLayer.rasterizationScale = fromViewSnapshot.scale;
            fromContentLayer.contents = (__bridge id)fromViewSnapshot.CGImage;
            
            CALayer *toContentLayer = [CALayer new];
            toContentLayer.frame = CGRectMake(x * sliceSize * -1.f, y * sliceSize * -1.f, containerView.bounds.size.width, containerView.bounds.size.height);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL wereActiondDisabled = [CATransaction disableActions];
                [CATransaction setDisableActions:YES];
                
                toContentLayer.rasterizationScale = toViewSnapshot.scale;
                toContentLayer.contents = (__bridge id)toViewSnapshot.CGImage;
                
                [CATransaction setDisableActions:wereActiondDisabled];
            });
            
            UIView *toCheckboardSquareView = [UIView new];
            toCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            toCheckboardSquareView.opaque = NO;
            toCheckboardSquareView.layer.masksToBounds = YES;
            toCheckboardSquareView.layer.doubleSided = NO;
            toCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            [toCheckboardSquareView.layer addSublayer:toContentLayer];
            
            UIView *fromCheckboardSquareView = [UIView new];
            fromCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            fromCheckboardSquareView.opaque = NO;
            fromCheckboardSquareView.layer.masksToBounds = YES;
            fromCheckboardSquareView.layer.doubleSided = NO;
            fromCheckboardSquareView.layer.transform = CATransform3DIdentity;
            [fromCheckboardSquareView.layer addSublayer:fromContentLayer];
            
            [transitionContainer addSubview:toCheckboardSquareView];
            [transitionContainer addSubview:fromCheckboardSquareView];
        }
    }
    
    __block NSUInteger sliceAnimationsPending = 0;
    
    for (NSUInteger y = 0 ; y < verticalSlices; y++)
    {
        for (NSUInteger x = 0; x < horizontalSlices; x++)
        {
            UIView *toCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2)];
            UIView *fromCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2 + 1)];
            
            CGVector sliceOriginVector;
            if (isPresenting) {
                sliceOriginVector = CGVectorMake(CGRectGetMinX(fromCheckboardSquareView.frame) - CGRectGetMinX(transitionContainer.bounds),
                                                 CGRectGetMinY(fromCheckboardSquareView.frame) - CGRectGetMinY(transitionContainer.bounds));
            } else {
                sliceOriginVector = CGVectorMake(CGRectGetMaxX(fromCheckboardSquareView.frame) - CGRectGetMaxX(transitionContainer.bounds),
                                                 CGRectGetMaxY(fromCheckboardSquareView.frame) - CGRectGetMaxY(transitionContainer.bounds));
            }
            
            CGFloat dot = sliceOriginVector.dx * transitionVector.dx + sliceOriginVector.dy * transitionVector.dy;
            CGVector projection = CGVectorMake(transitionUnitVector.dx * dot/transitionVectorLength,
                                               transitionUnitVector.dy * dot/transitionVectorLength);
            
            CGFloat projectionLength = sqrtf( projection.dx * projection.dx + projection.dy * projection.dy );
            
            NSTimeInterval startTime = projectionLength/(transitionVectorLength + transitionSpacing) * transitionDuration;
            NSTimeInterval duration = ( (projectionLength + transitionSpacing)/(transitionVectorLength + transitionSpacing) * transitionDuration ) - startTime;
            
            sliceAnimationsPending++;
            
            [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
                toCheckboardSquareView.layer.transform = CATransform3DIdentity;
                fromCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            } completion:^(BOOL finished) {
                if (--sliceAnimationsPending == 0) {
                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    
                    [transitionContainer removeFromSuperview];
                    [transitionContext completeTransition:!wasCancelled];
                }
            }];
        }
    }
}


#pragma mark - Other
/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        _titleLabel.frame = _titleLabel.superview.bounds;
    }
}

/// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:YES];
}

- (void)dealloc {
    [_bView removeObserver:self forKeyPath:@"frame"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
