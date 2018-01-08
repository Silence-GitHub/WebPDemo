//
//  TableViewController.m
//  WebPDemo
//
//  Created by Kaibo Lu on 2017/12/31.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "FirstFrameWebPCoder.h"

#import <SDWebImageCodersManager.h>
#import <SDWebImageImageIOCoder.h>
#import <UIImageView+WebCache.h>

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SDWebImageCodersManager sharedInstance].coders = @[[SDWebImageImageIOCoder sharedCoder],
                                                        [FirstFrameWebPCoder sharedCoder]];
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:TableViewCell.description];
    self.tableView.rowHeight = 120;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCell.description forIndexPath:indexPath];
    NSString *urlStr;
    switch (indexPath.row % 3) {
        case 0:
            urlStr = @"https://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp";
            break;
            
        case 1:
            urlStr = @"https://isparta.github.io/compare-webp/image/gif_webp/webp/1.webp";
            break;
            
        default:
            urlStr = @"https://isparta.github.io/compare-webp/image/gif_webp/webp/2.webp";
            break;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    [cell.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"Completion");
    }];
    return cell;
}

@end
