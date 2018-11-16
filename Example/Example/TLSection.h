//
//  TLSection.h
//  Example
//
//  Created by 故乡的云 on 2018/11/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLSection : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL show;
@property(nonatomic, strong) NSArray *rows;
@end

NS_ASSUME_NONNULL_END
