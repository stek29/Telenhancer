@interface TGCollectionItem : NSObject
@property (nonatomic) bool deselectAutomatically;
@end

@interface TGButtonCollectionItem : TGCollectionItem
@property (nonatomic) NSTextAlignment alignment;
- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;
@end

@interface TGCollectionMenuSectionList : NSObject
@property (nonatomic, readonly) NSArray *sections;
- (void)addItemToSection:(NSUInteger)section item:(TGCollectionItem *)item;
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
    TGButtonCollectionItem *debugSettingsItem = [
      [%c(TGButtonCollectionItem) alloc]
        initWithTitle:@"Debug Settings"
        action:@selector(mySettingsPressed)];
    debugSettingsItem.alignment = NSTextAlignmentCenter;
    debugSettingsItem.deselectAutomatically = true;

    [self.menuSections
      addItemToSection:self.menuSections.sections.count - 1
      item: debugSettingsItem];

    if (![self.menuSections commitRecordedChanges:self.collectionView]) {
      [self _resetCollectionView];
    }
  }
}
%end

%end
