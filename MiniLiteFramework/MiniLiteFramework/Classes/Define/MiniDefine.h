#define KGap 10

#define RELEASE(ptr) {if(ptr !=nil ){[ptr release]; ptr=nil;}}

#define IS_PAD ([UIDevice isPad])
#define IS_LANDSCAPE (([[UIScreen mainScreen] bounds].size.height < [[UIScreen mainScreen] bounds].size.width)?YES:NO)
#define IS_PORTRAIT ([[UIScreen mainScreen] applicationFrame].size.height > [[UIScreen mainScreen] applicationFrame].size.width?YES:NO)
#define IS_NULL(o) (o == nil || [[NSNull null] isEqual:o])

#define IS_IOS10  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)
//机型判断
#define IS_IPHONE_4   (([[UIScreen mainScreen] bounds].size.height==480) ? YES : NO)
#define IS_IPHONE_5   (([[UIScreen mainScreen] bounds].size.height==568) ? YES : NO)
#define IS_IPHONE_6   (([[UIScreen mainScreen] bounds].size.height==667) ? YES : NO)
#define IS_IPHONE_6P  (([[UIScreen mainScreen] bounds].size.height==736) ? YES : NO)
#define IS_IPHONE_X (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

#define IPHONE_X_TABBAR_BOTTOM_EXT_HEIGHT 20

#define ROOT_VIEW_TAG 2000200420082012
#define ROOT_CONTENT_VIEW_TAG 2000200420082013

#define  MiniUIKeyboardWillShowNotification @"MiniUIKeyboardWillShowNotification"
#define  MiniUIKeyboardDidShowNotification @"MiniUIKeyboardDidShowNotification"

#define  MiniUIKeyboardWillHideNotification @"MiniUIKeyboardWillHideNotification"
#define  MiniUIKeyboardDidHideNotification @"MiniUIKeyboardDidHideNotification"
