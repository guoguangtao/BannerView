//
//  GPBannerLayout.m
//  Banner
//
//  Created by ggt on 2017/2/28.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPBannerLayout.h"

@interface GPBannerLayout ()

@end

@implementation GPBannerLayout

/**
 初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = self.spacing;
    CGFloat inset = (self.collectionView.bounds.size.width - self.itemWidth) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}


/**
 设置每次都可以刷新界面
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕的中心X位置
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    // 计算可视范围
    CGRect seeRect;
    seeRect.origin = self.collectionView.contentOffset;
    seeRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        // 如果当前屏幕没有显示则不计算
        if (!CGRectIntersectsRect(seeRect, attributes.frame)) continue;
        // 获取到Item的中心X
        CGFloat itemCenterX = attributes.center.x;
        // 计算宽度缩放比例
        CGFloat widthScale = (1 - ABS(centerX - itemCenterX) / self.collectionView.bounds.size.width * 0.5) * self.maxWidth / self.itemWidth;
        widthScale = widthScale < 1.0f ? 1.0f : widthScale;
        // 计算高度缩放比例
        CGFloat heightScale = self.itemWidth * widthScale * self.maxHeight / self.maxWidth / self.itemHeight;
        
        // 设置Item
        attributes.transform3D = CATransform3DMakeScale(widthScale, heightScale, 1.0f);
    }
    
    return attributesArray;
}

@end
