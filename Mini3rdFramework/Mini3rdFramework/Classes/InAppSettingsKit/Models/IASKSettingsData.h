//
//  YLSettingsData.h
//  YLSettings
//
//  Created by lipeiqiang on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum 
{
    IASKSettingTypeGroup = 0 ,
    IASKSettingTypeRadio,
    IASKSettingTypeSwitch,
    IASKSettingTypeMultiValue,
    IASKSettingTypeTitleValue,
    IASKSettingTypeTextField,
    IASKSettingTypeChildPane,
    IASKSettingTypeOpenUrl,
    IASKSettingTypeButton,
    IASKSettingTypeCustomView
}IASKSettingType;
@interface IASKSettingsData : NSObject {
    IASKSettingType  type;
    NSString *itemId;
    NSString *title;
    NSString *subTitle;
    NSString *footerText;
    NSString *key;
    NSString *file;
    id          defaultValue;
    NSNumber *minimumValue;
    NSNumber *maximumValue;
    NSNumber *trueValue;
    NSNumber *falseValue;
    NSNumber *isSecure;

    
    NSArray *multipleTitles;
    NSArray *multipleValues;
    NSString * iconName;
    NSArray *childArray;
    NSString * IASKViewControllerClass;
    NSString * IASKViewControllerSelector;
    
    UIKeyboardType keyboardType;
    UITextAutocapitalizationType autocapitalizationType;
    UITextAutocorrectionType autoCorrectionType;
    UITableViewCellAccessoryType accessoryType;
    UITableViewCellStyle     cellStyle;
    NSObject * userInfo;
    BOOL displayValue;
    BOOL whiteIcon;
    UIImage *icon;
    NSString *placeHolder;
    NSInteger textAlignment;
    NSInteger valueTextAlignment;
    BOOL      autoSaveDefaultValue;
}

@property(nonatomic)IASKSettingType  type;
@property(nonatomic)NSInteger textAlignment;
@property(nonatomic)NSInteger valueTextAlignment;
@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *placeHolder;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;
@property(nonatomic,copy)NSString *footerText;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *file;
@property(nonatomic,retain)id       defaultValue;
@property(nonatomic,retain)NSNumber *minimumValue;
@property(nonatomic,retain)NSNumber *maximumValue;
@property(nonatomic,retain)NSNumber *trueValue;
@property(nonatomic,retain)NSNumber *falseValue;
@property(nonatomic,retain)NSNumber *isSecure;
@property(nonatomic)BOOL displayValue;
@property(nonatomic)BOOL whiteIcon;
@property(nonatomic,retain)UIImage *icon;
@property(nonatomic)BOOL      autoSaveDefaultValue;

@property(nonatomic)UIKeyboardType keyboardType; 
@property(nonatomic)UITextAutocapitalizationType autoCapitalizationType;
@property(nonatomic)UITextAutocorrectionType autoCorrectionType;
@property(nonatomic)UITableViewCellAccessoryType accessoryType;
@property(nonatomic)UITableViewCellStyle     cellStyle;

@property(nonatomic,retain)NSObject *userInfo;

@property(nonatomic,retain)NSArray *multipleTitles;
@property(nonatomic,retain)NSArray *multipleValues;
@property(nonatomic,copy)NSString * iconName;
@property(nonatomic,retain)NSArray * childArray;
@property(nonatomic,copy)NSString *IASKViewControllerClass;
@property(nonatomic,copy)NSString *IASKViewControllerSelector;
@property(nonatomic,copy)NSString *settingButtonClass;
@property(nonatomic,copy)NSString *settingButtonSelector;
- (NSString*)titleForCurrentValue:(id)currentValue;

- (Class)viewControllerClass;
- (SEL)viewControllerSelector;
- (Class)buttonClass;
- (SEL)buttonAction;
@end
