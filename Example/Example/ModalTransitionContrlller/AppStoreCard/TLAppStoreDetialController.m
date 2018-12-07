//
//  TLAppStoreDetialController.m
//  Example
//
//  Created by 故乡的云 on 2018/11/27.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLAppStoreDetialController.h"
#import "TLAppStoreCardAmiator.h"
#import "TLTransitions.h"
#import "TLTransitionDelegate.h"

@interface TLAppStoreDetialController ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, assign) BOOL allowDismiss;


@end

@implementation TLAppStoreDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.textLabel];
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, 1000);
    self.imageView.image = [UIImage imageNamed:_imgName];
    self.textLabel.text = @"The appearance of labels is configurable, and they can display attributed strings, allowing you to customize the appearance of substrings within a label. You can add labels to your interface programmatically or by using Interface Builder.\
    The following steps are required to add a label to your interface:\
    Supply either a string or an attributed string that represents the content.\
    If using a nonattributed string, configure the appearance of the label.\
    Set up Auto Layout rules to govern the size and position of the label in your interface.\
    Provide accessibility information and localized strings.";
    
    [self viewDidLayoutSubviews];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
    }
    return  _textLabel;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _scrollView.frame = self.view.bounds;
    _imageView.frame = CGRectMake(0, 0, _scrollView.bounds.size.width, 400 / 0.88);
    _textLabel.frame = CGRectMake(10, _imageView.bounds.size.height, _scrollView.bounds.size.width - 20, 300);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 添加dismiss手势
    if (_allowDismiss && scrollView.contentOffset.y < 0) {
        _allowDismiss = NO;
        self.transitionDelegate.tempInteractiveDirection = TLDirectionToBottom;
        self.transitionDelegate.interactiveRecognizer = scrollView.panGestureRecognizer;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _allowDismiss = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _allowDismiss = NO;
}

@end
