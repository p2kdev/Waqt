static int fontSize1 = 12;
static int fontSize2 = 12;
static float maxSpacing = 1.0;
static int numberOfLines = 2;
//static float offset = 0.0;
static NSString *formatForLine1 = @"hh:mm";
static NSString *formatForLine2 = @"E MM/dd";
static bool boldLine1 = YES;
static bool boldLine2 = YES;
static bool hideBreadcrumbs = YES;
static bool hideLocation = YES;

@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface _UIStatusBarPillView : UIView
@end

@interface _UIStatusBarStringView : UILabel
  -(void)setText:(id)arg1;
  -(NSMutableAttributedString*)getTimeInNewFormat;
  @property (nonatomic,readonly) long long overriddenVerticalAlignment;
@end

@interface _UIStatusBarTimeItem
  -(void)setTimeView:(_UIStatusBarStringView *)arg1 ;
  -(void)setShortTimeView:(_UIStatusBarStringView *)arg1 ;
  -(void)setPillTimeView:(_UIStatusBarStringView *)arg1 ;
  -(NSMutableAttributedString*)getTimeInNewFormat;
@end

%hook _UIStatusBarTimeItem

  -(id)_applyUpdate:(id)arg1 toDisplayItem:(id)arg2
  {
    id orig = %orig;
    _UIStatusBarStringView *shortTimeView = MSHookIvar<_UIStatusBarStringView*>(self,"_shortTimeView");
    shortTimeView.numberOfLines = numberOfLines;
    shortTimeView.attributedText = [self getTimeInNewFormat];
    shortTimeView.adjustsFontSizeToFitWidth = YES;
    return orig;
  }

  %new
  -(NSMutableAttributedString*)getTimeInNewFormat
  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] init];
    numberOfLines = 1;

    if ([formatForLine1 length] != 0)
    {
      [formatter setDateFormat:formatForLine1];
      NSString *newTimeLine1 = [formatter stringFromDate:[NSDate date]];

      UIFont *font;
      if (boldLine1)
        font = [UIFont boldSystemFontOfSize : fontSize1];
      else
        font = [UIFont systemFontOfSize : fontSize1];

      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      [paragraphStyle setMinimumLineHeight:font.ascender + maxSpacing];
      [paragraphStyle setMaximumLineHeight:font.ascender + maxSpacing];
      [paragraphStyle setAlignment:NSTextAlignmentCenter];

      NSDictionary *attributes = @{ NSFontAttributeName : font,NSParagraphStyleAttributeName : paragraphStyle};

      NSAttributedString *attr0 = [[NSAttributedString alloc] initWithString:newTimeLine1 attributes:attributes];

      [newText appendAttributedString : attr0];
    }

    if ([formatForLine2 length] != 0)
    {
      numberOfLines = 2;

      [formatter setDateFormat:formatForLine2];
      NSString *newTimeLine2 = [NSString stringWithFormat:@"\n%@",[formatter stringFromDate:[NSDate date]]];

      UIFont *font;
      if (boldLine2)
        font = [UIFont boldSystemFontOfSize : fontSize2];
      else
        font = [UIFont systemFontOfSize : fontSize2];

      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      [paragraphStyle setMinimumLineHeight:font.ascender + maxSpacing];
      [paragraphStyle setMaximumLineHeight:font.ascender + maxSpacing];
      [paragraphStyle setAlignment:NSTextAlignmentCenter];

      NSDictionary *attributes = @{ NSFontAttributeName : font,NSParagraphStyleAttributeName : paragraphStyle};

      NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:newTimeLine2 attributes:attributes];

      [newText appendAttributedString : attr1];
    }

    return newText;
  }
%end

%group HideBreadcrumbs

	%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider

  	+ (BOOL)_shouldAddBreadcrumbToActivatingSceneEntity: (id)arg1 sceneHandle: (id)arg2 withTransitionContext: (id)arg3
  	{
  		return NO;
  	}

	%end

%end

%group HideLocation

  %hook _UIStatusBarIndicatorLocationItem

    - (id) applyUpdate : (id) arg1 toDisplayItem : (id) arg2 {
      return nil;
    }

    -(BOOL)canEnableDisplayItem:(id)arg1 fromData:(id) arg2 {
      return NO;
    }

  %end

%end

static void reloadSettings() {

  static CFStringRef prefsKey = CFSTR("com.p2kdev.waqt");
  CFPreferencesAppSynchronize(prefsKey);

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"formatSpecifier1", prefsKey))) {
    formatForLine1 = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"formatSpecifier1", prefsKey)) stringValue];
  }	

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"formatSpecifier2", prefsKey))) {
    formatForLine2 = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"formatSpecifier2", prefsKey)) stringValue];
  }	

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"fontSize1", prefsKey))) {
    fontSize1 = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"fontSize1", prefsKey)) intValue];
  }	    

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"fontSize2", prefsKey))) {
    fontSize2 = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"fontSize2", prefsKey)) intValue];
  }	  

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"spacing", prefsKey))) {
    maxSpacing = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"spacing", prefsKey)) floatValue];
  }	    

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"boldLine1", prefsKey))) {
    boldLine1 = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"boldLine1", prefsKey)) boolValue];
  }	    

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"boldLine2", prefsKey))) {
    boldLine2 = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"boldLine2", prefsKey)) boolValue];
  }	    

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"hideBreadcrumbs", prefsKey))) {
    hideBreadcrumbs = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"hideBreadcrumbs", prefsKey)) boolValue];
  }	  

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"hideLocation", prefsKey))) {
    hideLocation = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"hideLocation", prefsKey)) boolValue];
  }	      
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}


%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.p2kdev.waqt.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    %init;
    reloadSettings();

    if (hideBreadcrumbs)
      %init(HideBreadcrumbs);

    if (hideLocation)
      %init(HideLocation);
}
