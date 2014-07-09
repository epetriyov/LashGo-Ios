//
//  CheckCardViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardViewController.h"
#import "CheckDetailView.h"

@interface CheckCardViewController ()

@end

@implementation CheckCardViewController

- (void) loadView {
	[super loadView];
	
	CheckDetailView *cv = [[CheckDetailView alloc] initWithFrame: CGRectMake(0, 50, 320, 200)];
	[self.view addSubview: cv];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
