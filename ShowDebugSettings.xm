#import "SharedSettings.h"
#import "TGHeaders/TGCollectionItems.h"
#import "TGHeaders/TGCollectionMenus.h"
#import "TGHeaders/TGAccountSettingsController.h"

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

%ctor {
  TelenhancerSettings *settings = [TelenhancerSettings sharedInstance];

  [settings
    addGroup:@"ShowDebugSettings"
    withDefaultSetting: [TelenhancerSetting
      createWithLabel: @"Show Debug Settings"
      description: nil
      preferences: nil
      isEnabled: NO
    ]];

  if ([settings settingForGroup:@"ShowDebugSettings"].enabled)
    %init(ShowDebugSettings);
}
