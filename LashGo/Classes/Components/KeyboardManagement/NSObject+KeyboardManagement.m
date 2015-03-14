//
//  NSObject+KeyboardManagement.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 10.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "NSObject+KeyboardManagement.h"

@implementation NSObject (KeyboardManagement)

@dynamic contentScrollView, activeFirstResponder;

#pragma mark - Keyboard management

- (void)keyboardWillBeShown:(NSNotification*)aNotification {
	NSDictionary* info = [aNotification userInfo];
	CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	CGRect viewRect = [self.contentScrollView.superview convertRect: self.contentScrollView.frame toView: nil];
	
	CGRect intersectionRect = CGRectIntersection(viewRect, keyboardRect);
 
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, intersectionRect.size.height, 0.0);
	self.contentScrollView.contentInset = contentInsets;
	self.contentScrollView.scrollIndicatorInsets = contentInsets;
	
	CGRect responderRect = [self.activeFirstResponder.superview convertRect: self.activeFirstResponder.frame toView: nil];
	
	// If active text field is hidden by keyboard, scroll it so it's visible
	if (CGRectIntersectsRect(intersectionRect, responderRect) ) {
		CGRect frameToScroll = [self.activeFirstResponder.superview convertRect: self.activeFirstResponder.frame toView: self.contentScrollView];
		//animation looks wrong commented
//		NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//		UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//
//		[UIView beginAnimations: @"keyboardLikeAnimation" context: nil];
//		[UIView setAnimationDuration: duration];
//		[UIView setAnimationCurve: curve];
		[self.contentScrollView scrollRectToVisible: frameToScroll animated: YES];
//		[UIView commitAnimations];
	}
}

- (void)keyboardDidShown:(NSNotification*)aNotification {
	NSDictionary* info = [aNotification userInfo];
	CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	CGRect viewRect = [self.contentScrollView.superview convertRect: self.contentScrollView.frame toView: nil];
	
	CGRect intersectionRect = CGRectIntersection(viewRect, keyboardRect);
 
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, intersectionRect.size.height, 0.0);
	self.contentScrollView.contentInset = contentInsets;
	self.contentScrollView.scrollIndicatorInsets = contentInsets;
	
	CGRect responderRect = [self.activeFirstResponder.superview convertRect: self.activeFirstResponder.frame toView: nil];
	
	// If active text field is hidden by keyboard, scroll it so it's visible
	if (CGRectIntersectsRect(intersectionRect, responderRect) ) {
		CGRect frameToScroll = [self.activeFirstResponder.superview convertRect: self.activeFirstResponder.frame toView: self.contentScrollView];
		//animation looks wrong commented
//		NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//		UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//
//		[UIView beginAnimations: @"keyboardLikeAnimation" context: nil];
//		[UIView setAnimationDuration: duration];
//		[UIView setAnimationCurve: curve];
		
		[self.contentScrollView scrollRectToVisible: frameToScroll animated: YES];
//		[UIView commitAnimations];
	}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	self.contentScrollView.contentInset = contentInsets;
	self.contentScrollView.scrollIndicatorInsets = contentInsets;
}

@end
