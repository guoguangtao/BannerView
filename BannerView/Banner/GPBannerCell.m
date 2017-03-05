//
//  GPBannerCell.m
//  Banner
//
//  Created by ggt on 2017/2/28.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPBannerCell.h"

@interface GPBannerCell ()

@property (nonatomic, weak) UIImageView *imageView; /**< 图片 */
@property (nonatomic, weak) UIImageView *newsTitleBackgroundImageView; /**< 新闻标题背景图片 */
@property (nonatomic, weak) UILabel *newsTitleLabel; /**< 新闻标题 */

@end

@implementation GPBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    
    // 1.图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [imageView addGestureRecognizer:tap];
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)tap {
    
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

@end
