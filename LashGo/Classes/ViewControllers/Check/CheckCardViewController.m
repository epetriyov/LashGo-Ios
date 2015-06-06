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

@interface CheckCardViewController () <CheckCardCollectionCellDelegate> {
	UICollectionView __weak *_collectionView;
	
	NSTimer *_progressTimer;
}

@end

@implementation CheckCardViewController

- (TaskbarContentType) taskbarContentType {
	return TaskbarContentTypeDark;
}

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
												 rightButton: searchButton
												searchButton: incomeButton];
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

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	if (self.indexToShowOnAppear != nil) {
		[_collectionView scrollToItemAtIndexPath: self.indexToShowOnAppear
								atScrollPosition: UICollectionViewScrollPositionCenteredVertically animated: NO];
		self.indexToShowOnAppear = nil;
	}
	
	
	if ([_progressTimer isValid] == NO) {
		_progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(refreshVisiblePage)
														userInfo:nil repeats:YES];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	[_progressTimer invalidate];
}

#pragma mark - Methods

- (void) refreshVisiblePage {
	for (CheckCardCollectionCell *cell in _collectionView.visibleCells) {
		[cell refresh];
		DLog(@"cell refreshed");
	}
}

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
//	[kernel.userManager openProfileEditViewControllerWith: nil];
//	[kernel.userManager openProfileWelcomeViewControllerWith: nil];
	[kernel.checksManager openCheckActionListViewController];
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
//	DLog(@"New cell degueue for index: %ld", (long)indexPath.row);
	CheckCardCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kCheckCardCollectionCellReusableId
																		   forIndexPath:indexPath];
	newCell.delegate = self;
	
	LGCheck *check = kernel.storage.checks[indexPath.row];
	newCell.check = check;
//	newCell.textLabel.text = check.name;
//	newCell.detailTextLabel.text = check.descr;
	
//	NSString *pathForResource = [[NSBundle mainBundle] pathForResource: @"DemoImage" ofType: @"jpg"];
//
//	UIImage *image = [[UIImage alloc] initWithContentsOfFile: pathForResource];
//
//	newCell.mainImage = image;
//	newCell.secondImage = image;
	return newCell;
}

#pragma mark - UICollectionViewDelegate implementation

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//	DLog(@"Cell removed for index: %ld", (long)indexPath.row);
}

#pragma mark - CheckCardCollectionCellDelegate implementation

- (void) actionWithCheck:(LGCheck *)check forEvent:(CheckCardCollectionCellEvents)event {
	switch (event) {
		case CheckCardCollectionCellEventOpenImage:
			[kernel.checksManager openCheckDetailViewControllerAdminFor: check];
			break;
		case CheckCardCollectionCellEventOpenUserImage:
			[kernel.checksManager openCheckDetailViewControllerUserFor: check];
			break;
		case CheckCardCollectionCellEventOpenUsers:
			[kernel.checksManager openCheckUsersViewControllerForCheck: check];
			break;
		case CheckCardCollectionCellEventOpenWinnerImage:
			[kernel.checksManager openCheckPhotosViewControllerForCheck: check];
			break;
		case CheckCardCollectionCellEventPickPhoto:
			[kernel.imagePickManager takePictureFor: check];
			break;
		case CheckCardCollectionCellEventSendUserImage:
			[kernel.checksManager addPhotoForCheck: check];
			break;
		case CheckCardCollectionCellEventVote:
			[kernel.checksManager openVoteViewControllerForCheck: check];
			break;
		default:
			break;
	}
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
