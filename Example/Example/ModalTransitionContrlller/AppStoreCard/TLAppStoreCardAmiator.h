//
//  TLAppStoreCardAmiator.h
//  Example
//
//  Created by 故乡的云 on 2018/11/27.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLAnimatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLAppStoreCardAmiator : NSObject <TLAnimatorProtocol>
@property(nonatomic, assign) CGRect fromRect;
@property(nonatomic, weak) UIView *cardView;
@property(nonatomic, weak) UIView *textView;

@property(nonatomic, weak, readonly) id<UIViewControllerContextTransitioning>transitionContext;

@end

NS_ASSUME_NONNULL_END
