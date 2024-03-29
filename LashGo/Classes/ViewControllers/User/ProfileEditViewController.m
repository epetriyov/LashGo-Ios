//
//  ProfileEditViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileEditViewController.h"

#import "Common.h"
#import "Kernel.h"
#import "NSObject+KeyboardManagement.h"
#import "UIColor+CustomColors.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

#import "ProfileEditTableViewCell.h"

typedef NS_ENUM(ushort, ProfileEditFieldDataType) {
	ProfileEditFieldDataTypeName,
	ProfileEditFieldDataTypeLocation,
	ProfileEditFieldDataTypeEmail,
	ProfileEditFieldDataTypeAbout,
	ProfileEditFieldDataTypePassword
};

@interface ProfileEditViewController () <UITableViewDataSource, ProfileEditTableViewCellDelegate> {
	UIImageView *_avatarImageView;
	NSArray *_contentItems;
	UIView __weak *_activeResponder;
	
	UITableView __weak *_contentTableView;
	
	UIImage *_image;
}

@end

@implementation ProfileEditViewController

- (UIScrollView *) contentScrollView {
	return _contentTableView;
}

- (UIView *) activeFirstResponder {
	return _activeResponder;
}

- (CGRect) waitViewFrame {
	return self.view.frame;
}

- (void) loadView {
	[super loadView];
	
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	[_titleBarView removeFromSuperview];
	TitleBarView *tbView = [TitleBarView titleBarViewWithRightButtonWithText: @"TitleBarRightSaveBtnText".commonLocalizedString];
	tbView.backgroundColor = [UIColor clearColor];
	[tbView.backButton addTarget: self action: @selector(backAction:)
				 forControlEvents: UIControlEventTouchUpInside];
	[tbView.rightButton addTarget: self action: @selector(saveAction:)
				 forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	_avatarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 240)];
	_avatarImageView.backgroundColor = [UIColor colorWithAppColorType: AppColorTypeTint];
	_avatarImageView.contentMode = UIViewContentModeBottom;
	_avatarImageView.userInteractionEnabled = YES;
	[_avatarImageView loadWebImageWithSizeThatFitsName: self.user.avatar
										   placeholder: [ViewFactory sharedFactory].userProfileAvatarPlaceholder];
	
	float changeAvatarButtonHeight = 48;
	CGRect changeAvatarButtonRect = _avatarImageView.bounds;
	changeAvatarButtonRect.origin.y = changeAvatarButtonRect.size.height - changeAvatarButtonHeight;
	changeAvatarButtonRect.size.height = changeAvatarButtonHeight;
	
	UIButton *changeAvatarButton = [[ViewFactory sharedFactory] userChangeAvatarButtonWithTarget: self
																						  action: @selector(changeAvatarAction:)];
	changeAvatarButton.frame = changeAvatarButtonRect;
	[_avatarImageView addSubview: changeAvatarButton];
	
	//TableDataModel configuration
	ProfileEditFieldData *nameFieldData = [[ProfileEditFieldData alloc] init];
	nameFieldData.uid = ProfileEditFieldDataTypeName;
	nameFieldData.title = @"ProfileEditVCNameFieldTitle".commonLocalizedString;
	nameFieldData.image = [ViewFactory sharedFactory].iconName;
	
	ProfileEditFieldData *locationFieldData = [[ProfileEditFieldData alloc] init];
	locationFieldData.uid = ProfileEditFieldDataTypeLocation;
	locationFieldData.title = @"ProfileEditVCLocationFieldTitle".commonLocalizedString;
	locationFieldData.image = [ViewFactory sharedFactory].iconLocation;
	
	ProfileEditFieldData *emailFieldData = [[ProfileEditFieldData alloc] init];
	emailFieldData.uid = ProfileEditFieldDataTypeEmail;
	emailFieldData.title = @"ProfileEditVCEmailFieldTitle".commonLocalizedString;
	emailFieldData.image = [ViewFactory sharedFactory].iconEmail;
	
	ProfileEditFieldData *aboutFieldData = [[ProfileEditFieldData alloc] init];
	aboutFieldData.uid = ProfileEditFieldDataTypeAbout;
	aboutFieldData.title = @"ProfileEditVCAboutFieldTitle".commonLocalizedString;
	aboutFieldData.image = [ViewFactory sharedFactory].iconAbout;
	
//	ProfileEditFieldData *passwordFieldData = [[ProfileEditFieldData alloc] init];
//	passwordFieldData.uid = ProfileEditFieldDataTypePassword;
//	passwordFieldData.title = @"ProfileEditVCPasswordFieldTitle".commonLocalizedString;
//	passwordFieldData.image = [ViewFactory sharedFactory].iconPassword;
	
	_contentItems = @[nameFieldData, locationFieldData, emailFieldData, aboutFieldData/*, passwordFieldData*/];
	
	UITableView *userDataTableView = [[UITableView alloc] initWithFrame: self.view.bounds
																  style: UITableViewStylePlain];
	userDataTableView.backgroundColor = [UIColor whiteColor];
	userDataTableView.dataSource = self;
	userDataTableView.scrollEnabled = NO;
	userDataTableView.tableHeaderView = _avatarImageView;
	userDataTableView.tableFooterView = [[UIView alloc] init];
	[self.view insertSubview: userDataTableView belowSubview: _titleBarView];
	_contentTableView = userDataTableView;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:)
												 name:UIKeyboardWillShowNotification object:nil];
 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification object:nil];
	
	for (ProfileEditFieldData *fieldData in _contentItems) {
		switch (fieldData.uid) {
			case ProfileEditFieldDataTypeName:
				fieldData.value = self.user.fio;
				break;
			case ProfileEditFieldDataTypeLocation:
				fieldData.value = self.user.city;
				break;
			case ProfileEditFieldDataTypeEmail:
				fieldData.value = self.user.email;
				break;
			case ProfileEditFieldDataTypeAbout:
				fieldData.value = self.user.about;
				break;
			default:
				fieldData.value = nil;
				break;
		}
	}
	[_contentTableView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear: animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
}
									
#pragma mark - Action
									
- (void) changeAvatarAction: (id) sender {
	[kernel.imagePickManager takePictureWith:^(UIImage *image) {
		_image = image;
		[_avatarImageView loadSizeThatFits: image];
	}];
}

- (void) saveAction: (id) sender {
	[_contentTableView endEditing: YES];
	
	for (ProfileEditFieldData *fieldData in _contentItems) {
		switch (fieldData.uid) {
			case ProfileEditFieldDataTypeName:
				self.user.fio = fieldData.value;
				break;
			case ProfileEditFieldDataTypeLocation:
				self.user.city = fieldData.value;
				break;
			case ProfileEditFieldDataTypeEmail:
				self.user.email = fieldData.value;
				break;
			case ProfileEditFieldDataTypeAbout:
				self.user.about = fieldData.value;
				break;
			default:
				break;
		}
	}
	[kernel.userManager updateUserAvatar: _image];
	[kernel.userManager updateUser: self.user];
}

#pragma mark -
#pragma mark Table view data source methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	short count = 3;
//    return count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contentItems count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	ProfileEditTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ProfileEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											   reuseIdentifier:CellIdentifier];
		cell.delegate = self;
	}
	
	cell.fieldData = _contentItems[indexPath.row];
	
	return cell;
}

#pragma mark - ProfileEditTableViewCellDelegate implementation

- (void) tableCellDidBeginEditing:(ProfileEditTableViewCell *)cell {
	_activeResponder = cell;
	_contentTableView.scrollEnabled = YES;
}

- (void) tableCellDidEndEditing:(ProfileEditTableViewCell *)cell {
	_activeResponder = nil;
	_contentTableView.scrollEnabled = NO;
}

@end
