//
//  GPBannerView.h
//  Banner
//
//  Created by ggt on 2017/3/1.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GPBannerViewDelegate <NSObject>

@optional

- (void)bannerSelectedAtIndex:(NSInteger)index;

@end

@interface GPBannerView : UIView

/**
 创建 BannerView
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

@property (nonatomic, strong) NSArray *dataSource; /**< 数据源 */
@property (nonatomic, assign) NSInteger time; /**< 定时间隔 */
@property (nonatomic, weak) id <GPBannerViewDelegate> delegate;

@end
