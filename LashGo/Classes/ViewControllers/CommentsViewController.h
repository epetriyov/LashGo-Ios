//
//  CommentsViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

#import "LGPhoto.h"

@interface CommentsViewController : TitleBarViewController

@property (nonatomic, strong) LGPhoto *photo;
@property (nonatomic, strong) NSArray *comments;

@end
