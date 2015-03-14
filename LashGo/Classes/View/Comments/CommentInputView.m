//
//  CommentInputView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "CommentInputView.h"

#import "Common.h"
#import "FontFactory.h"

@interface CommentInputView () <UITextFieldDelegate>

@end

@implementation CommentInputView

- (instancetype) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame: frame]) {
		self.backgroundColor = [UIColor colorWithWhite: 247.0/255.0 alpha: 1.0];
		
		float buttonWidth = 86;
		_actionButton = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.bounds) - buttonWidth,
																	0, buttonWidth, CGRectGetHeight(self.bounds))];
		_actionButton.enabled = NO;
		_actionButton.titleLabel.font = [FontFactory fontWithType: FontTypeCommentsInputBtn];
		[_actionButton setTitleColor: [FontFactory fontColorForType: FontTypeCommentsInputBtn]
							forState: UIControlStateNormal];
		[_actionButton setTitle: @"CommentsVCInputBtnTitle".commonLocalizedString forState: UIControlStateNormal];
		[self addSubview: _actionButton];
		
		float gaps = 7;
		
		_textField = [[UITextField alloc] initWithFrame: CGRectMake(gaps, gaps,
																	CGRectGetWidth(self.bounds) - buttonWidth - gaps,
																	CGRectGetHeight(self.bounds) - gaps * 2)];
		_textField.delegate = self;
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.font = [FontFactory fontWithType: FontTypeCommentsInputField];
		_textField.textColor = [FontFactory fontColorForType: FontTypeCommentsInputField];
		_textField.layer.cornerRadius = 4;
		_textField.placeholder = @"CommentsVCInputPlaceholder".commonLocalizedString;
		[self addSubview: _textField];
	}
	return self;
}

#pragma mark - UITextFieldDelegate implementation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
	NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
	self.actionButton.enabled = [Common isEmptyString: str] == NO;
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
