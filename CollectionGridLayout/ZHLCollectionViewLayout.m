//
//  ZHLCollectionViewLayout.m
//  CollectionGridLayout
//
//  Created by Info on 16/3/2.
//  Copyright © 2016年 skogt. All rights reserved.
//

#import "ZHLCollectionViewLayout.h"

@interface ZHLCollectionViewLayout()

@property (nonatomic,strong) NSMutableArray *attributesBySection;
@property (nonatomic,assign) CGFloat collectionViewContentLength;

@end

@implementation ZHLCollectionViewLayout

- (instancetype)init
{
    if (self = [super init]) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self sharedInit];
    }
    return self;
}

#pragma mark - init
- (void)sharedInit
{
    _scrollDirection = UICollectionViewScrollDirectionVertical;
    _sectionInset = UIEdgeInsetsZero;
    _interItemSpacing = 1.f;
    _lineSpacing = 1.f;
    _numOfItemPerLine = 1;
    _aspecRatio  = 1.f;
}


#pragma mark - Layout
- (void)prepareLayout
{
    [self caulContentLength];
    [self layoutAttributes];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionViewContentLength);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visableArr = [NSMutableArray array];
    for (NSArray *sectionAttArr in self.attributesBySection) {
        for (UICollectionViewLayoutAttributes *attriBute in sectionAttArr) {
            if (CGRectIntersectsRect(rect, attriBute.frame)) {
                [visableArr addObject:attriBute];
            }
        }
    }
    return visableArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.attributesBySection[indexPath.section][indexPath.row];
}

#pragma mark - private methods
//计算section item 布局
- (void)layoutAttributes
{
    _attributesBySection = [NSMutableArray array];
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        [self.attributesBySection addObject:[self layoutAttributesInSection:section]];
    }
}
- (NSArray *)layoutAttributesInSection:(NSInteger)section
{
    NSMutableArray *attributeArr = [NSMutableArray array];
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        [attributeArr addObject:[self layoutAttributesForCell:[NSIndexPath indexPathForItem:item inSection:section]]];
    }
    
    return [attributeArr copy];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForCell:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attribute.frame = [self frameForItem:indexPath];
    
    return attribute;
}

- (CGRect)frameForItem:(NSIndexPath *)indexPath
{
    //caul item's row and col
    CGSize cellSize = [self caulCellSize];
    NSUInteger row = indexPath.item / _numOfItemPerLine;
    NSUInteger col = indexPath.item % _numOfItemPerLine;
    
    CGRect frame = CGRectZero;
    
    CGFloat sectionStart = [self sectionStartPos:indexPath.section size:cellSize];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame.origin.x = col * cellSize.width + col * _interItemSpacing + _sectionInset.left;
        frame.origin.y = sectionStart + row * cellSize.height + row * _lineSpacing + _sectionInset.top;
    }
    
    frame.size = cellSize;
    return frame;
}
- (CGFloat)sectionStartPos:(NSInteger)section size:(CGSize)cellSize
{
    CGFloat sectionStart = 0.;
    for (NSInteger index = 0; index < section; index++) {
        sectionStart += [self sectionContentLegth:index size:cellSize];
    }
    return sectionStart;
}
- (void)caulContentLength
{
    CGFloat contentLenght = 0.f;
    CGSize cellSize = [self caulCellSize];
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        contentLenght += [self sectionContentLegth:section size:cellSize];
    }
    
    self.collectionViewContentLength = contentLenght;
    
}

- (CGFloat)sectionContentLegth:(NSInteger)section size:(CGSize)cellSize
{
    CGFloat sectionContentLength = 0.f;
    sectionContentLength += [self sectionInsetContentLength];
    NSUInteger rowItem = [self caulRowOfItem:section];
    
    sectionContentLength += rowItem * cellSize.height + (rowItem - 1) * _lineSpacing;
    
    return sectionContentLength;
}
///某个section item 行数
- (NSUInteger)caulRowOfItem:(NSInteger)section
{
    NSInteger totItemInSection = [self.collectionView numberOfItemsInSection:section];
    return totItemInSection / _numOfItemPerLine + (totItemInSection % _numOfItemPerLine == 0 ? 0 : 1);
}
- (CGFloat)sectionInsetContentLength
{
    CGFloat insetLenght = 0.;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        insetLenght = _sectionInset.top + _sectionInset.bottom;
    }
    else {
        insetLenght = _sectionInset.left + _sectionInset.right;
    }
    return insetLenght;
}

- (CGSize)caulCellSize
{
    CGFloat useableWidth = [self useableWidth];
    CGFloat itemWidth = useableWidth / _numOfItemPerLine;
    return CGSizeMake(itemWidth, itemWidth / _aspecRatio);
}
- (CGFloat)useableWidth
{
    return (self.collectionViewContentSize.width - _sectionInset.left - _sectionInset.right - (_numOfItemPerLine - 1) * _interItemSpacing);
    
}

#pragma mark - setter
- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setInterItemSpacing:(CGFloat)interItemSpacing
{
    if (_interItemSpacing != interItemSpacing) {
        _interItemSpacing = interItemSpacing;
        [self invalidateLayout];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        [self invalidateLayout];
    }
}

- (void)setNumOfItemPerLine:(NSInteger)numOfItemPerLine
{
    if (_numOfItemPerLine != numOfItemPerLine) {
        _numOfItemPerLine = numOfItemPerLine;
        [self invalidateLayout];
    }
}

- (void)setAspecRatio:(CGFloat)aspecRatio
{
    if (_aspecRatio != aspecRatio) {
        _aspecRatio = aspecRatio;
        [self invalidateLayout];
    }
}

@end
