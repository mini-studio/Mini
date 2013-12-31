//
//  IASKSettingsReader.m
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

#import "IASKSettingsReader.h"
#import "IASKSettingsData.h"
@interface IASKSettingsReader (private)
- (BOOL)_sectionHasHeading:(NSInteger)section;
- (void)loadSettingsData;
- (void)makeDictions;
@end

@implementation IASKSettingsReader

@synthesize settingsDataArray = _settingsDataArray;
@synthesize settingViewKey = _settingViewKey;

- (id)init
{
    if ((self=[super init])) 
    {
        self.settingViewKey = @"Root";
        //[self loadSettingsData];
        [self makeDictions];
    }
    return self;
}

- (id)initWithSettingViewKey:(NSString*)settingViewKey
{
    if ((self=[super init])) 
    {
        self.settingViewKey = settingViewKey;
        //[self loadSettingsData];
       // [self makeDictions];
    }
    return self;
}

- (void)dealloc {
    [_settingViewKey release];
    _settingViewKey = nil;
    [_settingsDataArray release];
    _settingsDataArray = nil;
    [super dealloc];
}
- (BOOL)_sectionHasHeading:(NSInteger)section {
    
    IASKSettingsData *data = [[self.settingsDataArray objectAtIndex:section] objectAtIndex:0];
    return data.type == IASKSettingTypeGroup;
}

- (NSInteger)numberOfSections 
{
    return self.settingsDataArray.count;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section {
    int headingCorrection = [self _sectionHasHeading:section] ? 1 : 0;
    return    [[self.settingsDataArray objectAtIndex:section] count] - headingCorrection;
}

-(NSMutableArray *)settingDataGroupForKey:(NSString *)key
{
    for (NSArray *settingDatas in _settingsDataArray) 
    {
        for (IASKSettingsData *data in settingDatas) 
        {
            if ([data.key isEqualToString:key] && data.type == IASKSettingTypeGroup ) 
            {
                if ( [settingDatas isKindOfClass:[NSMutableArray class]]) 
                {
                    return (NSMutableArray *)settingDatas;
                }
                else
                {
                    return [NSMutableArray arrayWithArray:settingDatas];
                }
            }
        }
    }
    return nil;
}

-(IASKSettingsData*)settingDataForIndexpath:(NSIndexPath*)indexPath
{
    int headingCorrection = [self _sectionHasHeading:indexPath.section] ? 1 : 0;
    
    IASKSettingsData *data = [[[self settingsDataArray] objectAtIndex:indexPath.section] objectAtIndex:(indexPath.row+headingCorrection)];
 	return data;
}

-(IASKSettingsData*)settingDataForKey:(NSString*)key
{
    for (NSArray *settingDatas in _settingsDataArray) {
        for (IASKSettingsData *data in settingDatas) {
            if ([data.key isEqualToString:key]) {
                    return data;
                }
        }
    }
    return nil;
}


- (NSString*)titleForSection:(NSInteger)section {
    if ([self _sectionHasHeading:section]) 
    {
        IASKSettingsData *data = [[self.settingsDataArray objectAtIndex:section]  objectAtIndex:0];
        return data.title;
    }
    return nil;
}

- (NSString*)keyForSection:(NSInteger)section {
    if ([self _sectionHasHeading:section])
    {
        IASKSettingsData *data = [[self.settingsDataArray objectAtIndex:section]  objectAtIndex:0];
        return data.key;
    }
    return nil;
}

- (NSString*)footerTextForSection:(NSInteger)section {
    if ([self _sectionHasHeading:section]) {
        IASKSettingsData *data = [[self.settingsDataArray objectAtIndex:section]  objectAtIndex:0];
        return data.footerText;
    }
    return nil;
}

- (NSString*)titleForStringId:(NSString*)stringId
{
    NSString *localizedString =  NSLocalizedString(stringId, nil);
    return localizedString;
}

- (void)loadSettingsData
{
}

-(IASKSettingsData*)settingDataByTitle:(NSString*)titleKey settingKey:(NSString*)settingkey  type:(IASKSettingType)type
{
    IASKSettingsData *settingData = [[[IASKSettingsData alloc] init] autorelease];
    settingData.type = type;
    settingData.title = titleKey;
    settingData.key = settingkey;
    return  settingData;
}

-(IASKSettingsData*)switchSettingDataByTitle:(NSString*)title settingKey:(NSString*)settingkey  defaultVal:(NSInteger)defaultVal
{
    IASKSettingsData *settingData = [self settingDataByTitle:title settingKey:settingkey type:IASKSettingTypeSwitch];
    settingData.defaultValue = [NSNumber numberWithInt:defaultVal];
    return  settingData;
}

-(IASKSettingsData*)childSettingDataByTitle:(NSString*)title file:(NSString*)file
{
    IASKSettingsData *childSettingData = [self settingDataByTitle:title settingKey:nil type:IASKSettingTypeChildPane];
    childSettingData.file = file;
    return childSettingData;
}


-(IASKSettingsData*)buttonSettingDataByTitle:(NSString*)title settingKey:(NSString*)settingkey
{
    IASKSettingsData *buttonSetting = [self settingDataByTitle:title settingKey:settingkey type:IASKSettingTypeButton];
//    buttonSetting.settingButtonSelector = @"cellButtonTap:";
    return buttonSetting;
}
@end
