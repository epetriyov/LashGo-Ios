//
//  JSONParser.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONParser.h"

#import "Common.h"
#import "NSDateFormatter+CustomFormats.h"
#import "URLConnection.h"

@implementation JSONParser

#define SHOW_RECEIVED_JSON

- (id) parseJSONData: (NSData *) jsonData {
	NSError *error = nil;
	
#if defined SHOW_RECEIVED_JSON && defined DEBUG
	NSString *jsonString = [NSString stringWithData: jsonData];
	DLog(@"%@", jsonString);
#endif
	
	id jsonObj = [NSJSONSerialization JSONObjectWithData: jsonData options: 0 error: &error];
	if (error != nil) {
		DLog(@"JSON parsing error: %@", error.description);
	}
	return jsonObj;
}

- (NSError *) parseError: (URLConnection *) connection {
	NSError *error = connection.error;
	if (error == nil) {
		NSString *msgCode;
		int code;
		NSDictionary *errorMsg;
		
		@try {
			NSDictionary *jsonDataObj = [self parseJSONData: connection.downloadedData];
			NSDictionary *parsedError = jsonDataObj[@"result"];
			
			if (parsedError != nil) {
				NSString *msg;
				
				msgCode = parsedError[@"msgCode"];
				code = [parsedError[@"code"] intValue];
				msg = parsedError[@"msg"];
#ifdef DEBUG
				NSArray *parsedData = jsonDataObj[@"data"][@"fields"];
				NSMutableString *debugString = [NSMutableString string];
				for (NSDictionary *field in parsedData) {
					[debugString appendFormat: @"\n %@ -> %@", field[@"name"], field[@"msg"]];
				}
				msg = [msg stringByAppendingFormat: @"\n<DEBUG: %@>", debugString];
#endif
				errorMsg = @{NSLocalizedDescriptionKey: msg};
			} else {
				msgCode = @"ErrorServerErrorParsingTitle".commonLocalizedString;
				code = (int)connection.response.statusCode;
				errorMsg = @{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode: code]};
			}
		}
		@catch (NSException *exception) {
			msgCode = @"ErrorServerErrorParsingTitle".commonLocalizedString;
			code = 400;
			errorMsg = @{NSLocalizedDescriptionKey: @"ErrorServerErrorParsingMessage".commonLocalizedString};
		}
		@finally {
			error = [NSError errorWithDomain: msgCode
										code: code
									userInfo: errorMsg];
		}
	}
	//	DLog(@"Error for connection: %@", error.description);
	return error;
}

#pragma mark -

- (NSArray *) parseChecks: (NSData *) jsonData {
	NSArray *rawData = [self parseJSONData: jsonData][@"resultCollection"];
	
	NSMutableArray *checks = [NSMutableArray array];
	
	for (NSDictionary *rawCheck in rawData) {
		LGCheck *check = [[LGCheck alloc] init];
		
		check.uid =			[rawCheck[@"id"] longLongValue];
		check.name =		rawCheck[@"name"];
		check.descr	=		rawCheck[@"description"];
		
		NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFullDateFormat];
		
		NSString *str =		rawCheck[@"startDate"];
		check.startDate =	[[dateFormatter dateFromString: str] timeIntervalSinceReferenceDate];
		
		short durationSectionSeconds = 3600;
		
		check.duration =	[rawCheck[@"duration"] intValue] * durationSectionSeconds;
		check.voteDuration = [rawCheck[@"voteDuration"] intValue] * durationSectionSeconds;
		
		check.voteDate =	check.startDate + check.duration;
		check.closeDate =	check.voteDate + check.voteDuration;
		
		check.taskPhotoUrl =	rawCheck[@"taskPhotoUrl"];
		
		LGCheckCounters *counters = [[LGCheckCounters alloc] init];
		counters.playersCount =	[rawCheck[@"playersCount"] intValue];
		
		check.counters = counters;
		
		check.userPhoto =	[self parsePhoto: rawCheck[@"userPhotoDto"]];
		check.winnerPhoto =	[self parsePhoto: rawCheck[@"winnerPhotoDto"]];
		check.winnerPhoto.user = [self parseUser: rawCheck[@"winnerInfo"]];
		
		[checks addObject: check];
	}
	
	if ([checks count] <= 0) {
		checks = nil;
	}
	return checks;
}

- (NSArray *) parsePhotos: (NSArray *) jsonDataObj {
	NSMutableArray *photos = [NSMutableArray array];
	
	for (NSDictionary *rawPhoto in jsonDataObj) {
		LGPhoto *photo = [self parsePhoto: rawPhoto];
		if (photo != nil) {
			[photos addObject: photo];
		}
	}
	
	if ([photos count] <= 0) {
		photos = nil;
	}
	return photos;
}

- (NSArray *) parseCheckPhotos: (NSData *) jsonData {
	NSArray *rawData = [self parseJSONData: jsonData][@"resultCollection"];
	NSArray *checkPhotos = [self parsePhotos: rawData];
	return  checkPhotos;
}

- (LGVotePhotosResult *) parseCheckVotePhotos: (NSData *) jsonData {
	NSArray *rawData = [self parseJSONData: jsonData][@"resultCollection"];
	
	LGVotePhotosResult *result = nil;
//	result.photosCount = [rawData[@"photosCount"] intValue];
	NSMutableArray *votePhotos = [[NSMutableArray alloc] init];
	
	for (NSDictionary *rawVotePhoto in rawData) {
		LGPhoto *photo = [self parsePhoto: rawVotePhoto[@"photoDto"]];
		if (photo != nil) {
			LGVotePhoto *votePhoto = [[LGVotePhoto alloc] init];
			votePhoto.photo =	photo;
			votePhoto.isShown =	[rawVotePhoto[@"shown"] boolValue];
			votePhoto.isVoted =	[rawVotePhoto[@"voted"] boolValue];
			[votePhotos addObject: votePhoto];
		}
	}
	
	if ([votePhotos count] > 0) {
		result = [[LGVotePhotosResult alloc] init];
		result.votePhotos = votePhotos;
	}
	
	return result;
}

- (LGPhoto *) parsePhoto: (NSDictionary *) jsonDataObj {
	LGPhoto *photo = nil;
	
	if ([jsonDataObj count] > 0) {
		NSDictionary *rawPhoto = jsonDataObj;
		
		photo = [[LGPhoto alloc] init];
		
		photo.uid =	[rawPhoto[@"id"] longLongValue];
		photo.url =	rawPhoto[@"url"];
		photo.user = [self parseUser: rawPhoto[@"user"]];
		
		photo.isBanned = [rawPhoto[@"isBanned"] boolValue];
		photo.isWinner = [rawPhoto[@"isWinner"] boolValue];
	}
	return photo;
}

- (LGRegisterInfo *) parseRegiserInfo: (NSData *) jsonData {
	NSDictionary *rawData = [self parseJSONData: jsonData][@"result"];
	
	LGRegisterInfo *registerInfo = [[LGRegisterInfo alloc] init];
	
	NSDictionary *rawUser = rawData[@"userDto"];
	LGUser *user = [self parseUser: rawUser];
	
	LGSessionInfo *sessionInfo = [[LGSessionInfo alloc] init];
	
	sessionInfo.uid =	rawData[@"sessionId"];
	
	registerInfo.user =			user;
	registerInfo.sessionInfo =	sessionInfo;
	
	return registerInfo;
}

- (LGUser *) parseUser: (NSDictionary *) jsonDataObj {
	LGUser *user = nil;
	
	if ([jsonDataObj count] > 0) {
		NSDictionary *rawUser = jsonDataObj;
		
		user = [[LGUser alloc] init];
		
		user.uid =		[rawUser[@"id"] intValue];
		user.fio =		rawUser[@"fio"];
//		user.about =	rawUser[@"about"];
//		user.city =		rawUser[@"city"];
//		user.birthDate;
		user.avatar =	rawUser[@"avatar"];
		user.email =	rawUser[@"email"];
		
		user.userSubscribes =	[rawUser[@"userSubscribes"] intValue];
		user.userSubscribers =	[rawUser[@"userSubscribers"] intValue];
		user.checksCount =		[rawUser[@"checksCount"] intValue];
		user.commentsCount =	[rawUser[@"commentsCount"] intValue];
		user.likesCount =		[rawUser[@"likesCount"] intValue];

	}
	return user;
}

- (NSArray *) parseUserPhotos: (NSData *) jsonData {
	NSArray *rawData = [self parseJSONData: jsonData][@"resultCollection"];
	
	NSMutableArray *userPhotos = [NSMutableArray array];
	
	for (NSDictionary *rawPhoto in rawData) {
		LGPhoto *photo = [self parsePhoto: rawPhoto];
		if (photo != nil) {
			[userPhotos addObject: photo];
		}
	}
	
	if ([userPhotos count] <= 0) {
		userPhotos = nil;
	}
	return userPhotos;
}

- (LGUser *) parseUserProfile: (NSData *) jsonData {
	NSDictionary *rawData = [self parseJSONData: jsonData][@"result"];
	LGUser *user = [self parseUser: rawData];
	return user;
}

@end
