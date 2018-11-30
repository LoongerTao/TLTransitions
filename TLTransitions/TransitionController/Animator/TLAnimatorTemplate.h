//
//  TLAnimatorTemplate.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  自定义 Animator 参考模版


#import <UIKit/UIKit.h>

#ifdef NO_BUILDING // 本文件不参与编译
NS_ASSUME_NONNULL_BEGIN
@protocol TLAnimatorProtocol;
@interface TLAnimatorTemplate : NSObject <TLAnimatorProtocol>
// 在本方案下继承 UIPresentationController 可能导致循环引用

@end
NS_ASSUME_NONNULL_END

#endif
