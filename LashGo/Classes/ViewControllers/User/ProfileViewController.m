//
//  ProfileViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileViewController.h"

#import "Kernel.h"
#import "PhotoCollectionCell.h"
#import "ProfileView.h"

#define kPhotoCollectionCellReusableId @"PhotoCollectionCellId"

static NSString *const kObservationKeyPath = @"lastViewProfileDetail";

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
	ProfileView __weak *_profileView;
	UICollectionView __weak *_photosCollection;
}

@end

@implementation ProfileViewController

- (void) setPhotos:(NSArray *)photos {
	_photos = photos;
	[_photosCollection reloadData];
	[kernel.userManager stopWaitingUserPhotos];
}

#pragma mark - Overrides

- (CGRect) waitViewFrame {
	return _photosCollection.frame;
}

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_titleBarView.backgroundColor = [UIColor clearColor];
	
	ProfileView *profileView = [[ProfileView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 100)];
	[profileView setUserData: self.user];
	[self.view insertSubview:profileView belowSubview: _titleBarView];
	_profileView = profileView;
	
	float capX = 8;
	float offsetY = _profileView.frame.size.height;
	
	CGRect photosCollectionFrame = CGRectMake(0, offsetY,
											  self.view.frame.size.width, self.view.frame.size.height - offsetY);
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.sectionInset = UIEdgeInsetsMake(capX, capX, 0, capX);
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	flowLayout.minimumInteritemSpacing = 2;
	flowLayout.minimumLineSpacing = 2;
	float itemSize = (photosCollectionFrame.size.width  - flowLayout.minimumInteritemSpacing - capX * 2) / 2;
	flowLayout.itemSize = CGSizeMake(itemSize, itemSize);
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: photosCollectionFrame
														  collectionViewLayout: flowLayout];
	collectionView.backgroundColor = [UIColor clearColor];
	collectionView.dataSource = self;
	collectionView.delegate = self;
	[collectionView registerClass: [PhotoCollectionCell class]
	   forCellWithReuseIdentifier: kPhotoCollectionCellReusableId];
	[self.view addSubview: collectionView];
	
	_photosCollection = collectionView;
	
	[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
}

- (void) viewWillAppear:(BOOL)animated {
	[kernel.userManager getUserPhotosForUser: self.user];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		if (self.user.uid == ((Storage *)object).lastViewProfileDetail.uid) {
			[_profileView setUserData:((Storage *)object).lastViewProfileDetail];
		}
	}
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	//	DLog(@"New cell degueue for index: %ld", (long)indexPath.row);
	PhotoCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kPhotoCollectionCellReusableId
																				 forIndexPath:indexPath];
	
	LGPhoto *photo = self.photos[indexPath.row];
	newCell.photo = photo;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	LGPhoto *photo = self.photos[indexPath.row];
	[kernel.checksManager openViewControllerFor: photo];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	//	DLog(@"Cell removed for index: %ld", (long)indexPath.row);
}

@end
