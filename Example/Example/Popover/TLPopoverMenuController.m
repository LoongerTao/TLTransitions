//
//  TLPopoverMenuController.m
//  Example
//
//  Created by 故乡的云 on 2018/12/6.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLPopoverMenuController.h"
#import "TLTransitions.h"
#import "TLSection.h"
#import "TLCodeViewConroller.h"
#import "TLSheetPicker.h"
#import "TLLoadingView.h"

@interface TLPopoverMenuController ()<CAAnimationDelegate>{
    UIView *_frameView;
    UIView *_sheetView;
    UILabel *_titleLabel;
    TLTransition *_transition;
    
    id<UIViewControllerContextTransitioning> _transitionContext;
    CATransition *_anim1;
}

@property(nonatomic, strong) NSArray <TLSection *>*data;

@end

@implementation TLPopoverMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TLSection *viewSection = [TLSection new];
    viewSection.title = @"Popover（View）";
    viewSection.show = YES;
    viewSection.rows = @[@"Alert",@"Alert2", @"Action Sheet", @"To Point",@"From Frame1 To Frame2" ,@"Custom"];
    
    TLSection *componetSection = [TLSection new];
    componetSection.title = @"Componet";
    componetSection.show = YES;
    componetSection.rows = @[@"Picker", @"Loading"];
    
    _data = @[viewSection,componetSection];
    self.tableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data[section].show ? self.data[section].rows.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSString *text = self.data[indexPath.section].rows[indexPath.row];
    cell.textLabel.text = text;
//    cell.backgroundColor = tl_Color(255, 255, 230);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderReuseIdentifier"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderReuseIdentifier"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heaerViewTap:)];
        [headerView addGestureRecognizer:tap];
        
        headerView.layer.borderWidth = 0.6f;
        headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    headerView.textLabel.text = self.data[section].title;
    headerView.tag = section;
    return headerView;
}

- (void)heaerViewTap:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag;
    self.data[section].show = !self.data[section].show;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            case 1:
                [self alertType:[tableView cellForRowAtIndexPath:indexPath]];
                break;
            case 2:
                [self actionSheetType:[tableView cellForRowAtIndexPath:indexPath]];
                break;
            case 3:
                [self pointType:[tableView cellForRowAtIndexPath:indexPath]];
                break;
            case 4:
                [self frameType:[tableView cellForRowAtIndexPath:indexPath]];
                break;
            case 5:
                [self customAnimateTransition:[tableView cellForRowAtIndexPath:indexPath]];
                break;
            default:
                break;
        }
        return;
    }else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
            {
                NSArray *items = @[@"选项一", @"选项二", @"选项三", @"选项四", @"选项五",@"选项六", @"选项七", @"选项八", @"选项九", @"选项十"];
                [TLSheetPicker showPickerWithItems:items defaultSelectRow:0 didSelectHnadler:^(NSInteger row) {
                    tl_Log(@"TLSheetPicker: did selected %@", items[row]);
                }];
            }
                break;
            case 1:
            {
                [TLLoadingView show];
            }
                break;
            default:
                break;
        }
        return;
    }
}

#pragma mark - action of cell
// TLPopTypeAlert
- (void)alertType:(UITableViewCell *)sender {
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8f, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(218, 248, 120)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [bView addGestureRecognizer:tap];
    
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.backgroundColor = tl_Color(255, 255, 255);
    textFiled.bounds = CGRectMake(0, 0, bView.bounds.size.width * 0.8f, 30.f);
    textFiled.center = CGPointMake(bView.bounds.size.width * 0.5, bView.bounds.size.height * 0.2);
    [bView addSubview:textFiled];
    bView.tag = 1;
    
    if([self.tableView indexPathForCell:sender].row == 0) {
        [TLTransition showView:bView popType:TLPopTypeAlert];
    }else{
        [TLTransition showView:bView popType:TLPopTypeAlert2];
        bView.tag = 2;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [tap.view endEditing:YES];
}

// TLPopTypeActionSheet
- (void)actionSheetType:(UIView *)sender {
    if (_sheetView == nil) {
        CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width, 500.f);
        UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)];
        bView.tag = 3;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"通过pan手势改变高度";
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(bView.bounds.size.width * 0.5, 20);
        [bView addSubview:textLabel];
        
        _sheetView = bView;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_sheetView addGestureRecognizer:pan];
    }
    _transition = [TLTransition showView:_sheetView popType:TLPopTypeActionSheet];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat height = tl_ScreenH - point.y;
    if (height < 100) {
        height = 100;
    }else if (height > tl_ScreenH - 88){
        height = tl_ScreenH - 88;
    }
    
    CGRect rect = _sheetView.bounds;
    rect.size.height = height;
    _sheetView.bounds = rect;
    [_transition updateContentSize];
    
}

// to point
- (void)pointType:(UIView *)sender {
    
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.33f, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(120, 248, 180)];
    [TLTransition showView:bView toPoint:CGPointMake(self.view.bounds.size.width * .667f - 10 , 64)];
    bView.tag = 4;
}

// frame1->frame2
- (void)frameType:(UIView *)sender {
    CGRect initialFrame = [self.tableView convertRect:sender.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect finalFrame = CGRectMake(30, 220, self.view.bounds.size.width * 0.8f, 200.f);
    UIView *bView = [self creatViewWithBounds:initialFrame color:tl_Color(250, 250, 250)];
    [TLTransition showView:bView initialFrame:initialFrame finalFrame:finalFrame];
    
    bView.tag = 5;
    _titleLabel.tag = 5;
    _frameView = bView;
    [bView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

// 自定义动画
- (void)customAnimateTransition:(UIView *)sender {
    __weak typeof(self) wself = self;
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.width * 0.8, 200.f);
    UIView *bView = [self creatViewWithBounds:bounds color:tl_Color(248, 218, 200)];
    _transition = [TLTransition showView:bView popType:TLPopTypeAlert];
    bView.tag = 5;
    
    NSTimeInterval duration = _transition.transitionDuration;
    _transition.animateTransition = ^(id<UIViewControllerContextTransitioning> transitionContext) {
        
        UIView *fromView;
        UIView *toView;
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = transitionContext.containerView;
        if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
            fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        } else {
            fromView = fromViewController.view;
            toView = toViewController.view;
        }
        
        if(toView){ // Present
            
            // 注意: 一定要将视图添加到容器上
            [containerView addSubview:toView];
            
            self->_transitionContext = transitionContext;
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself;
            anim.duration = duration;
            anim.type = @"push"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [toView.layer addAnimation:anim forKey:nil];
            
        }else { // dismiss
            
            [containerView addSubview:fromView];
           
            self->_transitionContext = transitionContext;
            // 设置转场动画
            CATransition *anim = [CATransition animation];
            anim.delegate = wself;
            anim.duration = 1.0;//duration;
            anim.type = @"cube"; // 动画过渡效果
            anim.subtype = kCATransitionFromRight;
            [fromView.layer addAnimation:anim forKey:nil];
        };
    };
}

- (UIView *)creatViewWithBounds:(CGRect)bounds color:(UIColor *)color {
    UIView *BView = [[UIView alloc] initWithFrame:CGRectZero];
    BView.backgroundColor = color;
    BView.bounds = bounds;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [BView addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.text = @"B";
    titleLabel.font = [UIFont systemFontOfSize:80];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = BView.bounds;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bounds.size.width - 70, 0, 60, 30)];
    [btn setTitle:@"查看代码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(showCode:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [BView addSubview:btn];
    
    return BView;
}

#pragma mark - Other
- (void)showCode:(UIButton *)btn {
    TLCodeViewConroller *codeVc = [TLCodeViewConroller new];
    NSString *name = @"alert";
    if (btn.superview.tag == 2) {
        name = @"alert2";
    }else if (btn.superview.tag == 3) {
        name = @"actionsheet";
    }else if (btn.superview.tag == 4) {
        name = @"point";
    }else if (btn.superview.tag == 5) {
        name = @"frame";
    }else if (btn.superview.tag == 6) {
        name = @"custom";
    }
    codeVc.imgName = name;
    
    [[self viewControllerForView:btn] presentViewController:codeVc animated:YES completion:nil];
}

- (UIViewController *)viewControllerForView:(UIView *)view{
    for (UIView *next = view; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        _titleLabel.frame = _titleLabel.superview.bounds;
        
        for (UIButton *btn in _titleLabel.superview.subviews) {
            if ([btn isMemberOfClass:[UIButton class]]){
                btn.frame = CGRectMake(_titleLabel.superview.bounds.size.width - 70, 0, 60, 30);
                [_titleLabel addSubview:btn];
                _titleLabel.userInteractionEnabled = YES;
            }
        }
    }
}

/// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:YES];
}

- (void)dealloc {
    [_frameView removeObserver:self forKeyPath:@"frame"];
}

@end
