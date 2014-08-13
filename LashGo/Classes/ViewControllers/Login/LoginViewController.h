//
//  LoginViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

@interface LoginViewController : TitleBarViewController {
	UITextField __weak *_emailField;
	UILabel __weak *_tokenLabel;
}

@end
