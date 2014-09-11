//
//  CheckCardCollectionCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailView.h"

extern NSString *const kCheckCardCollectionCellReusableId;

@interface CheckCardCollectionCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, assign) UIImage *mainImage;
@property (nonatomic, assign) UIImage *secondImage;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailTextLabel;
@property (nonatomic, assign) CheckDetailType type;

@end
