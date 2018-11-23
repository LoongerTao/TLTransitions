//
//  TLGlobalConfig.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/8/16.
//  Copyright © 2018年 Gdxy. All rights reserved.
//

#import "TLGlobalConfig.h"

CATransitionSubtype getSubtype(TLDirection direction) {
    CATransitionSubtype subtype = kCATransitionFromLeft;
    if (direction == TLDirectionToTop) {
        subtype = kCATransitionFromBottom;
    }else if(direction == TLDirectionToLeft) {
        subtype = kCATransitionFromRight;
    }else if(direction == TLDirectionToBottom) {
        subtype = kCATransitionFromTop;
    }else if(direction == TLDirectionToRight) {
        subtype = kCATransitionFromLeft;
    }
    
    return subtype;
}

UIRectEdge getRectEdge(TLDirection direction) {
    UIRectEdge edge = UIRectEdgeLeft;
    if (direction == TLDirectionToTop) {
        edge = UIRectEdgeBottom;
    }else if(direction == TLDirectionToLeft) {
        edge = UIRectEdgeRight;
    }else if(direction == TLDirectionToBottom) {
        edge = UIRectEdgeTop;
    }else if(direction == TLDirectionToRight) {
        edge = UIRectEdgeLeft;
    }
    
    return edge;
}

UIImage * snapshotImage(UIView *view) {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:contextRef];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

UIImage * resizableSnapshotImage(UIView *view, CGRect inRect) {
    if (CGRectEqualToRect(inRect, CGRectNull) || CGRectEqualToRect(inRect, CGRectZero)) {
        inRect = view.bounds;
    }
    //    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    //    [view drawViewHierarchyInRect:inRect afterScreenUpdates:NO];
    UIGraphicsBeginImageContext(inRect.size);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:contextRef];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}
