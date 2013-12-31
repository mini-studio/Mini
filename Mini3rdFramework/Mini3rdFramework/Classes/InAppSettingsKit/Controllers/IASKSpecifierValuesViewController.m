//
//  IASKSpecifierValuesViewController.m
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

#import "IASKSpecifierValuesViewController.h"
//#import "IASKSpecifier.h"
#import "IASKSettingsData.h"
#import "IASKSettingsReader.h"
#import "IASKPSTitleValueSpecifierViewCell.h"
#define kCellValue      @"kCellValue"

@interface IASKSpecifierValuesViewController()
- (void)MiniUserDefaultsDidChange;
@end

@implementation IASKSpecifierValuesViewController

//@synthesize tableView=_tableView;
@synthesize checkedItem=_checkedItem;
@synthesize settingsReader = _settingsReader;
@synthesize settingsStore = _settingsStore;
@synthesize  currentData = _currentData;
@synthesize tableView = _tableView;

- (void) updateCheckedItem {
    NSInteger index;
	// Find the currently checked item
    if([self.settingsStore objectForKey:[self.currentData key]]) {
      index = [self.currentData.multipleValues indexOfObject:[self.settingsStore objectForKey:[self.currentData key]]];
    } else {
      index = [self.currentData.multipleValues indexOfObject:[self.currentData defaultValue]];
    }
	[self setCheckedItem:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (id<IASKSettingsStore>)settingsStore {
    if(_settingsStore == nil) {
        _settingsStore = [[IASKSettingsStoreUserDefaults alloc] init];
    }
    return _settingsStore;
}




- (void)viewWillAppear:(BOOL)animated {
    if (_currentData) {
        [self setTitle:[_currentData title]];
        [self updateCheckedItem];
    }
    
    if (_tableView) {
        [_tableView reloadData];

		// Make sure the currently checked item is visible
        [_tableView scrollToRowAtIndexPath:[self checkedItem] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[_tableView flashScrollIndicators];
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(MiniUserDefaultsDidChange)
												 name:NSUserDefaultsDidChangeNotification
											   object:[NSUserDefaults standardUserDefaults]];
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
	[super viewDidDisappear:animated];
}

- (void)createGroupedTableView
{
    CGRect rect = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];    
    [self.view addSubview:_tableView];
}

-(void)loadView
{
    [super loadView];
    [self createGroupedTableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tableView = nil;
}


- (void)dealloc {
    [_currentData release], _currentData = nil;
	[_checkedItem release], _checkedItem = nil;
	[_settingsReader release], _settingsReader = nil;
    [_settingsStore release], _settingsStore = nil;
	[_tableView release], _tableView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_currentData multipleValues] count];
}

- (void)selectCell:(UITableViewCell *)cell {
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	//[[cell textLabel] setTextColor:kIASKgrayBlueColor];
}

- (void)deselectCell:(UITableViewCell *)cell {
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	//[[cell textLabel] setTextColor:[UIColor darkTextColor]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [_currentData footerText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell   = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellValue];
    NSArray *titles         = [_currentData multipleTitles];
	
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellValue] autorelease];
//        cell.backgroundColor = YLCOLOR(0x395865ff);
//        cell.textLabel.textColor = [UIColor whiteColor];
    }
	
	if ([indexPath isEqual:[self checkedItem]]) {
		[self selectCell:cell];
    } else {
        [self deselectCell:cell];
    }
	
	@try {
		[[cell textLabel] setText:[self.settingsReader titleForStringId:[titles objectAtIndex:indexPath.row]]];
	}
	@catch (NSException  *e) {}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath == [self checkedItem]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSArray *values         = [_currentData multipleValues];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self deselectCell:[tableView cellForRowAtIndexPath:[self checkedItem]]];
    [self selectCell:[tableView cellForRowAtIndexPath:indexPath]];
    [self setCheckedItem:indexPath];
	
    [self.settingsStore setObject:[values objectAtIndex:indexPath.row] forKey:[_currentData key]];
	[self.settingsStore synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged
                                                        object:[_currentData key]
                                                      userInfo:[NSDictionary dictionaryWithObject:[values objectAtIndex:indexPath.row]
                                                                                           forKey:[_currentData key]]];
}

#pragma mark Notifications

- (void)MiniUserDefaultsDidChange {
	NSIndexPath *oldCheckedItem = self.checkedItem;
	if(_currentData) {
		[self updateCheckedItem];
	}
	
	// only reload the table if it had changed; prevents animation cancellation
	if (self.checkedItem != oldCheckedItem) {
		[_tableView reloadData];
	}
}

@end
