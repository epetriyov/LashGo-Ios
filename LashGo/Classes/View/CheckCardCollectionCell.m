//
//  CheckCardCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardCollectionCell.h"
#import "CheckDetailView.h"

NSString *const kCheckCardCollectionCellReusableId = @"kCheckCardCollectionCellReusableId";

@implementation CheckCardCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		CheckDetailView *cv = [[CheckDetailView alloc] initWithFrame: self.contentView.bounds];
		cv.backgroundColor = [UIColor blueColor];
		[self.contentView addSubview: cv];
    }
    return self;
}

- (NSString *) reuseIdentifier {
	return kCheckCardCollectionCellReusableId;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
