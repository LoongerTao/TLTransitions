//
//  TLPercentDrivenInteractiveTransition.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/9.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer
                          edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
