//
//  Storage.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 07.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Storage.h"

#import "LGCheck.h"

NSString *const kLGStorageChecksActionObservationPath = @"checksActions";
NSString *const kLGStorageChecksSelfieObservationPath = @"checksSelfie";

@interface Storage ()
//{
//	NSMutableArray *_checks;
//}

@property (nonatomic, strong) NSArray *checksActions;
@property (nonatomic, strong) NSArray *checksSelfie;

@end

@implementation Storage

//@synthesize checks = _checks;
//
#pragma mark - Properties

- (void) setChecks:(NSArray *)checks {
	NSMutableArray *checksAction = [[NSMutableArray alloc] init];
	NSMutableArray *checksSelfie = [[NSMutableArray alloc] init];
	for (uint i = 0; i < [checks count]; ++i) {
		LGCheck *check = checks[i];
		
		switch (check.type) {
			case CheckTypeAction:
				[checksAction addObject: check];
				break;
			case CheckTypeSelfie:
				[checksSelfie addObject: check];
				break;
			default:
				break;
		}
	}
	if ([checksAction count] <= 0) {
		checksAction = nil;
	}
	if ([checksSelfie count] <= 0) {
		checksSelfie = nil;
	}
	_checks = checks;
	self.checksActions = checksAction;
	self.checksSelfie = checksSelfie;
}

//#pragma mark - Standard
//
//- (id) init {
//	if (self = [super init]) {
//		_checks = [[NSMutableArray alloc] init];
//	}
//	return self;
//}
//
//#pragma mark - Methods
//
//- (void) updateChecksWith: (NSArray *) newValues {
//	[_checks replaceObjectsInRange: NSMakeRange(0, [_checks count]) withObjectsFromArray: newValues];
//}

@end
