#import "SharedSettings.h"

%group NeverExplicit

#define fix(CLS)\
  %hook CLS\
    - (bool)hasExplicitContent {\
      return false;\
  }\
  %end

fix(TGUser);
fix(TGConversation);

%end

static BOOL shouldLoadNeverExplicit(TelenhancerSettings* settings) {
  [settings
    addGroup:@"NeverExplicit"
    withDefaultSetting: [[TelenhancerSetting alloc]
      initWithLabel: @"NeverExplicit"
      description: @"Unrestrict all bots and channels"
      andPreferences: nil
    ]];

  return [settings settingForGroup:@"NeverExplicit"].enabled;
}
