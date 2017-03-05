//
//  ViewController.m
//  BannerView
//
//  Created by ggt on 2017/3/5.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "ViewController.h"
#import "GPBannerView.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, weak) GPBannerView *bannerView;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupConstraints];
}


#pragma mark - UI

- (void)setupUI {
    
    NSArray *dataSource = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"];
    GPBannerView *bannerView = [GPBannerView bannerViewWithFrame:CGRectZero dataSource:dataSource];
    bannerView.time = 3;
    [self.view addSubview:bannerView];
    self.bannerView = bannerView;
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}


#pragma mark - Custom Accessors


#pragma mark - IBActions


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol


#pragma mark - 懒加载




@end
