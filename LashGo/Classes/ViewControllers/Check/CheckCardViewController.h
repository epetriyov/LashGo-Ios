//
//  CheckCardViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TaskBarViewController.h"

@interface CheckCardViewController : TaskBarViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
	UILabel *_titleLabel;
	UILabel *_descriptionLabel;
}

- (void) refresh;

@end
