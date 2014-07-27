
@protocol JSONSerializableProtocol <NSObject>

@required
///Should return JSON serializable object
- (NSDictionary *) JSONObject;

@end
