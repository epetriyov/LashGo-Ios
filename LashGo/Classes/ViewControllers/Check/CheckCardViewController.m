//
//  CheckCardViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardViewController.h"
#import "CheckDetailView.h"
#import "CheckCardCollectionCell.h"

@interface CheckCardViewController ()

@end

@implementation CheckCardViewController

- (void) loadView {
	[super loadView];
	
//	CheckDetailView *cv = [[CheckDetailView alloc] initWithFrame: CGRectMake(0, 50, 320, 200)];
//	[self.view addSubview: cv];
//
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	flowLayout.itemSize = self.contentFrame.size;
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.minimumLineSpacing = 0;
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: self.contentFrame
														  collectionViewLayout: flowLayout];
	collectionView.backgroundColor = [UIColor clearColor];
	collectionView.dataSource = self;
	collectionView.pagingEnabled = YES;
	[collectionView registerClass: [CheckCardCollectionCell class]
	   forCellWithReuseIdentifier: kCheckCardCollectionCellReusableId];
	[self.view addSubview: collectionView];
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DLog(@"New cell degueue");
	CheckCardCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCheckCardCollectionCellReusableId
																		   forIndexPath:indexPath];
	return newCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
