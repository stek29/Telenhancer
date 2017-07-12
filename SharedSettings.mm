#include "SharedSettings.h"

@implementation TelenhancerSetting

-(instancetype) initWithLabel:(NSString*)lbl description:(NSString*)desc andPreferences:(NSMutableDictionary*)prefs {
  self = [self init];

  if (self) {
    self.label = lbl;
    self.sDescription = desc;
    self.preferences = prefs;
    self.enabled = NO;
  }

  return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];

    if (self) {
      self.label = [decoder decodeObjectForKey:@"label"];
      self.sDescription = [decoder decodeObjectForKey:@"description"];
      self.preferences = [decoder decodeObjectForKey:@"preferences"];
      self.enabled = [(NSNumber*)[decoder decodeObjectForKey:@"enabled"] boolValue];
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.label forKey:@"label"];
  [encoder encodeObject:self.sDescription forKey:@"description"];
  [encoder encodeObject:self.preferences forKey:@"preferences"];
  [encoder encodeObject:[NSNumber numberWithBool:self.enabled] forKey:@"enabled"];
}

-(void)applyDefault:(TelenhancerSetting*)def {
  self.label = def.label;
  self.sDescription = def.sDescription;
  NSMutableDictionary* defPrefs = [def.preferences copy];
  for (id key in defPrefs) {
    id old = [self.preferences objectForKey:key];
    if (old && [old isMemberOfClass:[[defPrefs objectForKey:key] class]]) {
      [defPrefs setObject:old forKey:key];
    }
  }
  self.preferences = defPrefs;
}

@end

@implementation TelenhancerSettings

+(instancetype) sharedInstance {
  static TelenhancerSettings *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[TelenhancerSettings alloc] init];
    sharedInstance->allSettings = [[NSMutableDictionary alloc] init];
  });
  return sharedInstance;
}

-(NSArray*) allGroups {
  return [allSettings allKeys];
}

-(void) addGroup:(NSString*)groupName withDefaultSetting:(TelenhancerSetting*)setting {
  id current = [allSettings objectForKey:groupName];
  if ([current isKindOfClass:[TelenhancerSetting class]]) {
    [current applyDefault:setting];
  } else {
    [allSettings setObject:setting forKey:groupName];
  }
}

-(TelenhancerSetting*) settingForGroup:(NSString*)groupName {
  id ret = [allSettings objectForKey:groupName];
  if (![ret isKindOfClass:[TelenhancerSetting class]]) {
    return nil;
  } else {
    return ret;
  }
}

@end
