//
//  ProfileEditTableViewCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileEditFieldData.h"

@protocol ProfileEditTableViewCellDelegate;

@interface ProfileEditTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ProfileEditTableViewCellDelegate> delegate;
@property (nonatomic, weak) ProfileEditFieldData *fieldData;
@property (nonatomic, readonly) UITextField *field;

@end

@protocol ProfileEditTableViewCellDelegate <NSObject>

@required
- (void) tableCellDidBeginEditing:(ProfileEditTableViewCell *) cell;
- (void) tableCellDidEndEditing:(ProfileEditTableViewCell *) cell;

@end
