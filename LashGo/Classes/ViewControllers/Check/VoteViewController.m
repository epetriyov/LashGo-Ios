//
//  VoteViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VoteViewController.h"

#import "CheckHeaderView.h"
#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "UIImageView+LGImagesExtension.h"
#import "VoteCollectionCell.h"

#define kCheckBarHeight 76
#define kVotePhotoItemsPerPage 4

static NSString *const kObservationKeyPath = @"checkVotePhotos";
static NSString *const kVoteCollectionCellReusableId = @"VoteCollectionCellReusableId";

@interface VoteViewController () <UICollectionViewDataSource, UICollectionViewDelegate, VotePanelViewDelegate> {
	CheckHeaderView __weak *_checkHeaderView;
	
	NSTimer *_progressTimer;
	
	UICollectionView __weak *_photosCollection;
	
	UILabel __weak *_pagerLabel;
}

@property (nonatomic, readonly) CGRect waitViewFrame;

@end

@implementation VoteViewController

#pragma mark - Properties

- (void) setCheck:(LGCheck *)check {
	if (_check != check) {
		_check = check;
		
		if (check != nil) {
			_checkHeaderView.titleLabel.text = check.name;
			[_checkHeaderView setDescriptionText: check.descr];
			[_checkHeaderView.simpleDetailView.imageView loadWebImageWithSizeThatFitsName: check.taskPhotoUrl
																			  placeholder: nil];
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

- (instancetype) initWithKernel:(Kernel *)theKernel {
	if (self = [super initWithKernel: theKernel]) {
		[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor colorWithRed: 235.0/255.0 green: 236.0/255.0 blue: 238.0/255.0
												alpha: 1.0];
	
	_titleBarView.titleLabel.text = @"VoteViewControllerTitle".commonLocalizedString;
	
	float offsetY = self.contentFrame.origin.y;
	
	CheckHeaderView *checkView = [[CheckHeaderView alloc] initWithFrame: CGRectMake(0, offsetY,
																					self.view.frame.size.width,
																					kCheckBarHeight)];
	checkView.titleLabel.text = _check.name;
	[checkView setDescriptionText: _check.descr];
	checkView.simpleDetailView.type = CheckDetailTypeVote;
	[checkView.simpleDetailView.imageView loadWebImageWithSizeThatFitsName: _check.taskPhotoUrl
															   placeholder: nil];
	[self.view addSubview: checkView];
	_checkHeaderView = checkView;
	
	offsetY += checkView.frame.size.height;
	
	//Configure pager label
	float pagerLabelHeight = 30;
	UILabel *pagerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0,
																	 self.view.frame.size.height - pagerLabelHeight - 8,
																	 self.view.frame.size.width,
																	 pagerLabelHeight)];
	pagerLabel.font = [FontFactory fontWithType: FontTypeVotePager];
	pagerLabel.textAlignment = NSTextAlignmentCenter;
	pagerLabel.textColor = [FontFactory fontColorForType: FontTypeVotePager];
	pagerLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview: pagerLabel];
	_pagerLabel = pagerLabel;
	
	CGRect photosCollectionFrame = CGRectMake(0, offsetY,
											  self.view.frame.size.width,
											  _pagerLabel.frame.origin.y - offsetY);
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	flowLayout.itemSize = photosCollectionFrame.size;
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.minimumLineSpacing = 0;
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: photosCollectionFrame
														  collectionViewLayout: flowLayout];
	collectionView.backgroundColor = [UIColor clearColor];
	collectionView.dataSource = self;
	collectionView.delegate = self;
	collectionView.pagingEnabled = YES;
//	collectionView.scrollEnabled = NO;
	[collectionView registerClass: [VoteCollectionCell class]
	   forCellWithReuseIdentifier: kVoteCollectionCellReusableId];
	[self.view addSubview: collectionView];
	
	_photosCollection = collectionView;
	
	[kernel.checksManager getVotePhotosForCheck: self.check];
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		[kernel.checksManager stopWaitingVotePhotos];
		[self refreshPhotos];
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	if ([_progressTimer isValid] == NO) {
		_progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(refresh)
														userInfo:nil repeats:YES];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	[_progressTimer invalidate];
}

#pragma mark - Methods

- (void) voteFinished {
	[_photosCollection reloadData];
	[kernel.checksManager stopWaitingVotePhotos];
//	_votePanelView.type = VotePanelTypeNext;
}

- (void) refresh {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	if (now > _check.closeDate) {
		_checkHeaderView.simpleDetailView.type = CheckDetailTypeClosed;
	}
	
	if (_checkHeaderView.simpleDetailView.type == CheckDetailTypeVote) {
		[_checkHeaderView setTimeLeft: fdim(_check.closeDate, now)];
	}
}

- (void) refreshPagerWith: (NSUInteger) pageIndex {
	//So one cell per page we can get index by visible
	NSUInteger count = [kernel.storage.checkVotePhotos.votePhotos count];
	NSUInteger beginNumber = pageIndex * kVotePhotoItemsPerPage + 1;
	NSUInteger endNumber = MIN(beginNumber + (kVotePhotoItemsPerPage - 1), count);
	_pagerLabel.text = [NSString stringWithFormat: @"PagerLabelFormat".commonLocalizedString,
						beginNumber, endNumber, count];
}

- (void) refreshPhotos {
	[_photosCollection reloadData];
    _photosCollection.scrollEnabled = YES;
    
    NSUInteger pageIndexToScroll = 0;
    for (NSUInteger i = 0; i < [kernel.storage.checkVotePhotos.votePhotos count]; i += kVotePhotoItemsPerPage) {
        LGVotePhoto *votePhoto = kernel.storage.checkVotePhotos.votePhotos[i];
        if (votePhoto.isShown == NO) {
            pageIndexToScroll = i / kVotePhotoItemsPerPage;
            _photosCollection.scrollEnabled = NO;
            break;
        }
    }
    [_photosCollection scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: pageIndexToScroll inSection: 0]
                              atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated: NO];
	[self refreshPagerWith: pageIndexToScroll];
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return ceil(((double)[kernel.storage.checkVotePhotos.votePhotos count]) / kVotePhotoItemsPerPage);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	//	DLog(@"New cell degueue for index: %ld", (long)indexPath.row);
	VoteCollectionCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier: kVoteCollectionCellReusableId
																				 forIndexPath:indexPath];
	newCell.delegate = self;
	
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity: 1];
	
	NSUInteger beginIndex = indexPath.row * kVotePhotoItemsPerPage;
	NSUInteger nextBeginIndex = MIN(beginIndex + kVotePhotoItemsPerPage,
							  [kernel.storage.checkVotePhotos.votePhotos count]);
	for (NSUInteger i = beginIndex; i < nextBeginIndex; ++i) {
		[items addObject: kernel.storage.checkVotePhotos.votePhotos[i]];
	}
	
	[newCell refreshWithVotePhotos: items];
	return newCell;
}

#pragma mark - UICollectionViewDelegate implementation

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	//So one cell per page we can get index by visible
	NSIndexPath *pageIndex = [[_photosCollection indexPathsForVisibleItems] firstObject];
	if (pageIndex != nil) {
		[self refreshPagerWith: pageIndex.row];
	}
}

#pragma mark - VotePanelViewDelegate implementation

- (void) voteWithIndex: (ushort) index {
	//So one cell per page we can get index by visible
	NSIndexPath *pageIndex = [[_photosCollection indexPathsForVisibleItems] firstObject];
	if (pageIndex != nil) {
		LGVoteAction *voteAction = [[LGVoteAction alloc] init];
		
		NSUInteger beginIndex = pageIndex.row * kVotePhotoItemsPerPage;
		NSUInteger nextBeginIndex = MIN(beginIndex + kVotePhotoItemsPerPage,
										[kernel.storage.checkVotePhotos.votePhotos count]);
		
		NSMutableArray *votePhotos = [[NSMutableArray alloc] initWithCapacity: 1];
		for (ushort i = 0; i < nextBeginIndex - beginIndex; ++i) {
			LGVotePhoto *votePhoto = kernel.storage.checkVotePhotos.votePhotos[pageIndex.row * kVotePhotoItemsPerPage + i];
			[votePhotos addObject: votePhoto];
			if (i == index) {
				voteAction.votedPhotoUID = votePhoto.photo.uid;
			}
		}
		
		voteAction.votePhotos = votePhotos;
		voteAction.checkUID = self.check.uid;
		
		[kernel.checksManager voteWith: voteAction];
	}
}

- (void) openPhotoWithIndex:(ushort)index {
	//So one cell per page we can get index by visible
	NSIndexPath *pageIndex = [[_photosCollection indexPathsForVisibleItems] firstObject];
	if (pageIndex != nil) {
		LGVotePhoto *votePhoto = kernel.storage.checkVotePhotos.votePhotos[pageIndex.row * kVotePhotoItemsPerPage + index];
		[kernel.checksManager openViewControllerFor: votePhoto.photo];
	}
}

- (void) openNext {
	//So one cell per page we can get index by visible
	NSIndexPath *pageIndex = [[_photosCollection indexPathsForVisibleItems] firstObject];
	if (pageIndex != nil && pageIndex.row + 1 < [_photosCollection numberOfItemsInSection: 0]) {
		NSIndexPath *nextPageIndex = [NSIndexPath indexPathForRow: pageIndex.row + 1 inSection: 0];
		[_photosCollection scrollToItemAtIndexPath: nextPageIndex
								  atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally
										  animated: YES];
	} else {
		_photosCollection.scrollEnabled = YES;
	}
}

@end
