//
//  TLNavTransitionMenuController.m
//  Example
//
//  Created by 故乡的云 on 2018/12/6.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLNavTransitionMenuController.h"
#import "TLTransitions.h"
#import "TLFirstTableController.h"
#import "TLRegisterInteractiveController.h"
#import "TLSection.h"


@interface TLNavTransitionMenuController ()
@property(nonatomic, strong) NSArray <TLSection *>*data;

@end

@implementation TLNavTransitionMenuController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 手动恢复tabbar的显示
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Menu";
    TLSection *pushSection = [TLSection new];
    pushSection.title = @"Push / pop";
    pushSection.show = YES;
    pushSection.rows = @[@"Swipe Animator", @"CATransition Animator" ,
                         @"CuStom Animator", @"个人动画案例收集（TLAnimator）"];
    
    TLSection *registerInteractiveSection = [TLSection new];
    registerInteractiveSection.title = @"注册手势进行push";
    registerInteractiveSection.show = YES;
    registerInteractiveSection.rows = @[@"Push"];
    _data = @[pushSection,registerInteractiveSection];
    
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
    
    UIViewController *viewController;
    if (indexPath.section == 1) {
        TLRegisterInteractiveController *vc = [TLRegisterInteractiveController new];
        vc.isModal = NO;
        viewController = vc;
    }else {
        TLFirstTableController *vc = [TLFirstTableController new];
        TLContentType type = TLContentTypeOther;
        NSString *text = self.data[indexPath.section].rows[indexPath.row];
        if ([text containsString:@"System"]) {
            type = TLContentTypeSystemAnimator;
        }else if ([text containsString:@"Swipe"]) {
            type = TLContentTypeSwipeAnimator;
        }else if ([text containsString:@"CATransition"]) {
            type = TLContentTypeCATransitionAnimator;
        }else if ([text containsString:@"CuStom"]) {
            type = TLContentTypeCuStomAnimator;
        }
        vc.type = type;
        viewController = vc;
    }
    
    // 手动隐藏tabbar，解决tabbar和VC动画不统一的问题他
    viewController.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    TLCATransitonAnimator *amn = [ TLCATransitonAnimator animatorWithTransitionType:TLTransitionCube direction:TLDirectionToLeft transitionTypeOfDismiss:TLTransitionCube directionOfDismiss:TLDirectionToRight];
    [self pushViewController:viewController animator:amn];
}

@end
