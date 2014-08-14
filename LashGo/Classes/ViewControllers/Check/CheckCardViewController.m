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
	_titleBarView = [TitleBarView titleBarViewWithLeftButton: listButton
												 rightButton: incomeButton
												searchButton: searchButton];
	_titleBarView.titleLabel.text = @"ChecksTitle".commonLocalizedString;
	[self.view addSubview: _titleBarView];
	
	self.view.backgroundColor = [UIColor colorWithRed: 0.16 green: 0.18 blue: 0.23 alpha:1.0];
	
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
	DLog(@"New cell degueue");
	CheckCardCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCheckCardCollectionCellReusableId
																		   forIndexPath:indexPath];
	LGCheck *check = kernel.storage.checks[indexPath.row];
	newCell.textLabel.text = check.name;
	newCell.detailTextLabel.text = check.descr;
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
