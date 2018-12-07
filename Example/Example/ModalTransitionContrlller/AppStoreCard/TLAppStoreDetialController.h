//
//  TLAppStoreDetialController.h
//  Example
//
//  Created by 故乡的云 on 2018/11/27.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLAppStoreCardAmiator;

NS_ASSUME_NONNULL_BEGIN

@interface TLAppStoreDetialController : UIViewController
@property(nonatomic, copy) NSString *imgName;

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_END
