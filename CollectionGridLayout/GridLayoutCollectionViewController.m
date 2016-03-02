//
//  GridLayoutCollectionViewController.m
//  CollectionGridLayout
//
//  Created by Info on 16/3/2.
//  Copyright © 2016年 skogt. All rights reserved.
//

#import "GridLayoutCollectionViewController.h"
#import "ZHLCollectionViewLayout.h"

@interface GridLayoutCollectionViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet ZHLCollectionViewLayout *layout;


@end

@implementation GridLayoutCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.layout.numOfItemPerLine = 3;
    self.layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.layout.lineSpacing = 1;
    self.layout.interItemSpacing = 1.f;
    self.layout.aspecRatio = 1.0;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (indexPath.section % 2 == 0) {
        cell.backgroundColor = [UIColor redColor];
    }
    else {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - UIActionSheet
- (IBAction)selectCol:(id)sender {
    [[[UIActionSheet alloc] initWithTitle:@"Choose Columns"
                                 delegate:self
                        cancelButtonTitle:nil
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"1",@"2",@"3",@"4",@"5", nil]
     showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.layout.numOfItemPerLine = [actionSheet buttonTitleAtIndex:buttonIndex].integerValue;
}


@end
