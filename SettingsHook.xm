#include "SharedSettings.h"

@interface TGRootController
-(void)pushContentController:(UIViewController *)contentController;
@end

@interface TGAppDelegate : NSObject
@property (nonatomic, strong) TGRootController *rootController;
@end

@interface TGCollectionItem : NSObject
@end

@interface TGSwitchCollectionItem : TGCollectionItem
@property (nonatomic, copy) void (^toggled)(bool value, TGSwitchCollectionItem *item);
-(instancetype)initWithTitle:(NSString *)title isOn:(bool)isOn;
@end

@interface TGCollectionStaticMultilineTextItem : TGCollectionItem
@property (nonatomic, strong) NSString *text;
@end

@interface TGCollectionMenuSection : NSObject
-(instancetype)initWithItems:(NSArray *)items;
@end

@interface TGCollectionMenuSectionList : NSObject
-(void)addSection:(TGCollectionMenuSection *)section;
@end

@protocol iHateLogos_TGCollectionMenuController
@property (nonatomic, strong) TGCollectionMenuSectionList *menuSections;
@end

static TGAppDelegate *TGAppDelegateInstance = nil;

%group SettingsHook

%subclass TESettingsController : TGCollectionMenuController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
-(instancetype) init {
  self = %orig;
  %log(@"TESettingsController init");  
  if (self) {
    TelenhancerSettings *settings = [TelenhancerSettings sharedInstance];

    for (NSString* group in [settings allGroups]) {
      TelenhancerSetting *setting = [settings settingForGroup:group];
      NSMutableArray *items = [NSMutableArray array];
      TGSwitchCollectionItem *enabledItem = [[%c(TGSwitchCollectionItem) alloc] initWithTitle:setting.label isOn:setting.enabled];
      enabledItem.toggled = ^(bool enabled, __unused TGSwitchCollectionItem *item) {
        setting.enabled = enabled;
      };
      [items addObject:enabledItem];
      if (setting.sDescription) {
        TGCollectionStaticMultilineTextItem *descriptionItem = [[%c(TGCollectionStaticMultilineTextItem) alloc] init];
        descriptionItem.text = setting.sDescription;
        [items addObject:descriptionItem];
      }
      if (setting.preferences) {
        %log(@"TODO: setting prefrences in SettingsHook");
      }
      TGCollectionMenuSection *section = [%c(TGCollectionMenuSection) alloc];
      section = [section initWithItems:items];
      [((id<iHateLogos_TGCollectionMenuController>) self).menuSections addSection:section];
    }
  }

  return self;
}
%end

%hook TGMainTabsController
-(void)tabBarSelectedItem:(int)idx{
  %orig;
  // Tapped two or more times on settings and then on contacts
  if (idx == 0 && MSHookIvar<int>(self, "_tapsInSuccession") != 0) {
    if (TGAppDelegateInstance == nil) {
      TGAppDelegateInstance = [[UIApplication sharedApplication] delegate];
    }
    [TGAppDelegateInstance.rootController pushContentController:[[%c(TESettingsController) alloc] init]];
    MSHookIvar<int>(self, "_tapsInSuccession") = 0;
  }
}
%end
%end

%ctor {
  %init(SettingsHook);
}
