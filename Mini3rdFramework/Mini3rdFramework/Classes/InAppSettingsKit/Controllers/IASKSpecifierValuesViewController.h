//
//  IASKSpecifierValuesViewController.h
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
@class IASKSettingsData;
#ifdef EXT_BASE_CLASS_NAME
@interface IASKSpecifierValuesViewController : EXT_BASE_CLASS_NAME<UITableViewDelegate,UITableViewDataSource> {
#else
@interface IASKSpecifierValuesViewController : MiniViewController<UITableViewDelegate,UITableViewDataSource> {
#endif
//    UITableView				*_tableView;
    NSIndexPath             *_checkedItem;
	IASKSettingsReader		*_settingsReader;
    id<IASKSettingsStore>	_settingsStore;
    IASKSettingsData *_currentData;
    UITableView      *_tableView;
}

//@property (nonatomic, retain)  UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *checkedItem;
@property (nonatomic, retain) IASKSettingsReader *settingsReader;
@property (nonatomic, retain) id<IASKSettingsStore> settingsStore;
@property (nonatomic, retain) IASKSettingsData * currentData;
@property (nonatomic,retain) UITableView      *tableView;

@end