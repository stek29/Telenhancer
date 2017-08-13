#import "SharedSettings.h"
#import "TGHeaders/TGCollectionItems.h"
#import "TGHeaders/TGCollectionMenus.h"
#import "TGHeaders/TGAccountSettingsController.h"
#import "TGHeaders/TGAlertView.h"
#import "TGHeaders/TGAppDelegate.h"

%group ShowDebugSettings
%hook TGAccountSettingsController
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  %orig;

  if (editing) {
    [self.menuSections beginRecordingChanges];

    // Check if "Debug Settings" is already drawn and delete it if yes
    id lastSection = [self.menuSections.sections lastObject];
    if ([lastSection isKindOfClass:%c(TGCollectionMenuSection)]) {
      id lastItem = [((TGCollectionMenuSection *) lastSection).items lastObject];
      if ([lastItem isKindOfClass:%c(TGButtonCollectionItem)]) {
        if (((TGButtonCollectionItem*) lastItem).action == @selector(mySettingsPressed)) {
          [self.menuSections
            deleteItemFromSection:self.menuSections.sections.count - 1
            atIndex:((TGCollectionMenuSection*)lastSection).items.count - 1];
        }
      }
    }

    TGButtonCollectionItem *debugSettingsItem = [
      [%c(TGButtonCollectionItem) alloc]
        initWithTitle:@"Debug Settings"
        action:@selector(mySettingsPressed)];
    debugSettingsItem.alignment = NSTextAlignmentCenter;
    debugSettingsItem.deselectAutomatically = true;

    [self.menuSections
      addItemToSection:self.menuSections.sections.count - 1
      item:debugSettingsItem];

    if (![self.menuSections commitRecordedChanges:self.collectionView]) {
      [self _resetCollectionView];
    }
  }
}
%end
%end

%group SwitchDC

@interface TGTelegramNetworking : NSObject
+(instancetype) instance;
-(void) switchBackends;
@end

%hook TGLoginPhoneController
-(void)updatePhoneTextForCountryFieldText:(NSString *) countryCodeText {
  if ([countryCodeText isEqualToString:@"+0"]) {
    TGAlertView *alert = [%c(TGAlertView) alloc];
    alert = [alert
      initWithTitle:@"Switch DC"
      message:[NSString
        stringWithFormat:@"Switch to %@ DC?",
          TGAppDelegateInstance().useDifferentBackend ? @"test" : @"main"]
      cancelButtonTitle:@"No"
      okButtonTitle:@"Yes"
      completionBlock:^void (bool ok) {
        if (ok) {
          // Marked as "lagacy" in sources!
          [(TGTelegramNetworking*)[%c(TGTelegramNetworking) instance] switchBackends];
        }
      }];
    [alert show];
  } else {
    %orig;
  }
}
%end
%end

%ctor {
  TelenhancerSettings *settings = [TelenhancerSettings sharedInstance];

  [settings
    addGroup:@"InternalSettings"
    withDefaultSetting: [TelenhancerSetting
      createWithLabel: @"Internal Debug Settings"
      description: @"- \"Show Debug Settings\" under \"Log Out\" button\n"
                    "- Enter \"+0\" country code to switch backend"
      preferences: nil
      isEnabled: YES
    ]];

  if ([settings settingForGroup:@"InternalSettings"].enabled) {
    %init(ShowDebugSettings);
    %init(SwitchDC);
  }
}
