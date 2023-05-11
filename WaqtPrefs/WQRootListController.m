#import <Preferences/Preferences.h>
#import "spawn.h"

@interface WQRootListController : PSListController
@end

@implementation WQRootListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void)visitTwitter {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/p2kdev"]];
}

- (void)respring {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.p2kdev.waqt.respring"), NULL, NULL, YES);
}
@end
