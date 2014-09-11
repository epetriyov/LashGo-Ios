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

#import "Common.h"

#import "Kernel.h"

#import "LGCheck.h"
#import "ViewFactory.h"

@interface CheckCardViewController () {
	UICollectionView __weak *_collectionView;
}

@end

@implementation CheckCardViewController

- (void) loadView {
	[super loadView];
	
	[_titleBarView removeFromSuperview];
	UIButton *listButton = [[ViewFactory sharedFactory] titleBarCheckListButtonWithTarget: self
																				   action: @selector(switchToListAction:)];
	UIButton *searchButton = [[ViewFactory sharedFactory] titleBarRightSearchButtonWithTarget: self
																					   action: @selector(openSearchAction:)];
	UIButton *incomeButton = [[ViewFactory sharedFactory] titleBarRightIncomeButtonWithTarget: self
																					   action: @selector(openIncomeAction:)];
	TitleBarView *tbView = [TitleBarView titleBarViewWithLeftButton: listButton
												 rightButton: incomeButton
												searchButton: searchButton];
	tbView.titleLabel.text = @"ChecksTitle".commonLocalizedString;
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
	gradientLayer.frame = self.contentFrame;
	gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:61.0/255.0
														  green:66.0/255.0
														   blue:90.0/255.0 alpha:1.0].CGColor,
							 (__bridge id)[UIColor colorWithRed:24.0/255.0
														  green:28.0/255.0
														   blue:34.0/255.0 alpha:1.0].CGColor];
//		gradientLayer.startPoint = CGPointMake(0,0.5);
//		gradientLayer.endPoint = CGPointMake(1,0.5);
	[self.view.layer insertSublayer: gradientLayer atIndex: 0];
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	flowLayout.itemSize = self.contentFrame.size;
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.minimumLineSpacing = 0;
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: self.contentFrame
														  collectionViewLayout: flowLayout];
	collectionView.backgroundColor = [UIColor clearColor];
	collectionView.dataSource = self;
	collectionView.delegate = self;
	collectionView.pagingEnabled = YES;
	[collectionView registerClass: [CheckCardCollectionCell class]
	   forCellWithReuseIdentifier: kCheckCardCollectionCellReusableId];
	[self.view addSubview: collectionView];
	
	_collectionView = collectionView;
}

#pragma mark - Methods

- (void) refresh {
	[_collectionView reloadData];
}

- (void) switchToListAction: (id) sender {
	[kernel.checksManager openCheckListViewController];
}

- (void) openSearchAction: (id) sender {
	[kernel.viewControllersManager openSearchViewController];
}

- (void) openIncomeAction: (id) sender {
	
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [kernel.storage.checks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DLog(@"New cell degueue for index: %ld", (long)indexPath.row);
	CheckCardCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCheckCardCollectionCellReusableId
																		   forIndexPath:indexPath];
	LGCheck *check = kernel.storage.checks[indexPath.row];
	newCell.textLabel.text = check.name;
	newCell.detailTextLabel.text = check.descr;
	
	NSString *pathForResource = [[NSBundle mainBundle] pathForResource: @"DemoImage" ofType: @"jpg"];

	UIImage *image = [[UIImage alloc] initWithContentsOfFile: pathForResource];
	
	newCell.mainImage = image;
	newCell.secondImage = image;

	if (indexPath.row == 1) {
		newCell.type = CheckDetailTypeVote;
	} else {
		newCell.type = CheckDetailTypeOpen;
	}
	return newCell;
}

#pragma mark - UICollectionViewDelegate implementation

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	DLog(@"Cell removed for index: %ld", (long)indexPath.row);
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
