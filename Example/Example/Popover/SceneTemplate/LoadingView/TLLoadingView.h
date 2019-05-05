//
//  TLLoadingView.h
//  Example
//
//  Created by 故乡的云 on 2019/5/5.
//  Copyright © 2019 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLLoadingView : UIView
/// 默认显示2秒，无标题
+ (instancetype)show;
+ (void)hide;

/// duration <= 0 : 一直持续，需要手动hide
+ (instancetype)showWithDuration:(NSTimeInterval)duration;


@end

NS_ASSUME_NONNULL_END
