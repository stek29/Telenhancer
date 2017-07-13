#import "TGHeaders/TGAppDelegate.h"
#import "TGHeaders/TGCollectionItems.h"
#import "TGHeaders/TGCollectionMenus.h"
#import "TGHeaders/TGAlertView.h"
#import "TGHeaders/TGAccountSettingsController.h"
#import "SharedSettings.h"

static TGAppDelegate *TGAppDelegateInstance = nil;

%group SettingsHook

%subclass TESettingsController : TGCollectionMenuController <UINavigationControllerDelegate>
-(instancetype) init {
  self = %orig;
  if (self) {
    TGCollectionMenuController* castSelf = (TGCollectionMenuController*) self;
    castSelf.title = @"Telenhancer Settings";

    [castSelf setRightBarButtonItem: [[UIBarButtonItem alloc]
      initWithTitle:@"Save"
      style:UIBarButtonItemStylePlain
      target:self
      action:@selector(saveAction)]];

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
      [castSelf.menuSections addSection:section];
    }
  }

  return self;
}

%new
-(void) saveAction {
  [[TelenhancerSettings sharedInstance] saveToUserDefaults];

  TGAlertView *alert = [%c(TGAlertView) alloc];
  [[alert
    initWithTitle:@"Saved!"
    message:@"Please restart the app"
    cancelButtonTitle:@"OK"
    okButtonTitle:nil completionBlock:nil] show];
}

%end

%hook TGAccountSettingsController
-(instancetype) initWithUid:(int32_t)uid {
  self = %orig;
  if (self) {
    TGButtonCollectionItem *btn = [%c(TGButtonCollectionItem) alloc];
    [btn initWithTitle:@"Telenhancer Settings" action:@selector(TESettingsPressed)];
    [MSHookIvar<TGCollectionMenuSection*>(self, "_settingsSection") addItem:btn];
    [self.collectionView reloadData];
  }
  return self;
}

%new
-(void) TESettingsPressed {
    if (TGAppDelegateInstance == nil) {
      TGAppDelegateInstance = [[UIApplication sharedApplication] delegate];
    }
    [TGAppDelegateInstance.rootController pushContentController:[[%c(TESettingsController) alloc] init]];
}
%end

%end

%ctor {
  %init(SettingsHook);
}
