//
//  EULAViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.01.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "LicenseViewController.h"

#import "Common.h"
#import "ViewFactory.h"

@interface LicenseViewController () {
	UIWebView __weak *_webView;
}

@end

@implementation LicenseViewController

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_titleBarView.titleLabel.text = @"LicenseVCTitle".commonLocalizedString;
	[_titleBarView.backButton removeTarget: self action: @selector(backAction:)
						  forControlEvents: UIControlEventTouchUpInside];
	[_titleBarView.backButton addTarget: self action: @selector(closeAction:)
					   forControlEvents: UIControlEventTouchUpInside];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame: self.contentFrame];
//	webView.scalesPageToFit = YES;
	[self.view addSubview: webView];
	_webView = webView;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	if (self.content != nil) {
		[_webView loadData: self.content MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL: nil];
	}
}

- (void) closeAction: (id) sender {
	[self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

@end
