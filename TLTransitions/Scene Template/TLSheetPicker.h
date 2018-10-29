//
//  TLSheetPicker.h
//  OusiCanteen
//
//  Created by 故乡的云 on 2018/8/7.
//  Copyright © 2018年 gxdy. All rights reserved.
//  底部弹出选择器（单列表）

#import <UIKit/UIKit.h>

typedef void(^TLSelcteHandler)(NSInteger row);


@class TLSheetPicker;
@protocol TLSheetPickerDelegate <NSObject>
@optional
/** 选中某行 */
- (void)sheetPicker:(TLSheetPicker *)picker didSelectRow:(NSInteger)row;

@end



@interface TLSheetPicker : UIView
/** 选中某行回调 */
@property (nonatomic, copy) TLSelcteHandler selcteHandler;
/** 字段list */
@property(nonatomic, strong) NSArray <NSString *>*items;
/** 默认选中行 */
@property(nonatomic, assign) NSInteger curRow;
/** 显示行数，默认5行（行高50） */
@property(nonatomic, assign) NSInteger showRows;

@property (nonatomic, weak) id <TLSheetPickerDelegate> delegate;

/**
 * 实例方法
 * curRow: 显示时需要默认选中的行 */
+ (instancetype)showPickerWithItems:(NSArray <NSString *>*)items
               defaultSelectRow:(NSInteger)curRow
               didSelectHnadler:(TLSelcteHandler)handler;
/**
 * 实例方法
 * curRow: 显示时需要默认选中的行 */
+ (instancetype)showPickerWithItems:(NSArray <NSString *>*)items
                   defaultSelectRow:(NSInteger)curRow
                           delegate:(id <TLSheetPickerDelegate>)delegate;

/// 指定选中某row行
- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated;
- (void)dismiss;
@end
