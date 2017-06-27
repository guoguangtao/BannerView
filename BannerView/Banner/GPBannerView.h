//
//  GPBannerView.h
//  Banner
//
//  Created by ggt on 2017/3/1.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@class GPBannerView;

@protocol GPBannerViewDelegate <NSObject>

@optional

- (void)bannerView:(GPBannerView *)bannerView didSelectedAtIndex:(NSInteger)index;

@end

@interface GPBannerView : UIView

/**
 创建 BannerView
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

/**
 定时器开启
 */
- (void)timerStart;

/**
 关闭定时器
 */
- (void)invalidateTimer;

@property (nonatomic, strong) NSArray *dataSource; /**< 数据源 */
@property (nonatomic, assign) NSInteger time; /**< 定时间隔 */
@property (nonatomic, assign) CGFloat widthHeightScale; /**< 宽高的比例 */
@property (nonatomic, assign) CGFloat maxWidth; /**< 放大后的最大宽度 */
@property (nonatomic, assign) CGFloat designHeight; /**< 设计稿真实高度 */
@property (nonatomic, assign) CGFloat designWidth; /**< 设计稿真实宽度 */
@property (nonatomic, weak) id <GPBannerViewDelegate> delegate;

@end
