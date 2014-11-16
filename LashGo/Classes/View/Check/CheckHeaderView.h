//
//  CheckHeaderView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 16.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckSimpleDetailView.h"

@interface CheckHeaderView : UIView

@property (nonatomic, readonly) CheckSimpleDetailView *simpleDetailView;
@property (nonatomic, readonly) UILabel *titleLabel;

- (void) setDescriptionText: (NSString *) text;
- (void) setTimeLeft:(NSTimeInterval)timeLeft;

@end
