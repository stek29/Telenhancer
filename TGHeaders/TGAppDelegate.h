#import "TGViewController.h"

@interface TGRootController : TGViewController
-(void)pushContentController:(UIViewController *)contentController;
@end

@interface TGAppDelegate : NSObject
@property (nonatomic, strong) TGRootController *rootController;
@property (nonatomic) bool useDifferentBackend;
@end

TGAppDelegate* TGAppDelegateInstance(void);
