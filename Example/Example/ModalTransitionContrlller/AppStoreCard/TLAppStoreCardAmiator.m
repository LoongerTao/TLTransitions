//
//  TLAppStoreCardAmiator.m
//  Example
//
//  Created by 故乡的云 on 2018/11/27.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLAppStoreCardAmiator.h"


@implementation TLAppStoreCardAmiator {
    id<UIViewControllerContextTransitioning> _tCtx;
}

#pragma mark - TLAnimatorProtocol
@synthesize transitionDuration;
@synthesize isPushOrPop;
@synthesize interactiveDirectionOfPush;

- (TLDirection)interactiveDirectionOfPop {
    return TLDirectionToRight;
}

- (CGFloat)percentOfFinishInteractiveTransition {
    return 0.9;
}

- (CGFloat)percentOfFinished {
    return 0.99f;
}

- (CGFloat)speedOfPercent {
    return 2;
}


- (id<UIViewControllerContextTransitioning>)transitionContext {
    return _tCtx;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0.f;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(!self.isPushOrPop, @"TLAppStoreCardAmiator only support present transition");
    if(CGRectEqualToRect(self.fromRect, CGRectNull) || CGRectEqualToRect(self.fromRect, CGRectZero)) {
        NSAssert(NO, @"TLAppStoreCardAmiator 类型必须初始化 fromRect");
    }
    _tCtx = transitionContext;
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    !isPresenting ? nil : [containerView addSubview:toView];
    
    UIViewController *tragetVC = isPresenting ? toViewController : fromViewController;
    
    UIView *snapshotOfCard;
    UIView *snapshotOfText;
    UIView *roundedCardWrapperView;
    UIVisualEffectView *effectView;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = containerView.bounds;
    
    [tragetVC.view layoutIfNeeded];
    snapshotOfCard =  [self.cardView resizableSnapshotViewFromRect:self.cardView.frame afterScreenUpdates:isPresenting withCapInsets:UIEdgeInsetsZero];
    snapshotOfCard.frame = self.cardView.frame;
    
    CGRect rect = CGRectZero;
    rect.size.height = self.textView.frame.size.height;
    rect.size.width = self.cardView.frame.size.width;
    rect.origin.y = self.textView.frame.origin.y;
    snapshotOfText =  [tragetVC.view resizableSnapshotViewFromRect:rect afterScreenUpdates:isPresenting withCapInsets:UIEdgeInsetsZero];
    snapshotOfText.frame = rect;
    
    rect = [transitionContext finalFrameForViewController:tragetVC];
    
    roundedCardWrapperView = [[UIView alloc] initWithFrame:rect];
    roundedCardWrapperView.layer.masksToBounds = YES;
    [roundedCardWrapperView addSubview:snapshotOfText];
    [roundedCardWrapperView addSubview:snapshotOfCard];
    
    [containerView addSubview:effectView];
    [containerView addSubview:roundedCardWrapperView];
    
    CGFloat scale = self.fromRect.size.width / snapshotOfCard.bounds.size.width;
    
    if (isPresenting) {
        
        roundedCardWrapperView.layer.cornerRadius = 10;
        roundedCardWrapperView.frame = self->_fromRect;
        
        rect = snapshotOfCard.frame;
        rect.size.width = self->_cardView.frame.size.width * scale;
        rect.size.height = self->_cardView.frame.size.height * scale;
        snapshotOfCard.frame = rect;
        
        rect = snapshotOfText.frame;
        rect.size.width = snapshotOfCard.frame.size.width;;
        rect.size.height = self->_textView.frame.size.height * scale;
        rect.origin.y -= rect.size.height;
        snapshotOfText.frame = rect;
        
        [UIView animateWithDuration:0.12 animations:^{
            CGRect frame = [transitionContext finalFrameForViewController:tragetVC];
            CGRect rect = frame;
            rect.size.width *= scale;
            rect.size.height *= scale;
            rect.origin.y = (frame.size.height - rect.size.height) * 0.5;
            rect.origin.x = (frame.size.width - rect.size.width) * 0.5;
            roundedCardWrapperView.frame = rect;
            
            rect = snapshotOfCard.frame;
            rect.size.width = self->_cardView.frame.size.width * scale;
            rect.size.height = self->_cardView.frame.size.height * scale;
            snapshotOfCard.frame = rect;
            
            rect = snapshotOfText.frame;
            rect.size.width = snapshotOfCard.frame.size.width;;
            rect.size.height = self->_textView.frame.size.height * scale;
            rect.origin.y = snapshotOfCard.frame.size.height;
            snapshotOfText.frame = rect;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                roundedCardWrapperView.transform = CGAffineTransformMakeScale(1 / scale, 1 / scale);
                roundedCardWrapperView.layer.cornerRadius = 10;
                
            }completion:^(BOOL finished) {
            
                [effectView removeFromSuperview];
                [roundedCardWrapperView removeFromSuperview];
                
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }];
        
        return;
    }
    
    scale = 0.8f;
    roundedCardWrapperView.transform = CGAffineTransformIdentity;
    roundedCardWrapperView.layer.cornerRadius = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        roundedCardWrapperView.transform = CGAffineTransformMakeScale(scale, scale);
        roundedCardWrapperView.layer.cornerRadius = 10;
        
    }completion:^(BOOL finished) {
        
        if (transitionContext.transitionWasCancelled) {
            roundedCardWrapperView.transform = CGAffineTransformIdentity;
            [effectView removeFromSuperview];
            [roundedCardWrapperView removeFromSuperview];
            
            [transitionContext completeTransition:NO];
            return;
        }
        
        CGRect rect = roundedCardWrapperView.frame;
        roundedCardWrapperView.transform = CGAffineTransformIdentity;
        roundedCardWrapperView.frame = rect;

        rect = snapshotOfCard.frame;
        rect.size.width *= scale;
        rect.size.height *= scale;
        snapshotOfCard.frame = rect;

        rect = snapshotOfText.frame;
        rect.size.width *= scale;
        rect.size.height *= scale;
        rect.origin.y *= scale;
        snapshotOfText.frame = rect;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            roundedCardWrapperView.frame = self->_fromRect;
            snapshotOfCard.frame = roundedCardWrapperView.bounds;
            CGRect rect = snapshotOfText.frame;
            rect.origin.y = 0;
            snapshotOfText.frame = rect;

        } completion:^(BOOL finished) {
            [effectView removeFromSuperview];
            [roundedCardWrapperView removeFromSuperview];

            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }];
}
@end
