//
//  EventTableViewCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 20.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventTableViewCellDelegate;

@interface EventTableViewCell : UITableViewCell

@property (nonatomic, weak) id<EventTableViewCellDelegate> delegate;

- (void) setCheckPhotoUrl: (NSString *) checkPhotoURL;

@end

@protocol EventTableViewCellDelegate <NSObject>

@required
- (void) eventCheckActionFor: (EventTableViewCell *) cell;

@end
