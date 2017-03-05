//
//  GPBannerView.m
//  Banner
//
//  Created by ggt on 2017/3/1.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPBannerView.h"
#import "GPCollectionView.h"
#import "GPBannerLayout.h"
#import "GPBannerCell.h"
#import "Masonry.h"

static NSString *cellIdentifier = @"BannerViewIdentifier";

@interface GPBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) GPCollectionView *collectionView; /**< CollectionView */
@property (nonatomic, strong) GPBannerLayout *bannerLayout;  /**< 自定义布局 */
@property (nonatomic, assign) NSInteger totalImageCount; /**< Item 个数 */
@property (nonatomic, weak) NSTimer *timer; /**< 定时器 */

@end

@implementation GPBannerView

#pragma mark - Lifecycle

+ (instancetype)bannerViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource {
    
    GPBannerView *bannerView = [[self alloc] initWithFrame:frame];
    bannerView.dataSource = dataSource;
    
    return bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor purpleColor];
        self.time = 2;
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 在一开始的时候设置 CollectionView 的偏移位置
    self.collectionView.contentOffset = CGPointMake(self.collectionView.pageWidth * self.totalImageCount * 0.5, 0);
    [self timerStart];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (newSuperview == nil) {
        [self invalidateTimer];
    }
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - UI

- (void)setupUI {
    
    [self addSubview:self.collectionView];
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - Custom Accessors

/**
 传入数据源,设置数据源
 */
- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    self.totalImageCount = dataSource.count * 500;
    if (dataSource.count != 1) {
        self.collectionView.scrollEnabled = YES;
    } else {
        self.collectionView.scrollEnabled = NO;
    }
    
    [self.collectionView reloadData];
}


#pragma mark - IBActions


#pragma mark - Public


#pragma mark - Private

/**
 根据 Cell 的索引计算出页数

 @param index  Cell 索引
 @return 页数
 */
- (int)pageIndexWithCellIndex:(NSInteger)index {
    
    return (int)index % self.dataSource.count;
}

/**
 获取当前索引
 */
- (int)currentIndex {
    
    int index = self.collectionView.contentOffset.x / self.collectionView.pageWidth;
    return MAX(0, index);
}

/**
 自动滚动(定时器方法)
 */
- (void)automaticScroll
{
    if (0 == self.totalImageCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

/**
 定时器根据索引滚动

 @param targetIndex 索引
 */
- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= self.totalImageCount - self.dataSource.count) {
        targetIndex = self.totalImageCount * 0.5;
        self.collectionView.contentOffset = CGPointMake(self.collectionView.pageWidth * targetIndex, 0);
        
        return;
    }
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.pageWidth * targetIndex, 0) animated:YES];
}

/**
 定时器开启
 */
- (void)timerStart {
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

/**
 关闭定时器
 */
- (void)invalidateTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

/**
 根据点击的 Item 的下标计算当前页数

 @param item 下标
 */
- (void)selectedIndexWithItem:(NSInteger)item {
    
    if ([self.delegate respondsToSelector:@selector(bannerSelectedAtIndex:)]) {
        [self.delegate bannerSelectedAtIndex:[self pageIndexWithCellIndex:item]];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalImageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GPBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    int index = [self pageIndexWithCellIndex:indexPath.item];
    cell.imageName = self.dataSource[index];
    __weak typeof(self) weakSelf = self;
    cell.clickedBlock = ^{
        [weakSelf selectedIndexWithItem:index];
    };
    return cell;
}

#pragma mark - UIScrollViewDelegate

/// 开始拖拽,关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self invalidateTimer];
}

/// 停止拖拽,开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self timerStart];
}


#pragma mark - 懒加载

- (GPCollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        self.bannerLayout = [[GPBannerLayout alloc] init];
        self.bannerLayout.itemWidth = 126 * (260.0f / 156.0f);
        self.bannerLayout.itemHeight = 126;
        self.bannerLayout.spacing = 30;
        
        _collectionView = [[GPCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.bannerLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pageWidth = self.bannerLayout.itemWidth + self.bannerLayout.spacing;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GPBannerCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    
    return _collectionView;
}

@end
