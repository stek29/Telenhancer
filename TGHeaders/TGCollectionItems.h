@interface TGCollectionItem : NSObject
@property (nonatomic) bool deselectAutomatically;
@end

@interface TGButtonCollectionItem : TGCollectionItem
@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic) SEL action;
- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;
@end

@interface TGSwitchCollectionItem : TGCollectionItem
@property (nonatomic, copy) void (^toggled)(bool value, TGSwitchCollectionItem *item);
-(instancetype)initWithTitle:(NSString *)title isOn:(bool)isOn;
@end

@interface TGCollectionStaticMultilineTextItem : TGCollectionItem
@property (nonatomic, strong) NSString *text;
@end

@interface TGCommentCollectionItem : TGCollectionItem
-(instancetype)initWithText:(NSString *)text;
-(instancetype)initWithFormattedText:(NSString *)text;
@end
