//
//  TLPopViewController.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/8/3.
//  Copyright © 2018年 Gxdy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLGlobalConfig.h"

@interface TLPopViewController : UIViewController
@property(nonatomic, weak) UIView *popView;
/// 实时更新view的size
- (void)updateContentSize;
@end
