static int fontSize1 = 12;
static int fontSize2 = 12;
static float maxSpacing = 1.0;
static int numberOfLines = 2;
static float offset = 0.0;
static NSString *formatForLine1 = @"hh:mm";
static NSString *formatForLine2 = @"E MM/dd";

@interface _UIStatusBarPillView : UIView
@end

@interface _UIStatusBarStringView : UILabel
// @property (nonatomic) NSInteger							numberOfLines;
// @property (nullable, nonatomic, copy) NSString					*text;                          /* default is nil */
// @property (nonatomic)     NSTextAlignment					textAlignment;                  /* default is NSTextAlignmentNatural (before iOS 9, the default was NSTextAlignmentLeft)*/
// @property (nullable, nonatomic, copy) NSAttributedString * attributedText	NS_AVAILABLE_IOS(6_0);        /* default is nil */
// @property (nonatomic)     NSLineBreakMode					lineBreakMode;
// @property (nonatomic, retain) UIColor						* textColor;
// @property (nonatomic,copy) NSString * originalText;
-(void)setText:(id)arg1;
-(NSMutableAttributedString*)getTimeInNewFormat;
@end

@interface _UIStatusBarTimeItem
-(void)setTimeView:(_UIStatusBarStringView *)arg1 ;
-(void)setShortTimeView:(_UIStatusBarStringView *)arg1 ;
-(void)setPillTimeView:(_UIStatusBarStringView *)arg1 ;
-(NSMutableAttributedString*)getTimeInNewFormat;
@end

@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

%hook _UIStatusBarIndicatorLocationItem

- (id) applyUpdate : (id) arg1 toDisplayItem : (id) arg2 {
  return nil;
}

%end

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

      UIFont *font = [UIFont boldSystemFontOfSize : fontSize1];
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      //[paragraphStyle setMaximumLineHeight:font.ascender + maxSpacing];
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

      UIFont *font = [UIFont boldSystemFontOfSize : fontSize2];
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      //paragraphStyle.lineSpacing = 0;
      [paragraphStyle setMaximumLineHeight:font.ascender + maxSpacing];
      [paragraphStyle setAlignment:NSTextAlignmentCenter];

      NSDictionary *attributes = @{ NSFontAttributeName : font,NSParagraphStyleAttributeName : paragraphStyle};

      NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:newTimeLine2 attributes:attributes];

      [newText appendAttributedString : attr1];
    }

    // [newText addAttribute:NSBaselineOffsetAttributeName
    //           value:[NSNumber numberWithFloat:offset]
    //           range:NSMakeRange(0,newTimeLine1.length)];
    //
    // if (newTimeLine2)
    // {
    //   [newText addAttribute:NSBaselineOffsetAttributeName
    //             value:[NSNumber numberWithFloat:offset]
    //             range:NSMakeRange(newTimeLine1.length + 1,newTimeLine2.length)];
    // }

    return newText;
  }
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
    offset = [prefs objectForKey:@"offset"] ? [[prefs objectForKey:@"offset"] floatValue] : offset;
	}
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}


%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.p2kdev.waqt.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.p2kdev.waqt.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    reloadSettings();
    /* Only initialize tweak if it is enabled and if the current process is homescreen or an app */
    // NSArray *args = [[NSProcessInfo processInfo] arguments];
    // if (args != nil && args.count != 0)
    // {
    //     NSString *execPath = args[0];
    //     if (execPath)
    //     {
    //         BOOL	isSpringBoard	= [[execPath lastPathComponent] isEqualToString:@"SpringBoard"];
    //         BOOL	isApplication	= [execPath rangeOfString:@"/Application"].location != NSNotFound;
    //         if ((isSpringBoard || isApplication))
    //         {
    //             if (kCFCoreFoundationVersionNumber >= 1443.00)
    //             {
    //                 %init;
    //             }
    //         }else{
    //             /*
    //              * NSString *processName = [[NSProcessInfo processInfo] processName];
    //              * NSLog(@"PerfectTimeX processName %@", processName);
    //              */
    //         }
    //     }
    // }
}
