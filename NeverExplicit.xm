#import "SharedSettings.h"

%group NeverExplicit

%hook TGUser
- (bool)hasExplicitContent {
  return false;
}
%end

%hook TGConversation
- (bool)hasExplicitContent {
  return false;
}
%end

%end

%ctor {
  TelenhancerSettings *settings = [TelenhancerSettings sharedInstance];

  [settings
    addGroup:@"NeverExplicit"
    withDefaultSetting: [[TelenhancerSetting alloc]
      initWithLabel: @"NeverExplicit"
      description: @"Unrestrict all bots and channels"
      andPreferences: nil
    ]];

  //%log("Added group NeverExplicit");
  if ([settings settingForGroup:@"NeverExplicit"].enabled) 
    %init(NeverExplicit);
}
