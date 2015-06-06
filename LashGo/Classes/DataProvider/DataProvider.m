//
//  DataProvider.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DataProvider.h"

#import "AlertViewManager.h"
#import "AppDelegate.h"
#import "AuthorizationManager.h"
#import "Common.h"
#import "URLConnectionManager.h"

#ifdef DEBUG
//	#define USE_PREFETCHED_DATA
#endif

#define kWebServiceURL @"http://lashgo.com:8080/lashgo-api"
//#define kWebServiceURL @"http://78.47.39.245:8080/lashgo-api"
//#define kWebServiceURL @"http://109.195.38.41:1977/lashgo-api"
#define kWebServicePhotoPath @"/photos/"

#define kAPNSRegisterPath		@"/apns/register" //POST
#define kAPNSRegisterTestPath	@"/apns/test" //POST

#define kChecksPath			@"/checks" //POST
#define kChecksByUIDPath	@"/checks/%lld" //GET
#define kChecksCurrentPath	@"/checks/current" //GET
#define kChecksCommentsPath	@"/checks/%lld/comments" //GET, POST
#define kChecksPhotosPath	@"/checks/%lld/photos" //GET, POST
#define kChecksVotePhotosPath	@"/checks/%lld/vote/photos" //GET
#define kChecksUsersPath	@"/checks/%lld/users" //GET

#define kCommentsPath @"/comments/%lld" //DELETE

#define kEventsPath	@"/events" //GET

#define kPhotosPath			@"/photos/%@" //GET
#define kPhotosCommentsPath	@"/photos/%lld/comments" //GET
#define kPhotosCommentAddPath	@"/photos/%lld/comments/new" //POST
#define kPhotosComplainPath @"/photos/%lld/complain" //POST
#define kPhotosCountersPath	@"/photos/%lld/counters" //GET
#define kPhotosVotesPath	@"/photos/%lld/votes" //GET"
#define kPhotosVotePath		@"/photos/vote" //POST

#define kUsersPath					@"/users"//GET
#define kUsersAvatarPath			@"/users/avatar" //POST
#define kUsersLoginPath				@"/users/login" //POST
#define kUsersMainScreenInfoPath	@"/users/main-screen-info" //GET
#define kUsersPhotosPath			@"/users/photos" //GET
#define kUsersPhotosByUIDPath		@"/users/%d/photos" //GET
#define kUsersProfilePath			@"/users/profile" //GET, PUT
#define kUsersProfileByUIDPath		@"/users/%d/profile" //GET
#define kUsersRecoverPath			@"/users/recover" //PUT
#define kUsersRegisterPath			@"/users/register" //POST
#define kUsersSocialSignInPath		@"/users/social-sign-in" //POST
#define kUsersSubscribersPath			@"/users/%d/subscribers" //GET
#define kUsersSubscriptionsPath			@"/users/%d/subscriptions" //GET
#define kUsersSubscriptionsAddPath		@"/users/subscriptions" //POST
#define kUsersSubscriptionsDeletePath	@"/users/subscriptions/%d" //DELETE

static NSString *const kRequestClientType =	@"client_type";
static NSString *const kRequestSessionID =	@"session_id";
static NSString *const kRequestUUID =		@"uuid";

@interface DataProvider () {
	URLConnectionManager *_connectionManager;
	NSMutableDictionary *_liveConnections;
	JSONParser *_parser;
}

@end

@implementation DataProvider

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		_connectionManager = [[URLConnectionManager alloc] init];
		_connectionManager.prepareToRemoveConnectionSelector = @selector(prepareToRemoveConnection:);
		_liveConnections = [[NSMutableDictionary alloc] init];
		_parser = [[JSONParser alloc] init];
	}
	return self;
}

#pragma mark -

- (NSMutableDictionary *) dictionaryWithHeaderParams {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   @"IOS",				kRequestClientType,
									   [Common deviceUUID],	kRequestUUID, nil];
	
	NSString *sessionID = [AuthorizationManager sharedManager].account.sessionID;
	if ([Common isEmptyString: sessionID] == NO) {
		dictionary[kRequestSessionID] = sessionID;
	}
	return dictionary;
}

///!!!:Works if no query params
- (void) removeConnectionFromLiveConnections: (URLConnection *) connection {
	NSString *connectionKey = [connection.request.URL.absoluteString stringByAppendingFormat: @"%d", connection.type];
	[_liveConnections removeObjectForKey: connectionKey];
}

- (void) prepareToRemoveConnection: (URLConnection *) connection {
	[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: NO];
	[self removeConnectionFromLiveConnections: connection];
}

- (void) startConnectionWithPath: (NSString *) path
					 queryParams: (NSDictionary *) params
						 context: (id) context
				   allowMultiple: (BOOL) allowMultiple
				  finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	NSString *connectionKey = [[kWebServiceURL stringByAppendingString: path]
							   stringByAppendingFormat: @"%d", URLConnectionTypeGET];
	
	if (allowMultiple == NO) {
		URLConnection *liveConnection = _liveConnections[connectionKey];
		if (liveConnection.status == URLConnectionStatusStarted) {
			return;
		}
	}
	NSMutableDictionary *headerParamsDictionary = [self dictionaryWithHeaderParams];
	id target = failSelector == nil || finishSelector == nil ? nil : self;
	URLConnection *connection = [_connectionManager connectionWithHost: kWebServiceURL
																  path: path
														   queryParams: params
														  headerParams: headerParamsDictionary
																  body: nil
																  type: URLConnectionTypeGET
																target: target
														finishSelector: finishSelector
														  failSelector: failSelector];
	connection.context = context;
	
	if (allowMultiple == NO) {
		_liveConnections[connectionKey] = connection;
	}
	
	[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: YES];
	[connection startAsync];
}

- (void) startConnectionWithPath: (NSString *) path
							type: (URLConnectionType) theType
							body: (NSDictionary *) bodyJSON
						 context: (id) context
				   allowMultiple: (BOOL) allowMultiple
				  finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	NSString *connectionKey = [[kWebServiceURL stringByAppendingString: path] stringByAppendingFormat: @"%d", theType];
	
	if (allowMultiple == NO) {
		URLConnection *liveConnection = _liveConnections[connectionKey];
		if (liveConnection.status == URLConnectionStatusStarted) {
			return;
		}
	}
	NSMutableDictionary *headerParamsDictionary = [self dictionaryWithHeaderParams];
	id target = failSelector == nil || finishSelector == nil ? nil : self;
	URLConnection *connection = [_connectionManager connectionWithHost: kWebServiceURL
																 path: path
														  queryParams: nil
														 headerParams: headerParamsDictionary
																 body: bodyJSON
																 type: theType
															   target: target
													   finishSelector: finishSelector
														 failSelector: failSelector];
	connection.context = context;
	
	if (allowMultiple == NO) {
		_liveConnections[connectionKey] = connection;
	}
	
	[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: YES];
	[connection startAsync];
}

- (void) startConnectionWithPath: (NSString *) path
					   paramName: (NSString *) paramName
							data: (NSData *) data
						 context: (id) context
				   allowMultiple: (BOOL) allowMultiple
				  finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	URLConnectionType connectionType = URLConnectionTypeMULTIPART;
	NSString *connectionKey = [[kWebServiceURL stringByAppendingString: path] stringByAppendingFormat: @"%d", connectionType];
	
	if (allowMultiple == NO) {
		URLConnection *liveConnection = _liveConnections[connectionKey];
		if (liveConnection.status == URLConnectionStatusStarted) {
			return;
		}
	}
	NSMutableDictionary *headerParamsDictionary = [self dictionaryWithHeaderParams];
	id target = failSelector == nil || finishSelector == nil ? nil : self;
	NSMutableURLRequest *request = [NSMutableURLRequest requestMultipartWithURL: [kWebServiceURL stringByAppendingString: path]
																   headerParams: headerParamsDictionary
																	  paramName: paramName
																	  paramData: data
																	   fileName: paramName];
	URLConnection *connection = [_connectionManager connectionWithHost: kWebServiceURL
																  path: path
																  type: connectionType
															   request: request
																target: target
														finishSelector: finishSelector
														  failSelector: failSelector];
	connection.context = context;
	
	if (allowMultiple == NO) {
		_liveConnections[connectionKey] = connection;
	}
	
	[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: YES];
	[connection startAsync];
}

- (NSError *) didFailGetImportantData: (URLConnection *) connection {
	NSError *error = [_parser parseError: connection];
	
	[[AlertViewManager sharedManager] showAlertViewWithError: error];
	
	return error;
}

#pragma mark - APNS

- (void) apnsSuccess: (URLConnection *) connection {
	DLog(@"%@", [NSString stringWithData: connection.downloadedData]);
}

- (void) apnsFailure: (URLConnection *) connection {
	DLog(@"%@", [NSString stringWithData: connection.downloadedData]);
}

- (void) apnsRegisterWithToken:(NSString *)inputData {
	[self startConnectionWithPath: kAPNSRegisterPath
							 type: URLConnectionTypePOST
							 body:@{@"token": inputData}
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(apnsSuccess:) failSelector: @selector(apnsFailure:)];
}

#pragma mark - Checks

- (void) didGetChecksActions: (URLConnection *) connection {
	NSArray *checks = [_parser parseChecks: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetChecksActions:)] == YES) {
		[self.delegate dataProvider: self didGetChecksActions: checks];
	}
}

- (void) checksActions {
	[self startConnectionWithPath: kChecksPath
					  queryParams: @{@"check_type" : @"ACTION"}
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetChecksActions:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetChecks: (URLConnection *) connection {
	NSArray *checks = [_parser parseChecks: connection.downloadedData];
	
	ContextualArrayResult *result = [[ContextualArrayResult alloc] init];
	result.items = checks;
	result.context = connection.context;

	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetChecks:)] == YES) {
		[self.delegate dataProvider: self didGetChecks: result];
	}
}

- (void) didGetChecksDEBUG: (NSData *) data {
	NSArray *checks = [_parser parseChecks: data];
	
	ContextualArrayResult *result = [[ContextualArrayResult alloc] init];
	result.items = checks;
	result.context = nil;
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetChecks:)] == YES) {
		[self.delegate dataProvider: self didGetChecks: result];
	}
}

- (void) checksWithContext:(id)context {
#ifdef USE_PREFETCHED_DATA
	NSString *str = @"{\"resultCollection\":[{\"id\":42,\"name\":\"Древние греки\",\"description\":\"Геракл был воином, Аристотель был ученым, а Диоген жил в бочке. А каким греком был бы ты?\",\"startDate\":\"11.04.2015 16:10:00 +0600\",\"duration\":1,\"taskPhotoUrl\":\"task_42.jpg\",\"voteDuration\":4,\"playersCount\":2},{\"id\":41,\"name\":\"Не мой день\",\"description\":\"Вот это невезуха! Самое время сфотографировать!\",\"startDate\":\"11.04.2015 15:40:00 +0600\",\"duration\":1,\"taskPhotoUrl\":\"task_41.jpg\",\"voteDuration\":1,\"playersCount\":2},{\"id\":40,\"name\":\"Позвони мне\",\"description\":\"Call me maybe!\",\"startDate\":\"28.10.2014 06:00:00 +0100\",\"duration\":7,\"taskPhotoUrl\":\"task_40.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":17,\"login\":\"lisichka\",\"fio\":\"лисица алена\",\"city\":\"б\",\"avatar\":\"avatar__user_17.jpg\",\"email\":\"lisitza.alena@gmail.ru\"},\"winnerPhotoDto\":{\"id\":137,\"url\":\"check_40_user_17.jpg\"},\"playersCount\":1},{\"id\":39,\"name\":\"Галстук\",\"description\":\"Галстук интересный элемент гардероба. А как его ещё можно использовать?\",\"startDate\":\"27.10.2014 06:00:00 +0100\",\"duration\":7,\"taskPhotoUrl\":\"task_39.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":5,\"login\":\"Betobet\",\"fio\":\"Виктор Игуменов\",\"birthDate\":\"11.10.1990 22:31:42 +0100\",\"avatar\":\"avatar__user_5.jpg\"},\"winnerPhotoDto\":{\"id\":136,\"url\":\"check_39_user_5.jpg\",\"commentsCount\":1},\"playersCount\":2},{\"id\":38,\"name\":\"Амулет\",\"description\":\"Мой волшебный талисмат даёт мне +3 к удаче. А у тебя есть волшебные вещи? ;)\",\"startDate\":\"04.11.2014 20:00:00 +0600\",\"duration\":1,\"taskPhotoUrl\":\"task_38.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":24,\"login\":\"vk_18494863\",\"fio\":\"Тимур Шварцман\",\"birthDate\":\"01.04.1990 17:47:52 +0200\",\"avatar\":\"http://cs7003.vk.me/c625720/v625720863/31a3/2rn6VF4Fcc0.jpg\"},\"winnerPhotoDto\":{\"id\":133,\"url\":\"check_38_user_24.jpg\"},\"playersCount\":6},{\"id\":37,\"name\":\"Я танцую\",\"description\":\"Дэнсеры, вы готовы сразиться в танцевальном баттле?!\",\"startDate\":\"09.11.2014 18:00:00 +0600\",\"duration\":1,\"taskPhotoUrl\":\"task_37.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":17,\"login\":\"lisichka\",\"fio\":\"лисица алена\",\"city\":\"б\",\"avatar\":\"avatar__user_17.jpg\",\"email\":\"lisitza.alena@gmail.ru\"},\"userPhotoDto\":{\"url\":\"check_37_user_12.jpg\"},\"winnerPhotoDto\":{\"id\":126,\"url\":\"check_37_user_17.jpg\",\"commentsCount\":2},\"playersCount\":4},{\"id\":36,\"name\":\"Книголюб\",\"description\":\"Чтецы, делимся своими любимыми книгами\",\"startDate\":\"24.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_36.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":24,\"login\":\"vk_18494863\",\"fio\":\"Тимур Шварцман\",\"birthDate\":\"01.04.1990 17:47:52 +0200\",\"avatar\":\"http://cs7003.vk.me/c625720/v625720863/31a3/2rn6VF4Fcc0.jpg\"},\"winnerPhotoDto\":{\"id\":124,\"url\":\"check_36_user_24.jpg\"},\"playersCount\":2},{\"id\":35,\"name\":\"Четырёхглазый\",\"description\":\"Мне идут эти очки?\",\"startDate\":\"23.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_35.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":22,\"login\":\"Leta1\",\"fio\":\"Иванова Валерия\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_22.jpg\",\"email\":\"19vivanova@gmail.com\"},\"winnerPhotoDto\":{\"id\":122,\"url\":\"check_35_user_22.jpg\"},\"playersCount\":4},{\"id\":34,\"name\":\"Фильм ужасов\",\"description\":\"Камера! Мотор! Снимаем фильм ужасов!\",\"startDate\":\"22.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_34.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":9,\"login\":\"efiopskayaprincessa@gmail.com\",\"fio\":\"Маруся\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_9.jpg\",\"email\":\"efiopskayaprincessa@gmail.com\"},\"winnerPhotoDto\":{\"id\":117,\"url\":\"check_34_user_9.jpg\"},\"playersCount\":2},{\"id\":33,\"name\":\"Селфи-селфи\",\"description\":\"Кто-то делает селфи? Не упусти момент! Сделай селфи на фоне селфи!\",\"startDate\":\"21.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_33.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":5,\"login\":\"Betobet\",\"fio\":\"Виктор Игуменов\",\"birthDate\":\"11.10.1990 22:31:42 +0100\",\"avatar\":\"avatar__user_5.jpg\"},\"winnerPhotoDto\":{\"id\":116,\"url\":\"check_33_user_5.jpg\",\"commentsCount\":1},\"playersCount\":3},{\"id\":32,\"name\":\"Пятибалочка\",\"description\":\"Какой прекрасный день! Дай пять!\",\"startDate\":\"20.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_32.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":34,\"login\":\"facebook_100004439703624\",\"fio\":\"Alexandr  Golantsev Golantsev\",\"city\":\"Moscow, Russia\"},\"winnerPhotoDto\":{\"id\":113,\"url\":\"check_32_user_34.jpg\",\"commentsCount\":3},\"playersCount\":1},{\"id\":31,\"name\":\"Воздушный поцелуй\",\"description\":\"Котики, самое время передать приветы и воздушные поцелуи\",\"startDate\":\"19.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_31.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":17,\"login\":\"lisichka\",\"fio\":\"лисица алена\",\"city\":\"б\",\"avatar\":\"avatar__user_17.jpg\",\"email\":\"lisitza.alena@gmail.ru\"},\"winnerPhotoDto\":{\"id\":109,\"url\":\"check_31_user_17.jpg\",\"commentsCount\":2},\"playersCount\":4},{\"id\":30,\"name\":\"Врезался в стекло\",\"description\":\"Куда же ты, бедолага? Разве не видишь, там стекло!\",\"startDate\":\"18.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_30.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":5,\"login\":\"Betobet\",\"fio\":\"Виктор Игуменов\",\"birthDate\":\"11.10.1990 22:31:42 +0100\",\"avatar\":\"avatar__user_5.jpg\"},\"winnerPhotoDto\":{\"id\":106,\"url\":\"check_30_user_5.jpg\"},\"playersCount\":1},{\"id\":29,\"name\":\"Боевой раскрас\",\"description\":\"В этих суровых каменных джунглях выживает сильнейший. Пора сделать свой боевой раскрас!\",\"startDate\":\"17.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_29.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":27,\"login\":\"daniilgrechanyi@gmail.com\",\"avatar\":\"avatar_user_27_1412421770923.jpg\",\"email\":\"daniilgrechanyi@gmail.com\"},\"winnerPhotoDto\":{\"id\":105,\"url\":\"check_29_user_27.jpg\"},\"playersCount\":3},{\"id\":28,\"name\":\"Не трожь мою еду\",\"description\":\"Это моя еда! Убери свои руки! Кыш!\",\"startDate\":\"16.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_28.jpg\",\"voteDuration\":3},{\"id\":27,\"name\":\"НЕ следуй за мной\",\"description\":\"Hey! Stop \\\"follow me\\\"!\",\"startDate\":\"15.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_27.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":34,\"login\":\"facebook_100004439703624\",\"fio\":\"Alexandr  Golantsev Golantsev\",\"city\":\"Moscow, Russia\"},\"winnerPhotoDto\":{\"id\":99,\"url\":\"check_27_user_34.jpg\"},\"playersCount\":4},{\"id\":26,\"name\":\"Моя прелесть\",\"description\":\"Такое красивое, такое манящее. Моя прееелесть!\",\"startDate\":\"14.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_26.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":34,\"login\":\"facebook_100004439703624\",\"fio\":\"Alexandr  Golantsev Golantsev\",\"city\":\"Moscow, Russia\"},\"winnerPhotoDto\":{\"id\":94,\"url\":\"check_26_user_34.jpg\"},\"playersCount\":7},{\"id\":25,\"name\":\"Барабанщик\",\"description\":\"Ударники, зададим ритм нашей жизни! Стукнем в барабаны!\",\"startDate\":\"13.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_25.jpg\",\"voteDuration\":3},{\"id\":24,\"name\":\"Вкусняшки!\",\"description\":\"Сластёны, делимся вкусняшками!\",\"startDate\":\"12.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_24.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":33,\"login\":\"lana_pags\",\"fio\":\"Костюченко Светлана\",\"city\":\"Барнаул\",\"email\":\"lana_pags\"},\"winnerPhotoDto\":{\"id\":87,\"url\":\"check_24_user_33.jpg\"},\"playersCount\":5},{\"id\":23,\"name\":\"Зеваю\",\"description\":\"Зачем ты зевнул?! Всех заразил!\",\"startDate\":\"11.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_23.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":34,\"login\":\"facebook_100004439703624\",\"fio\":\"Alexandr  Golantsev Golantsev\",\"city\":\"Moscow, Russia\"},\"winnerPhotoDto\":{\"id\":86,\"url\":\"check_23_user_34.jpg\"},\"playersCount\":3},{\"id\":22,\"name\":\"Завал на работе\",\"description\":\"Ни конца, ни края работы не видать\",\"startDate\":\"10.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_22.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":27,\"login\":\"daniilgrechanyi@gmail.com\",\"avatar\":\"avatar_user_27_1412421770923.jpg\",\"email\":\"daniilgrechanyi@gmail.com\"},\"winnerPhotoDto\":{\"id\":81,\"url\":\"check_22_user_27.jpg\"},\"playersCount\":3},{\"id\":21,\"name\":\"Браслет\",\"description\":\"Смотри какой браслет! А какой носишь ты?\",\"startDate\":\"09.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_21.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":22,\"login\":\"Leta1\",\"fio\":\"Иванова Валерия\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_22.jpg\",\"email\":\"19vivanova@gmail.com\"},\"winnerPhotoDto\":{\"id\":79,\"url\":\"check_21_user_22.jpg\",\"commentsCount\":1},\"playersCount\":6},{\"id\":20,\"name\":\"Пустое место\",\"description\":\"Здесь кого-то не хватает. Фотографируем пустое место\",\"startDate\":\"08.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_20.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":34,\"login\":\"facebook_100004439703624\",\"fio\":\"Alexandr  Golantsev Golantsev\",\"city\":\"Moscow, Russia\"},\"winnerPhotoDto\":{\"id\":74,\"url\":\"check_20_user_34.jpg\",\"commentsCount\":2},\"playersCount\":5},{\"id\":19,\"name\":\"Кладоискатель\",\"description\":\"Кажется, где-то здесь клад... Ставим метку где он спрятан!\",\"startDate\":\"07.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_19.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":29,\"login\":\"vk_4251796\",\"fio\":\"Дмитрий Михеев\",\"city\":\"Барнаул\",\"birthDate\":\"14.05.1990 17:56:18 +0200\",\"avatar\":\"http://cs305503.vk.me/v305503796/7973/6cN88aFf9tc.jpg\",\"email\":\"wild1990@mail.ru\"},\"winnerPhotoDto\":{\"id\":68,\"url\":\"check_19_user_29.jpg\"},\"playersCount\":2},{\"id\":18,\"name\":\"Бородатое селфи\",\"description\":\"Что здесь ещё добавить?! Фотографируемся с бородой!\",\"startDate\":\"06.10.2014 07:00:00 +0200\",\"duration\":10,\"taskPhotoUrl\":\"task_18.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":9,\"login\":\"efiopskayaprincessa@gmail.com\",\"fio\":\"Маруся\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_9.jpg\",\"email\":\"efiopskayaprincessa@gmail.com\"},\"winnerPhotoDto\":{\"id\":65,\"url\":\"check_18_user_9.jpg\"},\"playersCount\":3},{\"id\":17,\"name\":\"Любимый фрукт\",\"description\":\"Яблоко или Ананас? Или что-нибудь ещё?.. А какой твой любимый фрукт?\",\"startDate\":\"05.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_17.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":29,\"login\":\"vk_4251796\",\"fio\":\"Дмитрий Михеев\",\"city\":\"Барнаул\",\"birthDate\":\"14.05.1990 17:56:18 +0200\",\"avatar\":\"http://cs305503.vk.me/v305503796/7973/6cN88aFf9tc.jpg\",\"email\":\"wild1990@mail.ru\"},\"winnerPhotoDto\":{\"id\":63,\"url\":\"check_17_user_29.jpg\"},\"playersCount\":3},{\"id\":16,\"name\":\"В прыжке\",\"description\":\"Попрыгунчики, пытаемся оторваться от земли и прыгаем, как можно выше!\",\"startDate\":\"04.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_16.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":22,\"login\":\"Leta1\",\"fio\":\"Иванова Валерия\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_22.jpg\",\"email\":\"19vivanova@gmail.com\"},\"winnerPhotoDto\":{\"id\":57,\"url\":\"check_16_user_22.jpg\"},\"playersCount\":5},{\"id\":15,\"name\":\"Как я провёл лето?\",\"description\":\"Итак дети, сочинение на тему: \\\"как я провёл лето\\\". Взяли телефоны в руки и фотографируем!\",\"startDate\":\"03.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_15.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":6,\"login\":\"agolantsev\",\"fio\":\"Александр Голанцев\",\"city\":\"барнаул\",\"birthDate\":\"17.11.1989 22:32:04 +0100\",\"avatar\":\"avatar_user_6_1414642220865.jpg\"},\"winnerPhotoDto\":{\"id\":48,\"url\":\"check_15_user_6.jpg\"},\"playersCount\":12},{\"id\":14,\"name\":\"Земля обезьян\",\"description\":\"Кинг Конги! Пора завязывать с эволюцией и вспомнить кем мы были!\",\"startDate\":\"02.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_14.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":27,\"login\":\"daniilgrechanyi@gmail.com\",\"avatar\":\"avatar_user_27_1412421770923.jpg\",\"email\":\"daniilgrechanyi@gmail.com\"},\"winnerPhotoDto\":{\"id\":44,\"url\":\"check_14_user_27.jpg\",\"commentsCount\":3},\"playersCount\":2},{\"id\":13,\"name\":\"Всеядный\",\"description\":\"Я так голоден, что съел бы даже это!\",\"startDate\":\"01.10.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_13.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":5,\"login\":\"Betobet\",\"fio\":\"Виктор Игуменов\",\"birthDate\":\"11.10.1990 22:31:42 +0100\",\"avatar\":\"avatar__user_5.jpg\"},\"winnerPhotoDto\":{\"id\":42,\"url\":\"check_13_user_5.jpg\",\"commentsCount\":4},\"playersCount\":4},{\"id\":12,\"name\":\"Кубок чемпиона\",\"description\":\"Чемпионы! Репетируем вручение Кубка!\",\"startDate\":\"30.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_12.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":5,\"login\":\"Betobet\",\"fio\":\"Виктор Игуменов\",\"birthDate\":\"11.10.1990 22:31:42 +0100\",\"avatar\":\"avatar__user_5.jpg\"},\"winnerPhotoDto\":{\"id\":37,\"url\":\"check_12_user_5.jpg\"},\"playersCount\":2},{\"id\":11,\"name\":\"Зубастик\",\"description\":\"Клац-клац! Такими зубами и удивить можно!\",\"startDate\":\"29.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_11.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":17,\"login\":\"lisichka\",\"fio\":\"лисица алена\",\"city\":\"б\",\"avatar\":\"avatar__user_17.jpg\",\"email\":\"lisitza.alena@gmail.ru\"},\"winnerPhotoDto\":{\"id\":36,\"url\":\"check_11_user_17.jpg\"},\"playersCount\":4},{\"id\":10,\"name\":\"Киллер\",\"description\":\"Леоны, берём в руки оружие! Если нет оружия, берём в руки руки\",\"startDate\":\"28.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_10.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":10,\"login\":\"vk_5600450\",\"fio\":\"Артём Ярманов\",\"birthDate\":\"02.02.1989 08:18:10 +0100\",\"avatar\":\"http://cs622120.vk.me/v622120450/11b3/x57LI-9ZOyo.jpg\"},\"winnerPhotoDto\":{\"id\":32,\"url\":\"check_10_user_10.jpg\"},\"playersCount\":1},{\"id\":9,\"name\":\"Маленькие радости жизни\",\"description\":\"Красавчики, сфотаем мелочи, которые нас радуют\",\"startDate\":\"27.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_9.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":7,\"login\":\"weeezg@gmail.com\",\"fio\":\"WeezQ\",\"about\":\"лал\",\"city\":\"барнаул\",\"avatar\":\"avatar__user_7.jpg\",\"email\":\"weeezg@gmail.com\"},\"winnerPhotoDto\":{\"id\":31,\"url\":\"check_9_user_7.jpg\"},\"playersCount\":5},{\"id\":8,\"name\":\"У нас есть печеньки!\",\"description\":\"Переходи на тёмную сторону! У нас есть печеньки!\",\"startDate\":\"26.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_8.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":6,\"login\":\"agolantsev\",\"fio\":\"Александр Голанцев\",\"city\":\"барнаул\",\"birthDate\":\"17.11.1989 22:32:04 +0100\",\"avatar\":\"avatar_user_6_1414642220865.jpg\"},\"winnerPhotoDto\":{\"id\":26,\"url\":\"check_8_user_6.jpg\"},\"playersCount\":3},{\"id\":7,\"name\":\"Носи усы\",\"description\":\"Всё просто, котаны: нарисуй себе усы!\",\"startDate\":\"25.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_7.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":17,\"login\":\"lisichka\",\"fio\":\"лисица алена\",\"city\":\"б\",\"avatar\":\"avatar__user_17.jpg\",\"email\":\"lisitza.alena@gmail.ru\"},\"winnerPhotoDto\":{\"id\":22,\"url\":\"check_7_user_17.jpg\"},\"playersCount\":2},{\"id\":6,\"name\":\"Необычное меню\",\"description\":\"Вот это салатик! Что, нет? Тогда удивись другому блюду!\",\"startDate\":\"24.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_6.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":6,\"login\":\"agolantsev\",\"fio\":\"Александр Голанцев\",\"city\":\"барнаул\",\"birthDate\":\"17.11.1989 22:32:04 +0100\",\"avatar\":\"avatar_user_6_1414642220865.jpg\"},\"winnerPhotoDto\":{\"id\":18,\"url\":\"check_6_user_6.jpg\"},\"playersCount\":4},{\"id\":5,\"name\":\"Вот это поворот!\",\"description\":\"Смотри-ка! Поворот!\",\"startDate\":\"23.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_5.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":20,\"login\":\"dgolantsev@gmail.com\",\"fio\":\"Morrgot\",\"city\":\"Moscow\",\"avatar\":\"avatar__user_20.jpg\",\"email\":\"dgolantsev@gmail.com\"},\"winnerPhotoDto\":{\"id\":17,\"url\":\"check_5_user_20.jpg\",\"commentsCount\":1},\"playersCount\":3},{\"id\":4,\"name\":\"Гримаса\",\"description\":\"Корчим рожи, господа! Кажем личиком изюм, али что похожее\",\"startDate\":\"22.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_4.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":9,\"login\":\"efiopskayaprincessa@gmail.com\",\"fio\":\"Маруся\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_9.jpg\",\"email\":\"efiopskayaprincessa@gmail.com\"},\"winnerPhotoDto\":{\"id\":14,\"url\":\"check_4_user_9.jpg\"},\"playersCount\":5},{\"id\":3,\"name\":\"Привет от Спока\",\"description\":\"Первый помощник капитана Спок, добро пожаловать на борт!\",\"startDate\":\"21.09.2014 07:00:00 +0200\",\"duration\":7,\"taskPhotoUrl\":\"task_3.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":6,\"login\":\"agolantsev\",\"fio\":\"Александр Голанцев\",\"city\":\"барнаул\",\"birthDate\":\"17.11.1989 22:32:04 +0100\",\"avatar\":\"avatar_user_6_1414642220865.jpg\"},\"winnerPhotoDto\":{\"id\":8,\"url\":\"check_3_user_6.jpg\",\"commentsCount\":1},\"playersCount\":3},{\"id\":2,\"name\":\"Выглядываем из укрытия\",\"description\":\"Опасность миновала?! Надо бы это проверить!\",\"startDate\":\"20.09.2014 07:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_2.jpg\",\"voteDuration\":3,\"winnerInfo\":{\"id\":9,\"login\":\"efiopskayaprincessa@gmail.com\",\"fio\":\"Маруся\",\"city\":\"Барнаул\",\"avatar\":\"avatar__user_9.jpg\",\"email\":\"efiopskayaprincessa@gmail.com\"},\"winnerPhotoDto\":{\"id\":6,\"url\":\"check_2_user_9.jpg\",\"commentsCount\":1},\"playersCount\":2},{\"id\":1,\"name\":\"Далеко гляжу\",\"description\":\"Фотографиремся с биноклем! Нет бинокля - включаем фантазию!\",\"startDate\":\"11.04.2015 16:10:00 +0600\",\"duration\":1,\"taskPhotoUrl\":\"task_1.jpg\",\"voteDuration\":9,\"playersCount\":4}]}";
	[self didGetChecksDEBUG: [str dataUsingEncoding: NSUTF8StringEncoding]];
#else
	[self startConnectionWithPath: kChecksPath type: URLConnectionTypeGET
							 body: nil
						  context: context
					allowMultiple: NO
				   finishSelector: @selector(didGetChecks:)
					 failSelector: @selector(didFailGetImportantData:)];
#endif
}

#pragma mark -

- (void) didGetChecksSearch: (URLConnection *) connection {
	NSArray *checks = nil;
	if (connection.error == nil) {
		checks = [_parser parseChecks: connection.downloadedData];
	}
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetChecksSearch:)] == YES) {
		[self.delegate dataProvider: self didGetChecksSearch: checks];
	}
}

- (void) checksSearch: (NSString *) inputData {
	[self startConnectionWithPath: kChecksPath
					  queryParams: @{@"search_text": inputData}
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetChecksSearch:) failSelector: @selector(didGetChecksSearch:)];
}

#pragma mark -

- (void) didGetCheck: (URLConnection *) connection {
	LGCheck *newCheckData = [_parser parseCheckData: connection.downloadedData];
	if ([connection.context isKindOfClass: [LGCheck class]] == YES) {
		LGCheck *check = connection.context;
		check.counters = newCheckData.counters;
		check.userPhoto = newCheckData.userPhoto;
		check.winnerPhoto = newCheckData.winnerPhoto;
	}
}

- (void) checkFor: (LGCheck *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksByUIDPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetCheck:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetCheckCurrent: (URLConnection *) connection {
	
}

- (void) checkCurrent {
	[self startConnectionWithPath: kChecksCurrentPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetCheckCurrent:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didCheckAddComment: (URLConnection *) connection {
	LGCommentAction *commentAction = connection.context;
	LGCheck *check = commentAction.context;
	[self checkCommentsFor: check.uid];
}

- (void) checkAddCommentFor: (LGCommentAction *) inputData {
	LGCheck *check = inputData.context;
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksCommentsPath, check.uid]
							 type: URLConnectionTypePOST
							 body: [inputData JSONObject]
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didCheckAddComment:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetCheckComments: (URLConnection *) connection {
	
}

- (void) checkCommentsFor: (int64_t) checkID {
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksCommentsPath, checkID]
							 type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetCheckComments:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didCheckAddPhoto: (URLConnection *) connection {
	[[AlertViewManager sharedManager] showAlertViewWithTitle: @"Отлично" andMessage: @"Ваше фото успешно загружено"];
	((LGCheck *)connection.context).currentPickedUserPhoto = nil;
	[self checkFor: connection.context];
}

- (void) checkAddPhoto: (LGCheck *) inputData {
	NSData *imageData = UIImageJPEGRepresentation(inputData.currentPickedUserPhoto, 0.7);
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksPhotosPath, inputData.uid]
						paramName: @"photo"
							 data: imageData
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didCheckAddPhoto:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetCheckPhotos: (URLConnection *) connection {
	NSArray *checkPhotos = [_parser parseCheckPhotos: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetCheckPhotos:)] == YES) {
		[self.delegate dataProvider: self didGetCheckPhotos: checkPhotos];
	}
}

- (void) checkPhotosFor: (int64_t) checkID {
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksPhotosPath, checkID]
							 type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetCheckPhotos:) failSelector: @selector(didFailGetImportantData:)];
}

- (void) didGetCheckVotePhotos: (URLConnection *) connection {
	LGVotePhotosResult *votePhotos = [_parser parseCheckVotePhotos: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetCheckVotePhotos:)] == YES) {
		[self.delegate dataProvider: self didGetCheckVotePhotos: votePhotos];
	}
}

- (void) didGetCheckVotePhotosDEBUG: (NSData *) data {
	//	{"resultCollection":[{"photoDto":{"id":140,"url":"check_42_user_9.jpg","user":{"id":9,"login":"efiopskayaprincessa@gmail.com","fio":"Маруся","avatar":"avatar__user_9.jpg"}},"shown":false,"voted":false},{"photoDto":{"id":141,"url":"check_42_user_34.jpg","user":{"id":34,"login":"facebook_100004439703624","fio":"Alexandr  Golantsev Golantsev"}},"shown":false,"voted":false}]}
	LGVotePhotosResult *votePhotos = [_parser parseCheckVotePhotos: data];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetCheckVotePhotos:)] == YES) {
		[self.delegate dataProvider: self didGetCheckVotePhotos: votePhotos];
	}
}

- (void) checkVotePhotosFor: (int64_t) checkID {
#ifdef USE_PREFETCHED_DATA
	NSString *str = @"{\"resultCollection\":[{\"photoDto\":{\"id\":140,\"url\":\"check_42_user_9.jpg\",\"user\":{\"id\":9,\"login\":\"efiopskayaprincessa@gmail.com\",\"fio\":\"Маруся\",\"avatar\":\"avatar__user_9.jpg\"}},\"shown\":false,\"voted\":false},{\"photoDto\":{\"id\":141,\"url\":\"check_42_user_34.jpg\",\"user\":{\"id\":34,\"login\":\"facebook_100004439703624\",\"fio\":\"Alexandr  Golantsev Golantsev\"}},\"shown\":false,\"voted\":false}]}";
	[self didGetCheckVotePhotosDEBUG: [str dataUsingEncoding: NSUTF8StringEncoding]];
#else
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksVotePhotosPath, checkID]
							 type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetCheckVotePhotos:) failSelector: @selector(didFailGetImportantData:)];
#endif
}

#pragma mark -

- (void) didGetSubscriptions: (URLConnection *) connection {
//	@"{"resultCollection":[{"userId":5,"userAvatar":"avatar_user_5_1416473789293.jpg","userLogin":"Betobet","fio":"Виктор Игуменов"},{"userId":6,"userAvatar":"avatar_user_6_1414642220865.jpg","userLogin":"agolantsev","fio":"Александр Голанцев","amISubscribed":false},{"userId":34,"userLogin":"facebook_100004439703624","fio":"Alexandr  Golantsev Golantsev","amISubscribed":false},{"userId":73,"userAvatar":"http://cs617222.vk.me/v617222915/1e8d3/u631-h4vAIo.jpg","userLogin":"vk_17015915","fio":"Александр Адаменко","amISubscribed":false},{"userId":24,"userAvatar":"avatar_user_24_1416515576367.jpg","userLogin":"vk_18494863","fio":"Onix","amISubscribed":false},{"userId":27,"userAvatar":"avatar_user_27_1412421770923.jpg","userLogin":"daniilgrechanyi@gmail.com","amISubscribed":false},{"userId":37,"userAvatar":"avatar_user_37_1415652595653.jpg","userLogin":"Miller","amISubscribed":false}]}"
	NSArray *subscriptions = [_parser parseSubscriptions: connection.downloadedData];
	
	LGSubscriptionsResult *result = [[LGSubscriptionsResult alloc] init];
	result.items = subscriptions;
	result.context = connection.context;
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetSubscriptions:)] == YES) {
		[self.delegate dataProvider: self didGetSubscriptions: result];
	}
}

- (void) checkUsersFor: (LGCheck *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksUsersPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark - Comment

- (void) didCommentRemove: (URLConnection *) connection {
	LGCommentAction *commentAction = connection.context;
	if ([commentAction.context isKindOfClass: [LGPhoto class]] == YES) {
		[self photoCommentsFor: commentAction.context];
	}
}

- (void) commentRemove: (LGCommentAction *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kCommentsPath, inputData.comment.uid]
							 type: URLConnectionTypeDELETE
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didCommentRemove:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark - Events

- (void) didGetEvents: (URLConnection *) connection {
	NSArray *events = [_parser parseEvents: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetEvents:)] == YES) {
		[self.delegate dataProvider: self didGetEvents: events];
	}
}

- (void) events {
	[self startConnectionWithPath: kEventsPath
					  queryParams: @{@"subscriptions": @"true"}
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetEvents:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark - News

- (void) didGetNews: (URLConnection *) connection {
	NSArray *news = [_parser parseEvents: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetNews:)] == YES) {
		[self.delegate dataProvider: self didGetNews: news];
	}
}

- (void) news {
	[self startConnectionWithPath: kEventsPath
					  queryParams: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetNews:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark - Photo

- (void) didGetPhotoComments: (URLConnection *) connection {
	NSArray *comments = nil;
	if (connection.error == nil) {
		comments = [_parser parseComments: connection.downloadedData];
	}
	ContextualArrayResult *result = [[ContextualArrayResult alloc] init];
	result.items = comments;
	result.context = connection.context;
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetComments:)] == YES) {
		[self.delegate dataProvider: self didGetComments: result];
	}
}

- (void) photoCommentsFor: (LGPhoto *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosCommentsPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotoComments:) failSelector: @selector(didGetPhotoComments:)];
}

- (void) didPhotoAddComment: (URLConnection *) connection {
	LGCommentAction *commentAction = connection.context;
	if ([commentAction.context isKindOfClass: [LGPhoto class]] == YES) {
		[self photoCommentsFor: commentAction.context];
	}
}

- (void) photoAddCommentFor: (LGCommentAction *) inputData {
	LGPhoto *photo = inputData.context;
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosCommentAddPath, photo.uid]
							 type: URLConnectionTypePOST
							 body: [inputData JSONObject]
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didPhotoAddComment:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didPhotoComplain: (URLConnection *) connection {
	
}

- (void) photoComplainFor: (LGPhoto *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosComplainPath, inputData.uid]
							 type: URLConnectionTypePOST
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didPhotoComplain:) failSelector: @selector(didPhotoComplain:)];
}

#pragma mark -

- (void) didGetPhotoCounters: (URLConnection *) connection {
	if (connection.error != nil) {
		return;
	}
	LGCounters *counters = [_parser parseCounters: connection.downloadedData];
	LGPhoto *photo = connection.context;
	photo.counters = counters;
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetPhotoWithCounters:)] == YES) {
		[self.delegate dataProvider: self didGetPhotoWithCounters: photo];
	}
}

- (void) photoCountersFor: (LGPhoto *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosCountersPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotoCounters:) failSelector: @selector(didGetPhotoCounters:)];
}

#pragma mark -

- (void) didGetPhotoVotes: (URLConnection *) connection {
	NSArray *votes = nil;
	if (connection.error == nil) {
		votes = [_parser parseSubscriptions: connection.downloadedData];
	}
	ContextualArrayResult *result = [[ContextualArrayResult alloc] init];
	result.items = votes;
	result.context = connection.context;
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetVotes:)] == YES) {
		[self.delegate dataProvider: self didGetVotes: result];
	}
}

- (void) photoVotesFor: (LGPhoto *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosVotesPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotoVotes:) failSelector: @selector(didGetPhotoVotes:)];
}

#pragma mark -

- (void) didPhotoVote: (URLConnection *) connection {
	if ([self.delegate respondsToSelector: @selector(dataProvider:didPhotoVote:)] == YES) {
		[self.delegate dataProvider: self didPhotoVote: connection.context];
	}
}

- (void) didPhotoVoteDEBUG: (id) context {
	if ([self.delegate respondsToSelector: @selector(dataProvider:didPhotoVote:)] == YES) {
		[self.delegate dataProvider: self didPhotoVote: context];
	}
}

- (void) photoVote: (LGVoteAction *) inputData {
#ifdef USE_PREFETCHED_DATA
	[self performSelector: @selector(didPhotoVoteDEBUG:) withObject: inputData afterDelay: 0.3];
#else
	[self startConnectionWithPath: kPhotosVotePath
							 type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didPhotoVote:) failSelector: @selector(didFailGetImportantData:)];
#endif
}

#pragma mark - User

- (void) didGetUsersSearch: (URLConnection *) connection {
	NSArray *users = nil;
	if (connection.error == nil) {
		users = [_parser parseSubscriptions: connection.downloadedData];
	}
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetUsersSearch:)] == YES) {
		[self.delegate dataProvider: self didGetUsersSearch: users];
	}
}

- (void) usersSearch: (NSString *) inputData {
	[self startConnectionWithPath: kUsersPath
					  queryParams: @{@"search_text": inputData}
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetUsersSearch:) failSelector: @selector(didGetUsersSearch:)];
}

#pragma mark -

- (void) didUserAvatarUpdate: (URLConnection *) connection {
	if ([self.delegate respondsToSelector: @selector(dataProviderDidUserAvatarUpdate:)] == YES) {
		[self.delegate dataProviderDidUserAvatarUpdate: self];
	}
}

- (void) didFailUserAvatarUpdate: (URLConnection *) connection {
	[self didFailGetImportantData: connection];
	
	if ([self.delegate respondsToSelector: @selector(dataProviderDidFailUserAvatarUpdate:)] == YES) {
		[self.delegate dataProviderDidFailUserAvatarUpdate: self];
	}
}

- (void) userAvatarUpdateWith: (NSData *) inputData {
	[self startConnectionWithPath: kUsersAvatarPath
						paramName: @"avatar"
							 data: inputData
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didUserAvatarUpdate:)
					 failSelector: @selector(didFailUserAvatarUpdate:)];
}

#pragma mark -

- (void) didLogin: (URLConnection *) connection {
	LGRegisterInfo *registerInfo = [_parser parseLoginInfo: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didRegisterUser:)] == YES) {
		[self.delegate dataProvider: self didRegisterUser: registerInfo];
	}
}

- (void) didFailLogin: (URLConnection *) connection {
	NSError *error = [self didFailGetImportantData: connection];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didFailRegisterUserWith:)] == YES) {
		[self.delegate dataProvider: self didFailRegisterUserWith: error];
	}
}

- (void) userLogin: (LGLoginInfo *) inputData {
	[self startConnectionWithPath: kUsersLoginPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didLogin:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetMainScreenInfo: (URLConnection *) connection {
	
}

- (void) userMainScreenInfo {
	[self startConnectionWithPath: kUsersMainScreenInfoPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetMainScreenInfo:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetPhotos: (URLConnection *) connection {
	NSArray *userPhotos = [_parser parseUserPhotos: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetUserPhotos:)] == YES) {
		[self.delegate dataProvider: self didGetUserPhotos: userPhotos];
	}
}

- (void) userPhotos {
	[self startConnectionWithPath: kUsersPhotosPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotos:)
					 failSelector: @selector(didFailGetImportantData:)];
}

- (void) userPhotosFor: (int32_t) userID {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersPhotosByUIDPath, userID]
							 type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotos:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetProfile: (URLConnection *) connection {
	LGUser *user = [_parser parseUserProfile: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetUserProfile:)] == YES) {
		[self.delegate dataProvider: self didGetUserProfile: user];
	}
}

- (void) userProfile {
	[self startConnectionWithPath: kUsersProfilePath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetProfile:) failSelector: @selector(didFailGetImportantData:)];
}

- (void) userProfileFor: (int32_t) userID {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersProfileByUIDPath, userID]
							 type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetProfile:)
					 failSelector: @selector(didFailGetImportantData:)];
}

- (void) didProfileUpdate: (URLConnection *) connection {
	LGUser *user = connection.context;
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didUserProfileUpdate:)] == YES) {
		[self.delegate dataProvider: self didUserProfileUpdate: user];
	}
}

- (void) userProfileUpdateWith: (LGUser *) inputData {
	[self startConnectionWithPath: kUsersProfilePath
							 type: URLConnectionTypePUT
							 body: [inputData JSONObject]
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didProfileUpdate:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didRecover: (URLConnection *) connection {
	if ([self.delegate respondsToSelector: @selector(dataProviderDidRecoverPass:)] == YES) {
		[self.delegate dataProviderDidRecoverPass: self];
	}
}

- (void) userRecover: (LGRecoverInfo *) inputData {
	[self startConnectionWithPath: kUsersRecoverPath type: URLConnectionTypePUT
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didRecover:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didUserAuth: (URLConnection *) connection {
	LGRegisterInfo *registerInfo = [_parser parseRegisterInfo: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didRegisterUser:)] == YES) {
		[self.delegate dataProvider: self didRegisterUser: registerInfo];
	}
}

- (void) didFailUserAuth: (URLConnection *) connection {
	NSError *error = [self didFailGetImportantData: connection];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didFailRegisterUserWith:)] == YES) {
		[self.delegate dataProvider: self didFailRegisterUserWith: error];
	}
}

- (void) userRegister: (LGLoginInfo *) inputData {
	[self startConnectionWithPath: kUsersRegisterPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didUserAuth:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) userSocialSignIn: (LGSocialInfo *) inputData {
	[self startConnectionWithPath: kUsersSocialSignInPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didUserAuth:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) userSubscribersFor: (LGUser *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscribersPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) userSubscribtionsFor: (LGUser *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscriptionsPath, inputData.uid]
							 type: URLConnectionTypeGET
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSubscribe: (URLConnection *) connection {
	if ([connection.context isKindOfClass: [LGSubscribe class]] == YES &&
		[self.delegate respondsToSelector: @selector(dataProvider:didUserSubscribeTo:)] == YES) {
		[self.delegate dataProvider: self didUserSubscribeTo: connection.context];
	}
}

- (void) userSubscribeTo: (LGSubscribe *) inputData {
	[self startConnectionWithPath: kUsersSubscriptionsAddPath
							 type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didSubscribe:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didUnsubscribe: (URLConnection *) connection {
	if ([connection.context isKindOfClass: [LGSubscribe class]] == YES &&
		[self.delegate respondsToSelector: @selector(dataProvider:didUserUnsubscribeFrom:)] == YES) {
		[self.delegate dataProvider: self didUserUnsubscribeFrom: connection.context];
	}
}

- (void) userUnsubscribeFrom: (LGSubscribe *) inputData {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscriptionsDeletePath,
									inputData.subscription.user.uid]
							 type: URLConnectionTypeDELETE
							 body: nil
						  context: inputData
					allowMultiple: NO
				   finishSelector: @selector(didUnsubscribe:) failSelector: @selector(didFailGetImportantData:)];
}

@end
