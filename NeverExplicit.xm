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
    withDefaultSetting: [TelenhancerSetting
      createWithLabel: @"NeverExplicit"
      description: @"Unrestrict all bots and channels"
      preferences: nil
      isEnabled: NO
    ]];

  if ([settings settingForGroup:@"NeverExplicit"].enabled) 
    %init(NeverExplicit);
}
