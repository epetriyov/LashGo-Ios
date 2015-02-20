//
//  ProfileEditViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileEditViewController.h"

#import "Common.h"
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
}

@end

@implementation ProfileEditViewController

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
	_avatarImageView.backgroundColor = [UIColor colorWithRed: 0 green: 172.0/255.0 blue: 193.0/255.0 alpha: 1.0];
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
	
	ProfileEditFieldData *passwordFieldData = [[ProfileEditFieldData alloc] init];
	passwordFieldData.uid = ProfileEditFieldDataTypePassword;
	passwordFieldData.title = @"ProfileEditVCPasswordFieldTitle".commonLocalizedString;
	passwordFieldData.image = [ViewFactory sharedFactory].iconPassword;
	
	_contentItems = @[nameFieldData, locationFieldData, emailFieldData, aboutFieldData, passwordFieldData];
	
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
	
}

- (void) saveAction: (id) sender {
	
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

#pragma mark - Keyboard notifications

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	CGRect intersectionRect = CGRectIntersection(_contentTableView.frame, kbRect);
 
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, intersectionRect.size.height, 0.0);
	_contentTableView.contentInset = contentInsets;
	_contentTableView.scrollIndicatorInsets = contentInsets;
 
	// If active text field is hidden by keyboard, scroll it so it's visible
	CGRect activeResponderRect = [_contentTableView convertRect:_activeResponder.frame toView: nil];
	if (CGRectIntersectsRect(activeResponderRect, intersectionRect)) {
		[_contentTableView scrollRectToVisible: _activeResponder.frame animated:YES];
	}
}

//// Called when the UIKeyboardDidShowNotification is sent.
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//	NSDictionary* info = [aNotification userInfo];
//	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
// 
//	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//	_contentTableView.contentInset = contentInsets;
//	_contentTableView.scrollIndicatorInsets = contentInsets;
// 
//	// If active text field is hidden by keyboard, scroll it so it's visible
//	// Your app might not need or want this behavior.
//	CGRect aRect = self.view.frame;
//	aRect.size.height -= kbSize.height;
//	if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//		[self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//	}
//}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	_contentTableView.contentInset = contentInsets;
	_contentTableView.scrollIndicatorInsets = contentInsets;
}

@end
