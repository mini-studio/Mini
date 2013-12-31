//
//  IASKSettingsReader.h
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2009:
//  Luc Vandal, Edovia Inc., http://www.edovia.com
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
// 
//  It is appreciated but not required that you give credit to Luc Vandal and Ortwin Gentz, 
//  as the original authors of this code. You can give credit in a blog post, a tweet or on 
//  a info page of your app. Also, the original authors appreciate letting them know if you use this code.
//
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//

#import <Foundation/Foundation.h>
#import "IASKSettingsData.h"




//#define kIASKPSGroupSpecifier                 @"PSGroupSpecifier"
//#define kIASKPSToggleSwitchSpecifier          @"PSToggleSwitchSpecifier"
//#define kIASKPSMultiValueSpecifier            @"PSMultiValueSpecifier"
//#define kIASKPSTitleValueSpecifier            @"PSTitleValueSpecifier"
//#define kIASKPSTextFieldSpecifier             @"PSTextFieldSpecifier"
//#define kIASKPSChildPaneSpecifier             @"PSChildPaneSpecifier"
//#define kIASKOpenURLSpecifier                 @"IASKOpenURLSpecifier"
//#define kIASKButtonSpecifier                  @"IASKButtonSpecifier"
//#define kIASKCustomViewSpecifier              @"IASKCustomViewSpecifier"



#define kIASKAppSettingChanged                @"kAppSettingChanged"

#define kIASKSpacing                          5
#define kIASKMinLabelWidth                    97
#define kIASKMinValueWidth                    35
#define kIASKPaddingLeft                      9
#define kIASKPaddingRight                     10
#define kIASKHorizontalPaddingGroupTitles     19
#define kIASKVerticalPaddingGroupTitles       15

#define kIASKLabelFontSize                    17
#define kIASKgrayBlueColor                    [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0]

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_1 550.38
#endif


#define IASK_IF_IOS4_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0) \
{ \
__VA_ARGS__ \
}

@interface IASKSettingsReader : NSObject {
    NSArray         *_settingsDataArray;
    NSString        *_settingViewKey;
}

- (id)initWithSettingViewKey:(NSString*)settingViewKey;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsForSection:(NSInteger)section;

-(NSMutableArray *)settingDataGroupForKey:(NSString *)key;
-(IASKSettingsData*)settingDataForIndexpath:(NSIndexPath*)indexPath;
-(IASKSettingsData*)settingDataForKey:(NSString*)key;

- (NSString*)titleForSection:(NSInteger)section;
- (NSString*)keyForSection:(NSInteger)section;
- (NSString*)footerTextForSection:(NSInteger)section;
- (NSString*)titleForStringId:(NSString*)stringId;


-(IASKSettingsData*)settingDataByTitle:(NSString*)title settingKey:(NSString*)settingkey  type:(IASKSettingType)type;
-(IASKSettingsData*)switchSettingDataByTitle:(NSString*)title settingKey:(NSString*)settingkey  defaultVal:(NSInteger)defaultVal;
-(IASKSettingsData*)childSettingDataByTitle:(NSString*)title file:(NSString*)file;
-(IASKSettingsData*)buttonSettingDataByTitle:(NSString*)title  settingKey:(NSString*)settingkey;

- (void)loadSettingsData;

@property (nonatomic, retain) NSArray       *settingsDataArray;
@property (nonatomic, copy)   NSString       *settingViewKey;


@end
