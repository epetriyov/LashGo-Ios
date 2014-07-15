//
//  CheckCardViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

@interface CheckCardViewController : TitleBarViewController <UICollectionViewDataSource> {
	UILabel *_titleLabel;
	UILabel *_descriptionLabel;
}

@end
