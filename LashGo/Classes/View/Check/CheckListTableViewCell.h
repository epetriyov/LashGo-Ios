//
//  CheckListTableViewCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckSimpleDetailView.h"

@interface CheckListTableViewCell : UITableViewCell

@property (nonatomic, readonly) CheckSimpleDetailView *checkView;

- (void) setTimeLeft:(NSTimeInterval)timeLeft;

+ (CGFloat) height;

@end
