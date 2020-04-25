#line 1 "Tweak.xm"
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class _UIStatusBarIndicatorLocationItem; @class _UIStatusBarTimeItem; @class FBSystemService; 
static id (*_logos_orig$_ungrouped$_UIStatusBarIndicatorLocationItem$applyUpdate$toDisplayItem$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarIndicatorLocationItem* _LOGOS_SELF_CONST, SEL, id, id); static id _logos_method$_ungrouped$_UIStatusBarIndicatorLocationItem$applyUpdate$toDisplayItem$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarIndicatorLocationItem* _LOGOS_SELF_CONST, SEL, id, id); static id (*_logos_orig$_ungrouped$_UIStatusBarTimeItem$_applyUpdate$toDisplayItem$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarTimeItem* _LOGOS_SELF_CONST, SEL, id, id); static id _logos_method$_ungrouped$_UIStatusBarTimeItem$_applyUpdate$toDisplayItem$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarTimeItem* _LOGOS_SELF_CONST, SEL, id, id); static NSMutableAttributedString* _logos_method$_ungrouped$_UIStatusBarTimeItem$getTimeInNewFormat(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarTimeItem* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$FBSystemService(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("FBSystemService"); } return _klass; }
#line 36 "Tweak.xm"


static id _logos_method$_ungrouped$_UIStatusBarIndicatorLocationItem$applyUpdate$toDisplayItem$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarIndicatorLocationItem* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2) {
  return nil;
}






  static id _logos_method$_ungrouped$_UIStatusBarTimeItem$_applyUpdate$toDisplayItem$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarTimeItem* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2) {
    id orig = _logos_orig$_ungrouped$_UIStatusBarTimeItem$_applyUpdate$toDisplayItem$(self, _cmd, arg1, arg2);
    _UIStatusBarStringView *shortTimeView = MSHookIvar<_UIStatusBarStringView*>(self,"_shortTimeView");
    shortTimeView.numberOfLines = numberOfLines;
    shortTimeView.attributedText = [self getTimeInNewFormat];
    shortTimeView.adjustsFontSizeToFitWidth = YES;
    return orig;
  }

  
  
  
  
  
  
  

  
  
  
  
  
  
  
  

  
  
  
  
  
  
  

  

  static NSMutableAttributedString* _logos_method$_ungrouped$_UIStatusBarTimeItem$getTimeInNewFormat(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarTimeItem* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] init];
    numberOfLines = 1;

    if ([formatForLine1 length] != 0)
    {
      [formatter setDateFormat:formatForLine1];
      NSString *newTimeLine1 = [formatter stringFromDate:[NSDate date]];

      UIFont *font = [UIFont boldSystemFontOfSize : fontSize1];
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      
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
      
      [paragraphStyle setMaximumLineHeight:font.ascender + maxSpacing];
      [paragraphStyle setAlignment:NSTextAlignmentCenter];

      NSDictionary *attributes = @{ NSFontAttributeName : font,NSParagraphStyleAttributeName : paragraphStyle};

      NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:newTimeLine2 attributes:attributes];

      [newText appendAttributedString : attr1];
    }

    
    
    
    
    
    
    
    
    
    

    return newText;
  }


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
  [[_logos_static_class_lookup$FBSystemService() sharedInstance] exitAndRelaunch:YES];
}


static __attribute__((constructor)) void _logosLocalCtor_6d35e6a1(int __unused argc, char __unused **argv, char __unused **envp) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.p2kdev.waqt.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.p2kdev.waqt.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    reloadSettings();
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //             



    
    
    
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$_UIStatusBarIndicatorLocationItem = objc_getClass("_UIStatusBarIndicatorLocationItem"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarIndicatorLocationItem, @selector(applyUpdate:toDisplayItem:), (IMP)&_logos_method$_ungrouped$_UIStatusBarIndicatorLocationItem$applyUpdate$toDisplayItem$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarIndicatorLocationItem$applyUpdate$toDisplayItem$);Class _logos_class$_ungrouped$_UIStatusBarTimeItem = objc_getClass("_UIStatusBarTimeItem"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarTimeItem, @selector(_applyUpdate:toDisplayItem:), (IMP)&_logos_method$_ungrouped$_UIStatusBarTimeItem$_applyUpdate$toDisplayItem$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarTimeItem$_applyUpdate$toDisplayItem$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSMutableAttributedString*), strlen(@encode(NSMutableAttributedString*))); i += strlen(@encode(NSMutableAttributedString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$_UIStatusBarTimeItem, @selector(getTimeInNewFormat), (IMP)&_logos_method$_ungrouped$_UIStatusBarTimeItem$getTimeInNewFormat, _typeEncoding); }} }
#line 188 "Tweak.xm"
