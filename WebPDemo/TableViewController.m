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
#import "ImageDownloaderOperation.h"

#import <SDWebImageCodersManager.h>
#import <SDWebImageImageIOCoder.h>
#import <UIImageView+WebCache.h>
#import <UIView+WebCache.h>
#import <YYWebImage.h>

typedef NS_ENUM(NSUInteger, WebPDisplayStyle) {
    WebPDisplayStyleSDWebImage,
    WebPDisplayStyleFirstFrame,
    WebPDisplayStyleFirstFrameYYImage,
    WebPDisplayStyleYYWebImage
};

@interface TableViewController ()

@property (nonatomic, assign) WebPDisplayStyle displayStyle;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SDWebImageManager sharedManager].imageDownloader setOperationClass:[ImageDownloaderOperation class]];
    
    self.title = @"SDWebImage";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(changeButtonClicked:)];
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:TableViewCell.description];
    self.tableView.rowHeight = 120;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView reloadData];
}

- (void)clearButtonClicked:(id)sender {
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjectsWithBlock:^{
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
            [self.tableView reloadData];
        }];
    }];
}

- (void)changeButtonClicked:(id)sender {
    _displayStyle = (_displayStyle + 1) % 4;
    switch (_displayStyle) {
        case WebPDisplayStyleSDWebImage:
            [SDWebImageCodersManager sharedInstance].coders = @[[SDWebImageImageIOCoder sharedCoder],
                                                                [SDWebImageWebPCoder sharedCoder]];
            self.title = @"SDWebImage";
            break;
            
        case WebPDisplayStyleFirstFrame:
            [SDWebImageCodersManager sharedInstance].coders = @[[SDWebImageImageIOCoder sharedCoder],
                                                                [FirstFrameWebPCoder sharedCoder]];
            self.title = @"FirstFrame";
            break;
            
        case WebPDisplayStyleFirstFrameYYImage:
            [SDWebImageCodersManager sharedInstance].coders = @[[SDWebImageImageIOCoder sharedCoder],
                                                                [FirstFrameWebPCoder sharedCoder]];
            self.title = @"FirstFrame + YYImage";
            break;
            
        default:
            self.title = @"YYWebImage";
            break;
    }
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCell.description forIndexPath:indexPath];
    NSString *urlStr;
    switch (indexPath.row % 4) {
        case 0:
            urlStr = @"https://github.com/Silence-GitHub/WebPDemo/blob/master/Test_images/WebP_animation_1.webp?raw=true";
            break;
            
        case 1:
            urlStr = @"https://github.com/Silence-GitHub/WebPDemo/blob/master/Test_images/WebP_animation_2.webp?raw=true";
            break;
            
        case 2:
            urlStr = @"https://github.com/Silence-GitHub/WebPDemo/blob/master/Test_images/WebP_animation_3.webp?raw=true";
            break;
            
        default:
            urlStr = @"https://github.com/Silence-GitHub/WebPDemo/blob/master/Test_images/WebP_static_1.webp?raw=true";
            break;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    switch (_displayStyle) {
        case WebPDisplayStyleSDWebImage:
        case WebPDisplayStyleFirstFrame: {
            [cell.imageView yy_cancelCurrentImageRequest];
            [cell.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSLog(@"Complete with style %@, image: %@, error: %@", @(_displayStyle), image, error);
            }];
            break;
        }
        case WebPDisplayStyleFirstFrameYYImage: {
            [cell.imageView yy_cancelCurrentImageRequest];
            [cell.imageView sd_cancelCurrentImageLoad];
            cell.imageView.image = nil;
            [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                NSLog(@"Complete with style %@, image: %@, error: %@", @(_displayStyle), image, error);
                if ([image isKindOfClass:[YYImage class]]) {
                    cell.imageView.image = image;
                } else if (data) {
                    YYImage *yyimage = [YYImage imageWithData:data];
                    cell.imageView.image = yyimage;
                    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
                    [[SDWebImageManager sharedManager].imageCache storeImage:yyimage forKey:key toDisk:NO completion:nil];
                }
            }];
            break;
        }
        default: {
            [cell.imageView sd_cancelCurrentImageLoad];
            [cell.imageView yy_setImageWithURL:url placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                NSLog(@"Complete with style %@, image: %@, error: %@", @(_displayStyle), image, error);
            }];
            break;
        }
    }
    return cell;
}

@end
