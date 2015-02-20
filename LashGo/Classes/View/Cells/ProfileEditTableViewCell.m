//
//  ProfileEditTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileEditTableViewCell.h"

@interface ProfileEditTableViewCell () <UITextFieldDelegate> {
	UITextField __weak *_field;
	ProfileEditFieldData __weak *_fieldData;
}

@end

@implementation ProfileEditTableViewCell

- (void) setFieldData:(ProfileEditFieldData *)fieldData {
	_fieldData = fieldData;
	
	_field.placeholder = fieldData.title;
	_field.text = fieldData.value;
	self.imageView.image = fieldData.image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
		float fieldOffsetX = 56;
		CGRect fieldRect = CGRectMake(fieldOffsetX, 0,
									  CGRectGetWidth(self.contentView.bounds) - fieldOffsetX,
									  CGRectGetHeight(self.contentView.bounds));
		
		UITextField *field = [[UITextField alloc] initWithFrame: fieldRect];
		field.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		field.delegate = self;
		[self.contentView addSubview: field];
		_field = field;
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

#pragma mark - UITextFieldDelegate implementation

//- (BOOL) textFieldShouldReturn:(UITextField *)textField {
//	return YES;
//}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	[self.delegate tableCellDidBeginEditing: self];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	self.fieldData.value = _field.text;
	[self.delegate tableCellDidEndEditing: self];
}

@end
