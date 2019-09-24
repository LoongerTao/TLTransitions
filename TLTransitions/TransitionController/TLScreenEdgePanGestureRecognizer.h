//
//  TLScreenEdgePanGestureRecognizer.h
//  Example
//
//  Created by 故乡的云 on 2019/9/24.
//  Copyright © 2019 故乡的云. All rights reserved.
//

//  在 iOS 13 中UIScreenEdgePanGestureRecognizer手势失效，暂时用下面自定义手势代替

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLScreenEdgePanGestureRecognizer : UIPanGestureRecognizer
<UIGestureRecognizerDelegate>

@property (readwrite, nonatomic, assign) UIRectEdge edges;
@end

NS_ASSUME_NONNULL_END
