#import "TGViewController.h"
#import "TGCollectionItems.h"

@interface TGCollectionMenuSection : NSObject
@property (nonatomic, readonly, strong) NSArray *items;
-(instancetype)initWithItems:(NSArray *)items;
-(void)addItem:(TGCollectionItem *)item;
@end

@interface TGCollectionMenuSectionList : NSObject
@property (nonatomic, readonly) NSArray *sections;
-(void)addSection:(TGCollectionMenuSection *)section;
-(void)addItemToSection:(NSUInteger)section item:(TGCollectionItem *)item;
-(void)deleteItemFromSection:(NSUInteger)section atIndex:(NSUInteger)index;
-(void)beginRecordingChanges;
-(bool)commitRecordedChanges:(UICollectionView *)collectionView;
@end

@interface TGCollectionMenuView : UICollectionView
@property (nonatomic) bool editing;
-(void)setEditing:(bool)editing animated:(bool)animated;
@end

@interface TGCollectionMenuController : TGViewController
@property (nonatomic, strong) TGCollectionMenuSectionList *menuSections;
@property (nonatomic, strong) TGCollectionMenuView *collectionView;
-(void)_resetCollectionView;
@end
