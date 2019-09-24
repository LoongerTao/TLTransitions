//
//  TLModalMenuController.m
//  Example
//
//  Created by 故乡的云 on 2018/12/6.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLModalMenuController.h"
#import "TLTransitions.h"
#import "TLRegisterInteractiveController.h"
#import "TLSection.h"
#import "TLModalFirstController.h"
#import "TestViewController.h"

@interface TLModalMenuController ()
@property(nonatomic, strong) NSArray <TLSection *>*data;
@end

@implementation TLModalMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"Menu";
    
    TLSection *presentSection = [TLSection new];
    presentSection.title = @"Modal";
    presentSection.show = YES;
    presentSection.rows = @[@"System Animator", @"Swipe Animator" ,@"CATransition Animator",
                            @"CuStom Animator",@"个人动画案例收集（TLAnimator）"];
    
    
    TLSection *registerInteractiveSection = [TLSection new];
    registerInteractiveSection.title = @"注册手势进行presention";
    registerInteractiveSection.show = YES;
    registerInteractiveSection.rows = @[@"Modal"];
    _data = @[presentSection,registerInteractiveSection];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    [self testRegisterInteractiveTransition];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 手动恢复tabbar的显示
    self.tabBarController.tabBar.hidden = NO;
}

- (void)testRegisterInteractiveTransition {
    UIViewController *vc = [[UIViewController alloc] init];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = vc.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor redColor].CGColor,
                       (id)[UIColor greenColor].CGColor,
                       (id)[UIColor blueColor].CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    gradient.locations = @[@0.0, @0.5, @1.0];
    [vc.view.layer addSublayer:gradient];
    
    // 注册手势
    TLSwipeAnimator *animator = [TLSwipeAnimator animatorWithSwipeType:TLSwipeTypeInAndOut pushDirection:TLDirectionToLeft popDirection:TLDirectionToRight];
    animator.transitionDuration = 0.35f;
    // 必须初始化的属性
    animator.isPushOrPop = NO;
    animator.interactiveDirectionOfPush = TLDirectionToLeft;
    
    [self registerInteractiveTransitionToViewController:vc animator:animator];
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
    
//    TestViewController *vc = [[TestViewController alloc] init];
//    if (@available(iOS 13.0, *)) {
//        vc.modalPresentationStyle = 0;
//    } else {
//        // Fallback on earlier versions
//    }
//    [self presentViewController:vc animated:YES completion:nil];
////    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    UIViewController *viewController;
    if (indexPath.section == 1) {
        TLRegisterInteractiveController *vc = [TLRegisterInteractiveController new];
        vc.isModal = YES;
        viewController = vc;
    }else {
        TLModalFirstController *vc = [TLModalFirstController new];
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
