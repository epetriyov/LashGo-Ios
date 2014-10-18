//
//  PhotoCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "PhotoCollectionCell.h"
#import "UIImageView+LGImagesExtension.h"

@interface PhotoCollectionCell () {
	LGPhoto *_photo;
	UIImageView *_imageView;
}

@end

@implementation PhotoCollectionCell

@dynamic photo;

- (LGPhoto *) photo {
	return _photo;
}

- (void) setPhoto:(LGPhoto *)photo {
	_photo = photo;
	
	[_imageView loadWebImageWithSizeThatFitsName: _photo.url placeholder: nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_imageView = [[UIImageView alloc] initWithFrame: self.bounds];
		_imageView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview: _imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
