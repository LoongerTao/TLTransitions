//
//  TLWheelTableViewCell.h
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/11/5.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLWheelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmtA;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmtB;

@end

NS_ASSUME_NONNULL_END
