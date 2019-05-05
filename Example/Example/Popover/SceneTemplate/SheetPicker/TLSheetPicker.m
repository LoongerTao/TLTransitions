//
//  TLSheetPicker.m
//  OusiCanteen
//
//  Created by 故乡的云 on 2018/8/7.
//  Copyright © 2018年 Gxdy. All rights reserved.
//

#import "TLSheetPicker.h"
#import "TLTransition.h"

@interface TLSheetPicker ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) TLTransition *transition;
@end

@implementation TLSheetPicker

+ (instancetype)showPickerWithItems:(NSArray <NSString *>*)items
               defaultSelectRow:(NSInteger)curRow
               didSelectHnadler:(TLSelcteHandler)handler {
    TLSheetPicker *picker = [self new];
    picker.showRows = 5;
    picker.items = items;
    picker.selcteHandler = handler;
    picker.curRow = curRow;
    [picker layoutSubviews];
    
    picker.transition = [TLTransition showView:picker popType:TLPopTypeActionSheet];
    picker.transition.cornerRadius = 0;
    picker.transition.hideShadowLayer = YES;
    return picker;
}

+ (instancetype)showPickerWithItems:(NSArray <NSString *>*)items
                   defaultSelectRow:(NSInteger)curRow
                           delegate:(id <TLSheetPickerDelegate>)delegate {
    TLSheetPicker *picker = [self new];
    picker.showRows = 5;
    picker.items = items;
    picker.delegate = delegate;
    picker.curRow = curRow;
    [picker layoutSubviews];
    
    picker.transition = [TLTransition showView:picker popType:TLPopTypeActionSheet];
    picker.transition.cornerRadius = 0;
        picker.transition.hideShadowLayer = YES;
    return picker;
}


- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    [self.tableView reloadData];
}

-(void)setCurRow:(NSInteger)curRow {
    _curRow = curRow;
    if (curRow > 0) {        
        [self scrollToRow:curRow animated:NO];
    }
}

- (void)setShowRows:(NSInteger)showRows {
    _showRows = showRows;
    [self layoutSubviews];
    [self.transition updateContentSize];
}

- (void)dismiss {
    [self.transition dismiss];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.rowHeight = 50;
        tableView.bounces = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView = tableView;
        
        [self addSubview:_tableView];
    }
    return  _tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.showRows * self.tableView.rowHeight;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(width, height);
    self.frame = frame;
    self.tableView.frame = self.bounds;
}

- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionMiddle];
}

// MARK: - table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SheetPickerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SheetPickerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = tl_TextTintColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textColor = self.curRow == indexPath.row ? tl_RedTintColor : tl_TextTintColor;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _curRow = indexPath.row; // 此处不能走Setter方法，避免选中居中
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = tl_RedTintColor;
    if (self.selcteHandler) {
        self.selcteHandler(indexPath.row);
    }
    if ([self.delegate respondsToSelector:@selector(sheetPicker: didSelectRow:)]) {
        [self.delegate sheetPicker:self didSelectRow:indexPath.row];
    }
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = tl_TextTintColor;
}

//- (void)dealloc{
//    tl_LogFunc
//}
@end
