//
//  TLFirstTableController.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/2.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TLContentTypeSystemAnimator,
    TLContentTypeSwipeAnimator,
    TLContentTypeCATransitionAnimator,
    TLContentTypeCuStomAnimator,
    TLContentTypeOther,
} TLContentType;

NS_ASSUME_NONNULL_BEGIN

@interface TLFirstTableController : UITableViewController
@property(nonatomic, assign) BOOL isPush;
@property(nonatomic, assign) TLContentType type;
@end

NS_ASSUME_NONNULL_END
