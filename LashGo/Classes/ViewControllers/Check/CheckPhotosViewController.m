//
//  CheckPhotosViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckPhotosViewController.h"

#import "CheckSimpleDetailView.h"
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
	CheckSimpleDetailView __weak *_checkView;
	UILabel __weak *_checkTitleLabel;
	UILabel __weak *_checkDescriptionLabel;
	
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
			_checkTitleLabel.text = check.name;
			_checkDescriptionLabel.text = check.descr;
			[_checkView.imageView loadWebImageWithSizeThatFitsName: check.taskPhotoUrl placeholder: nil];
			[_winnerButton loadWebImageWithSizeThatFitsName: check.winnerPhoto.url placeholder: nil];
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
	
	UIView *checkDetailsView = [[UIView alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width,
																		 kCheckBarHeight)];
	checkDetailsView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview: checkDetailsView];
	
	float checkViewOffsetX = 10;
	float checkViewOffsetY = 7;
	
	CheckSimpleDetailView *checkView = [[CheckSimpleDetailView alloc] initWithFrame: CGRectMake(checkViewOffsetX,
																								checkViewOffsetY,
																								44, 44)
																		  imageCaps: 4 progressLineWidth: 2];
	[checkView.imageView loadWebImageWithSizeThatFitsName: _check.taskPhotoUrl placeholder: nil];
	[checkDetailsView addSubview: checkView];
	_checkView = checkView;
	
	checkViewOffsetX += checkView.frame.size.width + 11;
	
	UILabel *checkTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewOffsetY,
																		  checkDetailsView.frame.size.width - checkViewOffsetX, 15)];
	checkTitleLabel.font = [FontFactory fontWithType: FontTypeVoteCheckTitle];
	checkTitleLabel.textColor = [FontFactory fontColorForType: FontTypeVoteCheckTitle];
	checkTitleLabel.text = _check.name;
	[checkDetailsView addSubview: checkTitleLabel];
	_checkTitleLabel = checkTitleLabel;
	
	checkViewOffsetY += checkTitleLabel.frame.size.height + 3;
	
	UILabel *checkDescriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewOffsetY,
																				checkTitleLabel.frame.size.width,
																				checkDetailsView.frame.size.height - checkViewOffsetY)];
	checkDescriptionLabel.font = [FontFactory fontWithType: FontTypeVoteCheckDescription];
	checkDescriptionLabel.textColor = [FontFactory fontColorForType: FontTypeVoteCheckDescription];
	checkDescriptionLabel.numberOfLines = 3;
	checkDescriptionLabel.text = _check.descr;
	[checkDescriptionLabel sizeToFit];
	[checkDetailsView addSubview: checkDescriptionLabel];
	_checkDescriptionLabel = checkDescriptionLabel;
	
	//Configuring scrollable area
	offsetY += checkDetailsView.frame.size.height;
	
	CGRect scrollFrame = CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height - offsetY);
	
	UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame: scrollFrame];
	contentScrollView.contentSize = CGSizeMake(scrollFrame.size.width * 2, scrollFrame.size.height);
	contentScrollView.pagingEnabled = YES;
	[self.view addSubview: contentScrollView];
	
	UIButton *winnerButton = [[UIButton alloc] initWithFrame: contentScrollView.bounds];
	[winnerButton loadWebImageWithSizeThatFitsName: self.check.winnerPhoto.url placeholder: nil];
	[winnerButton addTarget: self action: @selector(winnerAction:) forControlEvents: UIControlEventTouchUpInside];
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
