//
//  CheckPhotosViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckPhotosViewController.h"

#import "CheckHeaderView.h"
#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "UIButton+LGImages.h"
#import "UIImageView+LGImagesExtension.h"
#import "VotePanelView.h"
#import "PhotoCollectionCell.h"

#import "LGPhoto.h"

#define kPhotoCollectionCellReusableId @"PhotoCollectionCellId"
#define kCheckBarHeight 76
static NSString *const kObservationKeyPath = @"checkPhotos";

@interface CheckPhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
	CheckHeaderView __weak *_checkHeaderView;
	
	UIButton __weak *_winnerButton;
	UICollectionView __weak *_photosCollection;
}

@property (nonatomic, readonly) CGRect waitViewFrame;

@end

@implementation CheckPhotosViewController

#pragma mark - Properties

- (void) setCheck:(LGCheck *)check {
	if (_check != check) {
		_check = check;
		
		if (check != nil) {
			_checkHeaderView.titleLabel.text = check.name;
			[_checkHeaderView setDescriptionText: check.descr];
			[_checkHeaderView.simpleDetailView.imageView loadWebImageWithSizeThatFitsName: check.taskPhotoUrl placeholder: nil];
			[_winnerButton loadWebImageShadedWithSizeThatFitsName: check.winnerPhoto.url placeholder: nil];
			[_winnerButton setTitle: check.winnerPhoto.user.fio forState: UIControlStateNormal];
		}
	}
}

#pragma mark - Overrides

- (CGRect) waitViewFrame {
	CGRect frame = self.contentFrame;
	frame.origin.y += kCheckBarHeight;
	frame.size.height -= kCheckBarHeight;
	return frame;
}

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor colorWithRed: 235.0/255.0 green: 236.0/255.0 blue: 238.0/255.0
												alpha: 1.0];
	
	_titleBarView.titleLabel.text = @"CheckPhotosViewControllerTitle".commonLocalizedString;
	
	float offsetY = self.contentFrame.origin.y;
	
	CheckHeaderView *checkView = [[CheckHeaderView alloc] initWithFrame: CGRectMake(0, offsetY,
																				   self.view.frame.size.width,
																					kCheckBarHeight)];
	[checkView.simpleDetailView.imageView loadWebImageWithSizeThatFitsName: _check.taskPhotoUrl
															   placeholder: nil];
	checkView.titleLabel.text = _check.name;
	[checkView setDescriptionText: _check.descr];
	[self.view addSubview: checkView];
	_checkHeaderView = checkView;
	
	//Configuring scrollable area
	offsetY += checkView.frame.size.height;
	
	CGRect scrollFrame = CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height - offsetY);
	
	UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame: scrollFrame];
	contentScrollView.contentSize = CGSizeMake(scrollFrame.size.width * 2, scrollFrame.size.height);
	contentScrollView.pagingEnabled = YES;
	[self.view addSubview: contentScrollView];
	
	UIButton *winnerButton = [[UIButton alloc] initWithFrame: contentScrollView.bounds];
	[winnerButton loadWebImageShadedWithSizeThatFitsName: self.check.winnerPhoto.url placeholder: nil];
	[winnerButton addTarget: self action: @selector(winnerAction:) forControlEvents: UIControlEventTouchUpInside];
	winnerButton.titleEdgeInsets = UIEdgeInsetsMake(winnerButton.frame.size.height - 30, 0, 0, 0);
	winnerButton.titleLabel.font = [FontFactory fontWithType: FontTypeCheckPhotosWinnerTitle];
	[winnerButton setTitle: self.check.winnerPhoto.user.fio forState: UIControlStateNormal];
	[contentScrollView addSubview:winnerButton];
	_winnerButton = winnerButton;
	
	float capX = 8;
	CGRect photosCollectionFrame = contentScrollView.bounds;
	photosCollectionFrame.origin.x = photosCollectionFrame.size.width;
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.sectionInset = UIEdgeInsetsMake(capX, capX, 0, capX);
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	flowLayout.minimumInteritemSpacing = 2;
	flowLayout.minimumLineSpacing = 2;
	float itemSize = (photosCollectionFrame.size.width - flowLayout.minimumInteritemSpacing * 2 - capX * 2) / 3;
	flowLayout.itemSize = CGSizeMake(itemSize, itemSize);
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: photosCollectionFrame
														  collectionViewLayout: flowLayout];
	collectionView.backgroundColor = [UIColor clearColor];
	collectionView.dataSource = self;
	collectionView.delegate = self;
	[collectionView registerClass: [PhotoCollectionCell class]
	   forCellWithReuseIdentifier: kPhotoCollectionCellReusableId];
	[contentScrollView addSubview: collectionView];
	_photosCollection = collectionView;
	
	[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		[kernel.checksManager stopWaiting: self];
		[_photosCollection reloadData];
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	[kernel.checksManager getPhotosForCheck: self.check];
}

#pragma mark - Methods

- (void) winnerAction: (id) sender {
	[kernel.checksManager openViewControllerFor: self.check.winnerPhoto];
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [kernel.storage.checkPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	PhotoCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kPhotoCollectionCellReusableId
																			 forIndexPath:indexPath];
	
	LGPhoto *photo = kernel.storage.checkPhotos[indexPath.row];
	newCell.photo = photo;
	return newCell;
}

#pragma mark - UICollectionViewDelegate implementation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	LGPhoto *photo = kernel.storage.checkPhotos[indexPath.row];
	[kernel.checksManager openViewControllerFor: photo];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	//	DLog(@"Cell removed for index: %ld", (long)indexPath.row);
}

@end
