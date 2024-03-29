//
//  CheckCardCollectionCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailView.h"
#import "LGCheck.h"

extern NSString *const kCheckCardCollectionCellReusableId;

typedef NS_ENUM(ushort, CheckCardCollectionCellEvents) {
	CheckCardCollectionCellEventGetPrize,
	CheckCardCollectionCellEventOpenImage,
	CheckCardCollectionCellEventOpenUserImage,
	CheckCardCollectionCellEventOpenUsers,
	CheckCardCollectionCellEventOpenWinnerImage,
	CheckCardCollectionCellEventPickPhoto,
	CheckCardCollectionCellEventSendUserImage,
	CheckCardCollectionCellEventVote
};

@protocol CheckCardCollectionCellDelegate;

@interface CheckCardCollectionCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, weak) id<CheckCardCollectionCellDelegate> delegate;

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailTextLabel;
@property (nonatomic, assign) CheckDetailType type;

@property (nonatomic, strong) LGCheck *check;

- (void) refresh;

@end

@protocol CheckCardCollectionCellDelegate <NSObject>

@required
- (void) actionWithCheck: (LGCheck *) check forEvent: (CheckCardCollectionCellEvents) event;

@end
