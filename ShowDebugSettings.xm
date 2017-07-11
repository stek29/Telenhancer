#import "SharedSettings.h"

@interface TGCollectionMenuSection : NSObject
@property (nonatomic, readonly, strong) NSArray *items;
@end

@interface TGCollectionItem : NSObject
@property (nonatomic) bool deselectAutomatically;
@end

@interface TGButtonCollectionItem : TGCollectionItem
@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic) SEL action;
- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;
@end

@interface TGCollectionMenuSectionList : NSObject
@property (nonatomic, readonly) NSArray *sections;
- (void)addItemToSection:(NSUInteger)section item:(TGCollectionItem *)item;
- (void)deleteItemFromSection:(NSUInteger)section atIndex:(NSUInteger)index;
- (void)beginRecordingChanges;
- (bool)commitRecordedChanges:(UICollectionView *)collectionView;
@end

@interface TGAccountSettingsController : UIViewController
@property (nonatomic, strong) TGCollectionMenuSectionList *menuSections;
@property (nonatomic, strong) UICollectionView *collectionView;
- (void)_resetCollectionView;
- (void)mySettingsPressed;
@end

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

static BOOL shouldLoadShowDebugSettings(TelenhancerSettings* settings) {
  [settings
    addGroup:@"ShowDebugSettings"
    withDefaultSetting: [[TelenhancerSetting alloc]
      initWithLabel: @"Show Debug Settings"
      description: nil
      andPreferences: nil
    ]];

  return [settings settingForGroup:@"ShowDebugSettings"].enabled;
}
