//
//  TableViewCell.m
//  WebPDemo
//
//  Created by Kaibo Lu on 2018/1/8.
//  Copyright © 2018年 Kaibo Lu. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell {
    UIImageView *_imageView;
}

- (UIImageView *)imageView {
    return _imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 100) / 2, 10, 100, 100);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
