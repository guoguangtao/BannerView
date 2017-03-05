//
//  GPBannerLayout.h
//  Banner
//
//  Created by ggt on 2017/2/28.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPBannerLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat itemWidth; /**< Item 的宽度 */
@property (nonatomic, assign) CGFloat itemHeight; /**< Item 的高度 */
@property (nonatomic, assign) CGFloat maxWidth; /**< 缩放最大宽度 */
@property (nonatomic, assign) CGFloat maxHeight; /**< 缩放最大高度 */
@property (nonatomic, assign) CGFloat spacing;  /**< 间距 */

@end
