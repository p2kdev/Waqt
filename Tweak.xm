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

  %end

%end

static void reloadSettings() {

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.p2kdev.waqt.plist"];
	if(prefs)
	{
		formatForLine1 = [prefs objectForKey:@"formatSpecifier1"] ? [[prefs objectForKey:@"formatSpecifier1"] stringValue] : formatForLine1;
    formatForLine2 = [prefs objectForKey:@"formatSpecifier2"] ? [[prefs objectForKey:@"formatSpecifier2"] stringValue] : formatForLine2;
		fontSize1 = [prefs objectForKey:@"fontSize1"] ? [[prefs objectForKey:@"fontSize1"] intValue] : fontSize1;
    fontSize2 = [prefs objectForKey:@"fontSize2"] ? [[prefs objectForKey:@"fontSize2"] intValue] : fontSize2;
    maxSpacing = [prefs objectForKey:@"spacing"] ? [[prefs objectForKey:@"spacing"] floatValue] : maxSpacing;
    //offset = [prefs objectForKey:@"offset"] ? [[prefs objectForKey:@"offset"] floatValue] : offset;
    boldLine1 = [prefs objectForKey:@"boldLine1"] ? [[prefs objectForKey:@"boldLine1"] boolValue] : boldLine1;
    boldLine2 = [prefs objectForKey:@"boldLine2"] ? [[prefs objectForKey:@"boldLine2"] boolValue] : boldLine2;
    hideBreadcrumbs = [prefs objectForKey:@"hideBreadcrumbs"] ? [[prefs objectForKey:@"hideBreadcrumbs"] boolValue] : hideBreadcrumbs;
    hideLocation = [prefs objectForKey:@"hideLocation"] ? [[prefs objectForKey:@"hideLocation"] boolValue] : hideLocation;
	}
}


%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.p2kdev.waqt.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    reloadSettings();

    %init;

    if (hideBreadcrumbs)
      %init(HideBreadcrumbs);

    if (hideLocation)
      %init(HideLocation);
}
