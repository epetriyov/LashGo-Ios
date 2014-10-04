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

@interface ProfileEditViewController () <UITableViewDataSource> {
	UIImageView *_avatarImageView;
}

@end

@implementation ProfileEditViewController

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[_titleBarView removeFromSuperview];
	TitleBarView *tbView = [TitleBarView titleBarViewWithRightButtonWithText: @"TitleBarRightSaveBtnText".commonLocalizedString];
	tbView.backgroundColor = [UIColor clearColor];
	[tbView.backButton addTarget: self action: @selector(backAction:)
				 forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	_avatarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 240)];
	_avatarImageView.backgroundColor = [UIColor colorWithRed: 0 green: 172.0/255.0 blue: 193.0/255.0 alpha: 1.0];
	_avatarImageView.contentMode = UIViewContentModeBottom;
	_avatarImageView.userInteractionEnabled = YES;
	[self.view insertSubview: _avatarImageView belowSubview: _titleBarView];
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
	
	float offsetY = _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height;
	
	UITableView *userDataTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, offsetY,
																					self.view.frame.size.width,
																					self.view.frame.size.height - offsetY)
																  style: UITableViewStylePlain];
	userDataTableView.dataSource = self;
	[self.view addSubview: userDataTableView];
}
									
#pragma mark - Action
									
- (void) changeAvatarAction: (id) sender {
	
}

#pragma mark -
#pragma mark Table view data source methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	short count = 3;
//    return count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	short numberOfRows = 6;
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
//	LGCheck *item;
//	
//	if (indexPath.section == CheckListSectionActive) {
//		item = kernel.storage.checks[indexPath.row];
//	} else if (indexPath.section == CheckListSectionVote) {
//		item = nil;
//	} else if (indexPath.section == CheckListSectionClosed) {
//		item = nil;
//	}
	
	ProfileEditTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ProfileEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											   reuseIdentifier:CellIdentifier];
	}
	
//	cell.textLabel.text = item.name;
//	cell.detailTextLabel.text = item.descr;
	
	return cell;
}

@end
