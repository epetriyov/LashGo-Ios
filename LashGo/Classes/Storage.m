//
//  Storage.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 07.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Storage.h"

@interface Storage () {
	NSMutableArray *_checks;
}

@end

@implementation Storage

#pragma mark - Properties

- (void) replaceWithObjectsFromArrayChecks: (NSArray *) newValues {
	[_checks replaceObjectsInRange: NSMakeRange(0, [_checks count]) withObjectsFromArray: newValues];
}

#pragma mark - Standard

- (id) init {
	if (self = [super init]) {
		_checks = [[NSMutableArray alloc] init];
	}
	return self;
}

@end
