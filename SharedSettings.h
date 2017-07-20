@interface TelenhancerSetting : NSObject<NSCoding>
@property(strong, nonatomic) NSString *label;
@property(strong, nonatomic) NSString *sDescription;
@property(strong, nonatomic) NSMutableDictionary *preferences;
@property(nonatomic) BOOL enabled;
+(instancetype) createWithLabel:(NSString*)l description:(NSString*)d preferences:(NSMutableDictionary*)p isEnabled:(BOOL)e;
-(void)applyDefault:(TelenhancerSetting*)d;
@end

@interface TelenhancerSettings : NSObject {
  NSMutableDictionary *allSettings;
  NSMutableSet *allGroups;
}
+(instancetype) sharedInstance;
-(NSArray*) allGroups;
-(void) saveToUserDefaults;
-(void) addGroup:(NSString*)g withDefaultSetting:(TelenhancerSetting*)s;
-(TelenhancerSetting*) settingForGroup:(NSString*)s;
@end
