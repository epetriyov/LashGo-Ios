//
//  CommentsViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CommentsViewController.h"

#import "CommentTableViewCell.h"
#import "Common.h"
#import "Kernel.h"
#import "NSObject+KeyboardManagement.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

#import "CommentsTableView.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate> {
	UITableView __weak *_tableView;
	UILabel __weak *_emptyListLabel;
	CommentInputView __weak *_inputView;
}

@end

@implementation CommentsViewController

- (UIScrollView *) contentScrollView {
	return _tableView;
}

- (UIView *) activeFirstResponder {
	return nil;
}

- (void) setComments:(NSArray *)comments {
	_comments = comments;
	
	[_tableView reloadData];
	self.waitViewHidden = YES;
	
	_emptyListLabel.alpha = [self.comments count] <= 0 ? 1 : 0;
}

- (void	) loadView {
	[super loadView];
	
	_titleBarView.titleLabel.text = @"CommentsViewControllerTitle".commonLocalizedString;
	
	CGRect contentFrame = self.contentFrame;
	
	UITableView *tableView = [[CommentsTableView alloc] initWithFrame: contentFrame style: UITableViewStylePlain];
	//	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
	//	tableView.contentInset = UIEdgeInsetsMake(0, 0, tableFrame.size.height - contentFrame.size.height, 0);
	tableView.dataSource = self;
	tableView.delegate = self;
	[self.view addSubview: tableView];
	
	_inputView = (CommentInputView *)tableView.inputAccessoryView;
	[_inputView.actionButton addTarget: self action: @selector(sendCommentAction:)
					  forControlEvents: UIControlEventTouchUpInside];
	
	[tableView becomeFirstResponder];
	
	_tableView = tableView;
	
	UILabel *emptyListLabel = [[ViewFactory sharedFactory] emptyListLabelWithFrame: contentFrame
																		  andText: @"CommentsEmptyLabel".commonLocalizedString];
	[self.view addSubview:emptyListLabel];
	_emptyListLabel = emptyListLabel;
	
	[kernel.checksManager getCommentsForPhoto: self.photo];
	self.waitViewHidden = NO;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear: animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
}

#pragma mark - Methods

- (void) sendCommentAction: (id) sender {
	LGComment *comment = [[LGComment alloc] init];
	comment.content = _inputView.textField.text;
	
	LGCommentAction *commentAction = [[LGCommentAction alloc] init];
	commentAction.context = self.photo;
	commentAction.comment = comment;
	[kernel.checksManager sendCommentWith: commentAction];
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	LGComment *item = self.comments[indexPath.row];
	
	[kernel.userManager openProfileViewControllerWith: item.user];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	short count = 1;
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	short numberOfRows = [self.comments count];
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
	LGComment *item = self.comments[indexPath.row];
	
	CommentTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.text = item.user.fio;
	cell.detailTextLabel.text = item.content;
	[cell.imageView loadWebImageWithSizeThatFitsName: item.user.avatar
										 placeholder: [ViewFactory sharedFactory].titleBarAvatarPlaceholder];
	
	return cell;
}

#pragma mark - Methods for edit

- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Delete".commonLocalizedString;
}

- (BOOL) tableView: (UITableView *) theTableView canEditRowAtIndexPath: (NSIndexPath *) indexPath {
	LGComment *item = self.comments[indexPath.row];
	LGUser *currentUser = [AuthorizationManager sharedManager].account.userInfo;
	
	return currentUser != nil && item.user.uid == [AuthorizationManager sharedManager].account.userInfo.uid;
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) editingStyle forRowAtIndexPath: (NSIndexPath *) indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		LGComment *item = self.comments[indexPath.row];
		
		LGCommentAction *commentAction = [[LGCommentAction alloc] init];
		commentAction.context = self.photo;
		commentAction.comment = item;
		[kernel.checksManager removeCommentWith: commentAction];
	}
}

@end
