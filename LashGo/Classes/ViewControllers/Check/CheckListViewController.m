//
//  CheckListViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckListViewController.h"

#import "CheckListTableViewCell.h"
#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "LGCheck.h"
#import "ViewFactory.h"

typedef NS_ENUM(NSInteger, CheckListSection) {
	CheckListSectionActive = 0,
	CheckListSectionVote,
	CheckListSectionClosed
};

@interface CheckListViewController () {
	UITableView __weak *_tableView;
}

@end

@implementation CheckListViewController

- (void) loadView {
	[super loadView];
	
	//Reconfigure titleBar
	[_titleBarView removeFromSuperview];
	UIButton *cardsButton = [[ViewFactory sharedFactory] titleBarCheckCardsButtonWithTarget: self
																					 action: @selector(switchToCardsAction:)];
	UIButton *searchButton = [[ViewFactory sharedFactory] titleBarRightSearchButtonWithTarget: self
																					   action: @selector(openSearchAction:)];
	UIButton *incomeButton = [[ViewFactory sharedFactory] titleBarRightIncomeButtonWithTarget: self
																					   action: @selector(openIncomeAction:)];
	TitleBarView *tbView = [TitleBarView titleBarViewWithLeftButton: cardsButton
												 rightButton: incomeButton
												searchButton: searchButton];
	tbView.titleLabel.text = @"ChecksTitle".commonLocalizedString;
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	UITableView *tableView = [[UITableView alloc] initWithFrame: self.contentFrame style: UITableViewStylePlain];
	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview: tableView];
	
	_tableView = tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void) refresh {
	[_tableView reloadData];
}

- (void) switchToCardsAction: (id) sender {
	[kernel.checksManager openCheckCardViewController];
}

- (void) openSearchAction: (id) sender {
	[kernel.viewControllersManager openSearchViewController];
}

- (void) openIncomeAction: (id) sender {
	
}

#pragma mark - Table delegate implementation

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	CGFloat height = 40;
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *resultView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 40)];
	resultView.backgroundColor = tableView.backgroundColor;
	//Generate section header
	
	float offsetX = 15;
	
	UILabel *headerTextLabel = [[UILabel alloc] initWithFrame:
								CGRectMake(offsetX, resultView.frame.size.height / 2,
										   resultView.frame.size.width - offsetX * 2,
										   resultView.frame.size.height / 2)];
	headerTextLabel.font = [FontFactory fontWithType: FontTypeCheckListHeaderTitle];
	[headerTextLabel setTextColor: [FontFactory fontColorForType: FontTypeCheckListHeaderTitle]];
	headerTextLabel.backgroundColor = [UIColor clearColor];
	
	[resultView addSubview: headerTextLabel];
	
	if (section == CheckListSectionActive) {
		headerTextLabel.text = @"ChecksActiveHeaderTitle".commonLocalizedString;
	} else if (section == CheckListSectionVote) {
		headerTextLabel.text = @"ChecksVoteHeaderTitle".commonLocalizedString;
	} else if (section == CheckListSectionClosed) {
		headerTextLabel.text = @"ChecksClosedHeaderTitle".commonLocalizedString;
	}
	
	return resultView;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	if ([self tableView: theTableView cellForRowAtIndexPath: indexPath].accessoryType == UITableViewCellAccessoryNone) {
		return;
	}
	
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	short count = 3;
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	short numberOfRows = 0;
	if (section == CheckListSectionActive) {
		numberOfRows = [kernel.storage.checks count];
	} else if (section == CheckListSectionVote) {
		numberOfRows = 0;
	} else if (section == CheckListSectionClosed) {
		numberOfRows = 0;
	}
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	LGCheck *item;
	
	if (indexPath.section == CheckListSectionActive) {
		item = kernel.storage.checks[indexPath.row];
	} else if (indexPath.section == CheckListSectionVote) {
		item = nil;
	} else if (indexPath.section == CheckListSectionClosed) {
		item = nil;
	}
	
	CheckListTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[CheckListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
											 reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.text = item.name;
	cell.detailTextLabel.text = item.descr;
	
	return cell;
}

@end
