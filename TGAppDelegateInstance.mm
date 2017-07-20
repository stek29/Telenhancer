#import "TGHeaders/TGAppDelegate.h"

TGAppDelegate* TGAppDelegateInstance(void) {
  static TGAppDelegate *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[UIApplication sharedApplication] delegate];
  });
  return instance;
}
