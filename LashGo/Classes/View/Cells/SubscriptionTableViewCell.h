//
//  SubscriptionTableViewCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 29.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubscriptionTableViewCellDelegate;

@interface SubscriptionTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSubscribed;
@property (nonatomic, weak) id<SubscriptionTableViewCellDelegate> delegate;

+ (CGFloat) height;

@end

@protocol SubscriptionTableViewCellDelegate <NSObject>

@required
- (void) subscriptionActionFor: (SubscriptionTableViewCell *) cell;

@end
