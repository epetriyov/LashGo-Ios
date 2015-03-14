//
//  CommentsTableView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "CommentsTableView.h"

@interface CommentsTableView ()

// Override inputAccessoryView to readWrite
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;

@end

@implementation CommentsTableView

- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	if (self = [super initWithFrame:frame style: style]) {
		self.tableFooterView = [[UIView alloc] init];
		self.rowHeight = 60;
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		CGRect screenBounds = [[UIScreen mainScreen] bounds];
		CGRect frame = CGRectMake(0,0, CGRectGetWidth(screenBounds), 44);
		_inputAccessoryView = [[CommentInputView alloc] initWithFrame: frame];
	}
	return self;
}

// Override canBecomeFirstResponder
// to allow this view to be a responder
- (BOOL) canBecomeFirstResponder {
	return YES;
}

// Override inputAccessoryView to use
// an instance of KeyboardBar
- (UIView *)inputAccessoryView {
	return _inputAccessoryView;
}

@end
