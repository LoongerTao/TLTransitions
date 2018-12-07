//
//  TLModalFirstController.h
//  Example
//
//  Created by 故乡的云 on 2018/12/7.
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

@interface TLModalFirstController : UITableViewController
@property(nonatomic, assign) TLContentType type;
@end

NS_ASSUME_NONNULL_END
