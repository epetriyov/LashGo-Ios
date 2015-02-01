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

@interface LicenseViewController () <UIWebViewDelegate> {
	UIWebView __weak *_webView;
	UIActivityIndicatorView __weak *_activityIndicator;
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
	
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	activityIndicator.center = webView.center;
	[self.view addSubview: activityIndicator];
	_activityIndicator = activityIndicator;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	if (self.content != nil) {
		[_webView loadData: self.content MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL: nil];
	} else if (self.contentURLString) {
		NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: self.contentURLString]];
		[_webView loadRequest: request];
	}
}

- (void) closeAction: (id) sender {
	[self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[_activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[_activityIndicator stopAnimating];
}

@end
