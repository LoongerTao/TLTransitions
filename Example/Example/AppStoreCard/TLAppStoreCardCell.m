//
//  TLAppStoreCardCell.m
//  Example
//
//  Created by 故乡的云 on 2018/11/27.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLAppStoreCardCell.h"

@implementation TLAppStoreCardCell {
    UIImageView *_imgView;
}

- (UIImageView *)imageView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
    }
    return  _imgView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

@end
