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
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate> {
	UITableView __weak *_tableView;
}

@end

@implementation CommentsViewController

- (void) setComments:(NSArray *)comments {
	_comments = comments;
	
	[_tableView reloadData];
	self.waitViewHidden = YES;
}

- (void	) loadView {
	[super loadView];
	
	_titleBarView.titleLabel.text = @"CommentsViewControllerTitle".commonLocalizedString;
	
	CGRect contentFrame = self.contentFrame;
	
	UITableView *tableView = [[UITableView alloc] initWithFrame: contentFrame style: UITableViewStylePlain];
	//	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
	//	tableView.contentInset = UIEdgeInsetsMake(0, 0, tableFrame.size.height - contentFrame.size.height, 0);
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.tableFooterView = [[UIView alloc] init];
	tableView.rowHeight = 60;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview: tableView];
	
	_tableView = tableView;
	
	[kernel.checksManager getCommentsForPhoto: self.photo];
	self.waitViewHidden = NO;
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

@end
