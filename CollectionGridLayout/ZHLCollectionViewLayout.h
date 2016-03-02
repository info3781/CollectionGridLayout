//
//  ZHLCollectionViewLayout.h
//  CollectionGridLayout
//
//  Created by Info on 16/3/2.
//  Copyright © 2016年 skogt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHLCollectionViewLayout : UICollectionViewLayout

/// default vertical
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic,assign) UIEdgeInsets sectionInset;

@property (nonatomic,assign) CGFloat interItemSpacing;

@property (nonatomic,assign) CGFloat lineSpacing;

@property (nonatomic,assign) NSInteger numOfItemPerLine;

/// 宽高的比例
@property (nonatomic,assign) CGFloat aspecRatio;

@end
