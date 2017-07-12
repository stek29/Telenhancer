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

@interface TGButtonCollectionItem : TGCollectionItem
-(instancetype)initWithTitle:(NSString *)title action:(SEL)action;
@end

@interface TGCollectionMenuSection : NSObject
-(instancetype)initWithItems:(NSArray *)items;
-(void)addItem:(TGCollectionItem *)item;
@end

@interface TGCollectionMenuSectionList : NSObject
-(void)addSection:(TGCollectionMenuSection *)section;
@end

@interface TGAccountSettingsController : UIViewController
@property (nonatomic, strong) TGCollectionMenuSectionList *menuSections;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@interface iHateLogos_TGCollectionMenuController : UIViewController
-(void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
@property(nonatomic, strong) TGCollectionMenuSectionList *menuSections;
@end

@interface TGAlertView : UIAlertView
-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle completionBlock:(void (^)(bool okButtonPressed))completionBlock;
@end

static TGAppDelegate *TGAppDelegateInstance = nil;

%group SettingsHook

%subclass TESettingsController : TGCollectionMenuController <UINavigationControllerDelegate>
-(instancetype) init {
  self = %orig;
  if (self) {
    iHateLogos_TGCollectionMenuController* ihlself = (iHateLogos_TGCollectionMenuController*) self;
    ihlself.title = @"Telenhancer Settings";

    TelenhancerSettings *settings = [TelenhancerSettings sharedInstance];

    [ihlself setRightBarButtonItem: [[UIBarButtonItem alloc]
      initWithTitle:@"Save"
      style:UIBarButtonItemStylePlain
      target:self
      action:@selector(saveAction)]];

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
      [ihlself.menuSections addSection:section];
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
