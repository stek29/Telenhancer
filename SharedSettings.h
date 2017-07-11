@interface TelenhancerSetting : NSObject<NSCoding>
@property(strong, nonatomic) NSString *label;
@property(strong, nonatomic) NSString *sDescription;
@property(strong, nonatomic) NSMutableDictionary *preferences;
@property(nonatomic) BOOL enabled;
-(instancetype) initWithLabel:(NSString*)l description:(NSString*)d andPreferences:(NSMutableDictionary*)p;
-(void)applyDefault:(TelenhancerSetting*)d;
@end

@interface TelenhancerSettings : NSObject {
  NSMutableDictionary *_prefs;
}
+(instancetype) sharedInstance;
-(void) addGroup:(NSString*)g withDefaultSetting:(TelenhancerSetting*)s;
-(TelenhancerSetting*) settingForGroup:(NSString*)s;
@end
