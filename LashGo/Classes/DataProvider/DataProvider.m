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
#import "JSONParser.h"
#import "URLConnectionManager.h"

#define kWebServiceURL @"http://78.47.39.245:8080/lashgo-api"
#define kWebServicePhotoPath @"/photos/"

#define kChecksPath			@"/checks" //POST
#define kChecksCurrentPath	@"/checks/current" //GET
#define kChecksCommentsPath	@"/checks/%lld/comments" //GET, POST
#define kChecksPhotosPath	@"/checks/%lld/photos" //GET, POST
#define kChecksVotePhotosPath	@"/checks/%lld/vote/photos" //GET

#define kCommentsPath @"/comments/%lld" //DELETE

#define kPhotosPath			@"/photos/%@" //GET
#define kPhotosCommentsPath	@"/photos/%lld/comments" //GET, POST
#define kPhotosVotePath		@"/photos/%lld/vote" //PUT

#define kUsersLoginPath				@"/users/login" //POST
#define kUsersMainScreenInfoPath	@"/users/main-screen-info" //GET
#define kUsersPhotosPath			@"/users/photos" //GET
#define kUsersPhotosByUIDPath		@"/users/%d/photos" //GET
#define kUsersProfilePath			@"/users/profile" //GET
#define kUsersRecoverPath			@"/users/recover" //PUT
#define kUsersRegisterPath			@"/users/register" //POST
#define kUsersSocialSignInPath		@"/users/social-sign-in" //POST
#define kUsersSocialSignUpPath		@"/users/social-sign-up" //POST
#define kUsersSubscriptionsPath			@"/users/subscriptions" //GET
#define kUsersSubscriptionsManagePath	@"/users/subscriptions/%d" //DELETE, POST

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
							type: (URLConnectionType) theType
							body: (NSDictionary *) bodyJSON
						 context: (id) context
				   allowMultiple: (BOOL) allowMultiple
				  finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	@synchronized (self) {
		NSString *connectionKey = [[kWebServiceURL stringByAppendingString: path] stringByAppendingFormat: @"%d", theType];
		
		if (allowMultiple == NO) {
			URLConnection *liveConnection = _liveConnections[connectionKey];
			if (liveConnection.status == URLConnectionStatusStarted) {
				return;
			}
		}
		NSMutableDictionary *headerParamsDictionary = [self dictionaryWithHeaderParams];
		URLConnection *connection = [_connectionManager connectionWithHost: kWebServiceURL
																	 path: path
															  queryParams: nil
															 headerParams: headerParamsDictionary
																	 body: bodyJSON
																	 type: theType
																   target: self
														   finishSelector: finishSelector
															 failSelector: failSelector];
		connection.context = context;
		
		if (allowMultiple == NO) {
			_liveConnections[connectionKey] = connection;
		}
		
		[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: YES];
		[connection startAsync];
	}
}

- (NSError *) didFailGetImportantData: (URLConnection *) connection {
	NSError *error = [_parser parseError: connection];
	
	[[AlertViewManager sharedManager] showAlertViewWithError: error];
	
	return error;
}

#pragma mark - Checks

- (void) didGetChecks: (URLConnection *) connection {
	NSArray *checks = [_parser parseChecks: connection.downloadedData];

	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetChecks:)] == YES) {
		[self.delegate dataProvider: self didGetChecks: checks];
	}
}

- (void) didGetChecksDEBUG: (NSData *) data {
	NSArray *checks = [_parser parseChecks: data];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetChecks:)] == YES) {
		[self.delegate dataProvider: self didGetChecks: checks];
	}
}

- (void) checks {
#ifdef DEBUG
	NSString *str = @"{\"resultCollection\":[{\"id\":19,\"name\":\"Кладоискатель\",\"description\":\"Кажется, где-то здесь клад... Ставим метку где он спрятан!\",\"startDate\":\"18.10.2014 20:00:00 +0700\",\"duration\":1,\"taskPhotoUrl\":\"task_19.jpg\",\"voteDuration\":3},{\"id\":18,\"name\":\"Бородатое селфи\",\"description\":\"Что здесь ещё добавить?! Фотографируемся с бородой!\",\"startDate\":\"18.10.2014 19:00:00 +0700\",\"duration\":1,\"taskPhotoUrl\":\"task_18.jpg\",\"voteDuration\":3},{\"id\":17,\"name\":\"Любимый фрукт\",\"description\":\"Яблоко или Ананас? Или что-нибудь ещё?.. А какой твой любимый фрукт?\",\"startDate\":\"10.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_17.jpg\",\"voteDuration\":3},{\"id\":16,\"name\":\"В прыжке\",\"description\":\"Попрыгунчики, пытаемся оторваться от земли и прыгаем, как можно выше!\",\"startDate\":\"09.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_16.jpg\",\"voteDuration\":3},{\"id\":15,\"name\":\"Как я провёл лето?\",\"description\":\"Итак дети, сочинение на тему: \\\"как я провёл лето\\\". Взяли телефоны в руки и фотографируем!\",\"startDate\":\"27.09.2014 20:00:00 +0700\",\"duration\":1,\"taskPhotoUrl\":\"task_15.jpg\",\"voteDuration\":3},{\"id\":14,\"name\":\"Земля обезьян\",\"description\":\"Кинг Конги! Пора завязывать с эволюцией и вспомнить кем мы были!\",\"startDate\":\"07.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_14.jpg\",\"voteDuration\":3},{\"id\":13,\"name\":\"Всеядный\",\"description\":\"Я так голоден, что съел бы даже это!\",\"startDate\":\"06.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_13.jpg\",\"voteDuration\":3},{\"id\":12,\"name\":\"Кубок чемпиона\",\"description\":\"Чемпионы! Репетируем вручение Кубка!\",\"startDate\":\"05.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_12.jpg\",\"voteDuration\":3},{\"id\":11,\"name\":\"Зубастик\",\"description\":\"Клац-клац! Такими зубами и удивить можно!\",\"startDate\":\"04.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_11.jpg\",\"voteDuration\":3},{\"id\":10,\"name\":\"Киллер\",\"description\":\"Леоны, берём в руки оружие! Если нет оружия, берём в руки руки\",\"startDate\":\"03.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_10.jpg\",\"voteDuration\":3},{\"id\":9,\"name\":\"Маленькие радости жизни\",\"description\":\"Красавчики, сфотаем мелочи, которые нас радуют\",\"startDate\":\"02.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_9.jpg\",\"voteDuration\":3},{\"id\":8,\"name\":\"У нас есть печеньки!\",\"description\":\"Переходи на тёмную сторону! У нас есть печеньки!\",\"startDate\":\"01.09.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_8.jpg\",\"voteDuration\":3},{\"id\":7,\"name\":\"Носи усы\",\"description\":\"Всё просто, котаны: нарисуй себе усы!\",\"startDate\":\"31.08.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_7.jpg\",\"voteDuration\":3},{\"id\":6,\"name\":\"Необычное меню\",\"description\":\"Вот это салатик! Что, нет? Тогда удивись другому блюду!\",\"startDate\":\"30.08.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_6.jpg\",\"voteDuration\":3},{\"id\":5,\"name\":\"Вот это поворот!\",\"description\":\"Смотри-ка! Поворот!\",\"startDate\":\"29.08.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_5.jpg\",\"voteDuration\":3},{\"id\":4,\"name\":\"Гримаса\",\"description\":\"Корчим рожи, господа! Кажем личиком изюм, али что похожее\",\"startDate\":\"28.08.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_4.jpg\",\"voteDuration\":3},{\"id\":3,\"name\":\"Привет от Спока\",\"description\":\"Первый помощник капитана Спок, добро пожаловать на борт!\",\"startDate\":\"27.08.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_3.jpg\",\"voteDuration\":3},{\"id\":2,\"name\":\"Выглядываем из укрытия\",\"description\":\"Опасность миновала?! Надо бы это проверить!\",\"startDate\":\"26.08.2014 12:00:00 +0200\",\"duration\":1,\"taskPhotoUrl\":\"task_2.jpg\",\"voteDuration\":3},{\"id\":1,\"name\":\"Далеко гляжу\",\"description\":\"Фотографиремся с биноклем! Нет бинокля - включаем фантазию!\",\"startDate\":\"01.10.2014 20:00:00 +0700\",\"duration\":1,\"taskPhotoUrl\":\"task_1.jpg\",\"voteDuration\":3}]}";
	[self didGetChecksDEBUG: [str dataUsingEncoding: NSUTF8StringEncoding]];
#else
	[self startConnectionWithPath: kChecksPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetChecks:)
					 failSelector: @selector(didFailGetImportantData:)];
#endif
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
	
}

- (void) checkAddCommentFor: (int64_t) checkID {
	[self startConnectionWithPath: [NSString stringWithFormat: kChecksCommentsPath, checkID]
							 type: URLConnectionTypePOST
							 body: nil
						  context: nil
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

- (void) didGetCheckPhotos: (URLConnection *) connection {
	
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
	NSArray *votePhotos = [_parser parseCheckVotePhotos: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetCheckVotePhotos:)] == YES) {
		[self.delegate dataProvider: self didGetCheckVotePhotos: votePhotos];
	}
}

- (void) didGetCheckVotePhotosDEBUG: (NSData *) data {
	//	{"result":{"votePhotoList":[{"id":1,"url":"check_1_user_3.jpg","user":{"id":3,"login":"eugene.petriyov","fio":"Петриёв Евгений Игоревич","avatar":"avatar__user_3.jpg"}},{"id":2,"url":"check_1_user_5.jpg","user":{"id":5,"login":"Betobet","fio":"Виктор Игуменов","avatar":"avatar__user_5.jpg"}},{"id":3,"url":"check_1_user_6.jpg","user":{"id":6,"login":"vk_1946879","fio":"Александр Голанцев","avatar":"http://cs617528.vk.me/v617528879/a121/y9dwApgo_fs.jpg"}},{"id":4,"url":"check_1_user_8.jpg","user":{"id":8,"login":"idark21.89@gmail.com","fio":"Ярманов Артем Игоревич"}}]}}
	NSArray *votePhotos = [_parser parseCheckVotePhotos: data];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didGetCheckVotePhotos:)] == YES) {
		[self.delegate dataProvider: self didGetCheckVotePhotos: votePhotos];
	}
}

- (void) checkVotePhotosFor: (int64_t) checkID {
#ifdef DEBUG
	NSString *str = @"{\"result\":{\"votePhotoList\":[{\"id\":1,\"url\":\"check_1_user_3.jpg\",\"user\":{\"id\":3,\"login\":\"eugene.petriyov\",\"fio\":\"Петриёв Евгений Игоревич\",\"avatar\":\"avatar__user_3.jpg\"}},{\"id\":2,\"url\":\"check_1_user_5.jpg\",\"user\":{\"id\":5,\"login\":\"Betobet\",\"fio\":\"Виктор Игуменов\",\"avatar\":\"avatar__user_5.jpg\"}},{\"id\":3,\"url\":\"check_1_user_6.jpg\",\"user\":{\"id\":6,\"login\":\"vk_1946879\",\"fio\":\"Александр Голанцев\",\"avatar\":\"http://cs617528.vk.me/v617528879/a121/y9dwApgo_fs.jpg\"}},{\"id\":4,\"url\":\"check_1_user_8.jpg\",\"user\":{\"id\":8,\"login\":\"idark21.89@gmail.com\",\"fio\":\"Ярманов Артем Игоревич\"}}]}}";
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

#pragma mark - Comment

- (void) didCommentRemove: (URLConnection *) connection {
	
}

- (void) commentRemove: (int64_t) commentID {
	[self startConnectionWithPath: [NSString stringWithFormat: kCommentsPath, commentID]
							 type: URLConnectionTypeDELETE
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didCommentRemove:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark - Photo

- (void) didGetPhotoComments: (URLConnection *) connection {
	
}

- (void) photoCommentsFor: (int64_t) photoID {
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosCommentsPath, photoID]
							 type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotoComments:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didPhotoVote: (URLConnection *) connection {
	
}

- (void) photoVoteFor: (int64_t) photoID {
	[self startConnectionWithPath: [NSString stringWithFormat: kPhotosVotePath, photoID]
							 type: URLConnectionTypePUT
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didPhotoVote:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark - User

- (void) didLogin: (URLConnection *) connection {
	LGRegisterInfo *registerInfo = [_parser parseRegiserInfo: connection.downloadedData];
	
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
	
}

- (void) userProfile {
	[self startConnectionWithPath: kUsersProfilePath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetProfile:) failSelector: @selector(didFailGetImportantData:)];
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

- (void) didRegisterUser: (URLConnection *) connection {
	LGRegisterInfo *registerInfo = [_parser parseRegiserInfo: connection.downloadedData];
	
	if ([self.delegate respondsToSelector: @selector(dataProvider:didRegisterUser:)] == YES) {
		[self.delegate dataProvider: self didRegisterUser: registerInfo];
	}
}

- (void) didFailRegisterUser: (URLConnection *) connection {
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
				   finishSelector: @selector(didRegisterUser:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSocialSignIn: (URLConnection *) connection {
	
}

- (void) userSocialSignIn: (LGSocialInfo *) inputData {
	[self startConnectionWithPath: kUsersSocialSignInPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didSocialSignIn:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSocialSignUp: (URLConnection *) connection {
	
}

- (void) userSocialSignUp: (LGSocialInfo *) inputData {
	[self startConnectionWithPath: kUsersRegisterPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didSocialSignUp:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSubscribe: (URLConnection *) connection {
	
}

- (void) userSubscribeTo: (int32_t) userID {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscriptionsManagePath, userID]
							 type: URLConnectionTypePOST
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didSubscribe:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetSubscriptions: (URLConnection *) connection {
	
}

- (void) userSubscriptions {
	[self startConnectionWithPath: kUsersSubscriptionsPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didUnsubscribe: (URLConnection *) connection {
	
}

- (void) userUnsubscribeFrom: (int32_t) userID {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscriptionsManagePath, userID]
							 type: URLConnectionTypeDELETE
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:) failSelector: @selector(didFailGetImportantData:)];
}

@end
