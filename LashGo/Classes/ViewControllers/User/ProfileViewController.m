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
#import "ViewFactory.h"

#define kPhotoCollectionCellReusableId @"PhotoCollectionCellId"

#define kObservationFollowStatusKeyPath @"subscription"
static NSString *const kObservationKeyPath = @"lastViewProfileDetail";

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
	ProfileView __weak *_profileView;
	UICollectionView __weak *_photosCollection;
	UIButton __weak *_editButton;
	UIButton __weak *_followButton;
}

@end

@implementation ProfileViewController

- (void) setPhotos:(NSArray *)photos {
	_photos = photos;
	[_photosCollection reloadData];
	[kernel.userManager stopWaitingUserPhotos];
}

- (void) setUser:(LGUser *)user {
	int32_t currentAccountUID = [AuthorizationManager sharedManager].account.userInfo.uid;
	int32_t oldAccountUID = _user.uid;
	int32_t newAccountUID = user.uid;
	[_user removeObserver: self forKeyPath: kObservationFollowStatusKeyPath];
	_user = user;
	[_user addObserver: self forKeyPath: kObservationFollowStatusKeyPath options: 0 context: NULL];
	
	if (self.isViewLoaded == YES &&
		((newAccountUID == currentAccountUID &&
		oldAccountUID != currentAccountUID) ||
		(newAccountUID != currentAccountUID &&
		 oldAccountUID == currentAccountUID))) {
			[self refreshTitleBar];
	}
}

- (void) refreshTitleBar {
	[_titleBarView removeFromSuperview];
	
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity: 1];
	if (self.user.uid == [AuthorizationManager sharedManager].account.userInfo.uid) {
		UIButton *editButton = [[ViewFactory sharedFactory] userEditButtonWithTarget: self
																			  action: @selector(editAction:)];
		editButton.hidden = YES;
		[buttons addObject: editButton];
		_editButton = editButton;
	} else {
		UIButton *followButton = [[ViewFactory sharedFactory] userFollowWhiteButtonWithTarget: self
																					   action: @selector(followAction:)];
		[buttons addObject: followButton];
		_followButton = followButton;
	}
	
	TitleBarView *tbView = [TitleBarView titleBarViewWithRightButtons: buttons];
	tbView.backgroundColor = [UIColor clearColor];
	[tbView.backButton addTarget: self action: @selector(backAction:)
				forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
}

#pragma mark - Overrides

- (CGRect) waitViewFrame {
	return _photosCollection.frame;
}

- (instancetype) initWithKernel:(Kernel *)theKernel {
	if (self = [super initWithKernel: theKernel]) {
		[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self refreshTitleBar];
	
	ProfileView *profileView = [[ProfileView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 100)];
	[profileView setUserData: self.user];
	[profileView.subscribersButton addTarget: self action: @selector(subscribersAction:)
							forControlEvents: UIControlEventTouchUpInside];
	[profileView.subscriptionsButton addTarget: self action: @selector(subscriptionsAction:)
							  forControlEvents: UIControlEventTouchUpInside];
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
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	_followButton.hidden = YES;
	[kernel.userManager getUserPhotosForUser: self.user];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		LGUser *profileDetail = ((Storage *)object).lastViewProfileDetail;
		
		if (self.user.uid == profileDetail.uid) {
			[_profileView setUserData: profileDetail];
			self.user.subscription = profileDetail.subscription;
//			_followButton.hidden = NO;
//			_editButton.enabled = YES;
			_titleBarView.rightButton.hidden = NO;
		}
	} else if ([keyPath isEqualToString: kObservationFollowStatusKeyPath] == YES && object == self.user) {
		_followButton.selected = ((LGUser *)object).subscription;
	}
}

- (void) dealloc {
	if (_user != nil) {
		[_user removeObserver: self forKeyPath: kObservationFollowStatusKeyPath];
	}
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

#pragma mark -

- (void) editAction: (id) sender {
	LGUser *profileForEdit = kernel.storage.lastViewProfileDetail;
	
	if (self.user.uid != profileForEdit.uid) {
		profileForEdit = self.user;
	}
	[kernel.userManager openProfileEditViewControllerWith: profileForEdit];
}

- (void) followAction: (id) sender {
	if (self.user.subscription == YES) {
		[kernel.userManager unsubscribeFromUser: self.user];
	} else {
		[kernel.userManager subscribeToUser: self.user];
	}
}

- (void) subscribersAction: (id) sender {
	[kernel.userManager openSubscribersWith: self.user];
}

- (void) subscriptionsAction: (id) sender {
	[kernel.userManager openSubscribtionsWith: self.user];
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
