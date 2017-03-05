//
//  GPBannerCell.h
//  Banner
//
//  Created by ggt on 2017/2/28.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedBlock)(void);

@interface GPBannerCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) ClickedBlock clickedBlock; /**< 回调 */

@end
