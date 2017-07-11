// vim: set syntax=objcpp

#define PrefKeyCommon @"Common"

@interface PrefMaster : NSObject {
  NSString* _prefFilePath;
}
-(id) initWithBundleId:NSString;

@property(nonatomic, strong) NSMutableDictionary *prefrences;
@property(nonatomic, strong) NSString *bundleId;
@property(nonatomic, strong) NSMutableDictionary* allPrefs;
@property(nonatomic) BOOL writePending;

-(void) readAllPrefs;
-(void) writeIfPending;
-(NSDictionary*) safeGetDictForKey:(id)key;
@end
