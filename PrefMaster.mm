#include "PrefMaster.h"

NSMutableDictionary *allPrefs = nil;

@implementation PrefMaster

-(id) initWithBundleId:(NSString*)bId {
  self = [super init];
  if (self) {
    self.bundleId = bId; 
    
    _prefFilePath = [NSHomeDirectory()
    stringByAppendingFormat:@"/Library/Preferences/%s.plist",
      "rocks.stek29.telenhancer"];

    [self readAllPrefs];
    
    self.prefrences = [[NSMutableDictionary alloc]
      initWithDictionary:[self safeGetDictForKey:PrefKeyCommon]];
    [self.prefrences addEntriesFromDictionary:[self safeGetDictForKey:self.bundleId]];
   
    [self writeIfPending];
  }
  return self;
}

-(void) readAllPrefs {
    if ([[NSFileManager defaultManager] fileExistsAtPath:_prefFilePath]) {
    allPrefs = [[NSMutableDictionary alloc] 
      initWithContentsOfFile:_prefFilePath];
  } else {
    allPrefs = [[NSMutableDictionary alloc] init];
    self.writePending = YES;
  }
}

-(NSDictionary*) safeGetDictForKey:(id) key {
  id dict = [self.allPrefs objectForKey:key];

  if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
    dict = [[NSDictionary alloc] init]; 
    [allPrefs setObject:dict forKey:key];
    self.writePending = YES;
  }

  return dict;
}

-(void) writeIfPending {
  if (self.writePending) {
    self.writePending = NO;
  }
}

@end
