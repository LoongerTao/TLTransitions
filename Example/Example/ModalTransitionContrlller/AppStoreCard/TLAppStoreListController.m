//
//  TLAppStoreListController.m
//  Example
//
//  Created by 故乡的云 on 2018/11/27.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLAppStoreListController.h"
#import "TLAppStoreCardCell.h"
#import "TLTransitions.h"
#import "TLAppStoreDetialController.h"
#import "TLAppStoreCardAmiator.h"

@interface TLAppStoreListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *cards;
@end

@implementation TLAppStoreListController

static NSString * const reuseIdentifier = @"AppStoerCardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"App Store";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cards = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(tl_ScreenW * 0.88, 400);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    
    CGRect rect = CGRectOffset(self.view.bounds, 20, 0);
    rect.size.width -= 20;
    UICollectionView *cView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [self.view addSubview:cView];
    cView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cView.delegate = self;
    cView.dataSource = self;
    self.collectionView = cView;
    
    [self.collectionView registerClass:[TLAppStoreCardCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLAppStoreCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:_cards[indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformIdentity;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TLAppStoreDetialController *vc = [TLAppStoreDetialController new];
    vc.imgName = _cards[indexPath.row];
    
    TLAppStoreCardCell *cell = (TLAppStoreCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect frame = [collectionView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
    TLAppStoreCardAmiator *animator = [TLAppStoreCardAmiator new];
    animator.fromRect = frame;
    
    animator.textView = vc.textLabel;
    animator.cardView = vc.imageView;
    
    [self presentViewController:vc animator:animator completion:^{}];
    
}
@end
