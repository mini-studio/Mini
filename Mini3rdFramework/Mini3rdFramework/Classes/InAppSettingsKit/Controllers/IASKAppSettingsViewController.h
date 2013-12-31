//
//  IASKAppSettingsViewController.h
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

#import <UIKit/UIKit.h>
#import "IASKSettingsStore.h"
#import "MiniViewController.h"
@class IASKSettingsReader;
@class IASKAppSettingsViewController;
@class IASKSettingsData;
@protocol IASKSettingsDelegate
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender;
@optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderForKey:(NSString*)key;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderForKey:(NSString*)key;

- (CGFloat)tableView:(UITableView*)tableView heightForSettingData:(IASKSettingsData*)specifier;

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSettingData:(IASKSettingsData*)specifier;
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForKey:(NSString*)key;

@end


@interface IASKAppSettingsViewController : MiniViewController <UITextFieldDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
	id<IASKSettingsDelegate>  _delegate;
//    UITableView    			*_tableView;
    
    NSMutableArray          *_viewList;
    NSIndexPath             *_currentIndexPath;
	NSIndexPath				*_topmostRowBeforeKeyboardWasShown;
	
	IASKSettingsReader		*_settingsReader;
    id<IASKSettingsStore>  _settingsStore;
	NSString				*_settingViewKey;
	
	id                      _currentFirstResponder;
    BOOL                    _showCreditsFooter;
    BOOL                    _showDoneButton;
    NSString                *_controllTitle;
    
    UITableView             *_tableView;
}

@property (nonatomic, assign) IBOutlet id delegate;
//@property (nonatomic, retain)  UITableView *tableView;
@property (nonatomic, retain) NSIndexPath   *currentIndexPath;
@property (nonatomic, retain) IASKSettingsReader *settingsReader;
@property (nonatomic, retain) id<IASKSettingsStore> settingsStore;
@property (nonatomic, retain) NSString *settingViewKey;
@property (nonatomic, retain) id currentFirstResponder;
@property (nonatomic, assign) BOOL showCreditsFooter;
@property (nonatomic, assign) BOOL showDoneButton;
@property (nonatomic, retain) NSString *controllTitle;
@property (nonatomic,retain)  UITableView             *tableView;
- (void)synchronizeSettings;
- (IBAction)dismiss:(id)sender;

// subclassing: optionally override these methods to customize appearance and functionality
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section;
- (void)cellButtonTap:(NSString*) buttonTappedKey;
- (void)didCellButtonTap:(NSString*) buttonTappedKey cell:(UITableViewCell*)cell;
- (void)didToggledValue:(id)sender key:(NSString*)key;

@end

@interface IASKAppSettingsViewController(correct)
- (void)prepareforReuse;
- (UITableViewCellStyle)cellStyleForSettingData:(IASKSettingsData*)specifier defaultStyle:(UITableViewCellStyle)defaultStyle;
- (void)correctTableViewCell:(UITableViewCell*)tableViewCell cellForSettingData:(IASKSettingsData*)specifier;
- (CGFloat)cellHeightForSettingData:(IASKSettingsData *)settingData;
- (void)willConstructCellForData:(IASKSettingsData *)settingData atIndexPath:(NSIndexPath *)indexPath;
@end
