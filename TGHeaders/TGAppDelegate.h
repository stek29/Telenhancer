#import "TGViewController.h"

@interface TGRootController : TGViewController
-(void)pushContentController:(UIViewController *)contentController;
@end

@interface TGAppDelegate : NSObject
@property (nonatomic, strong) TGRootController *rootController;
@property (nonatomic) bool useDifferentBackend; // Reversed (true=using main)
@end

TGAppDelegate* TGAppDelegateInstance(void);
