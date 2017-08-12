#import "SharedSettings.h"

%group BetterShare

@interface TGGenericModernConversationCompanion
-(int64_t)conversationId;
@end

@interface TGModernConversationController
@property (nonatomic, strong) TGGenericModernConversationCompanion *companion;
@end

static inline bool TGPeerIdIsChannel(int64_t peerId) {
    return peerId <= ((int64_t)INT32_MIN) * 2 && peerId > ((int64_t)INT32_MIN) * 3;
}

%hook TGModernConversationController
-(void)forwardMessages:(NSArray *)messageIds fastForward:(bool)fastForward {
  bool channelOverriden = false;
  
  if (messageIds.count == 1) fastForward = true;

  if (fastForward) {
    int64_t conversationId = self.companion.conversationId;
    if (TGPeerIdIsChannel(conversationId) &&
        !MSHookIvar<bool>(self, "_isChannel"))
    {
      MSHookIvar<bool>(self, "_isChannel") = true;
      channelOverriden = true;
    }
  }

  %orig;

  if (channelOverriden) MSHookIvar<bool>(self, "_isChannel") = false;
}
%end

%end

%ctor {
  TelenhancerSettings *settings = [TelenhancerSettings sharedInstance];

  [settings
    addGroup:@"BetterShare"
    withDefaultSetting: [TelenhancerSetting
      createWithLabel: @"Better Share Button"
      description: @"- Force \"Fast Share\" if one message is selected\n"
                    "- Allow \"Copy Link\" in public supergroups"
      preferences: nil
      isEnabled: NO
    ]];

  if ([settings settingForGroup:@"BetterShare"].enabled) 
    %init(BetterShare);
}
