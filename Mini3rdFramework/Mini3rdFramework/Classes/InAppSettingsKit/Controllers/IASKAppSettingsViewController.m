//
//  IASKAppSettingsViewController.m
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2009-2010:
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


#import "IASKAppSettingsViewController.h"
#import "IASKSettingsReader.h"
#import "IASKPSToggleSwitchSpecifierViewCell.h"
#import "IASKPSTextFieldSpecifierViewCell.h"
#import "IASKPSTitleValueSpecifierViewCell.h"
#import "IASKSwitch.h"
#import "IASKSpecifierValuesViewController.h"
#import "IASKTextField.h"
#import "IASKSettingsData.h"
#import "IASKUITableViewCell.h"
#import <CoreImage/CIImage.h>

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

static NSString *kIASKCredits = @"Powered by InAppSettingsKit"; // Leave this as-is!!!

#define kIASKSpecifierValuesViewControllerIndex       0
#define kIASKSpecifierChildViewControllerIndex        1

#define kIASKCreditsViewWidth                         285

CGRect IASKCGRectSwap(CGRect rect);

@interface IASKAppSettingsViewController ()
- (void)_textChanged:(id)sender;
- (void)_keyboardWillShow:(NSNotification*)notification;
- (void)_keyboardWillHide:(NSNotification*)notification;
- (void)synchronizeSettings;
- (void)reload;
@end

@implementation IASKAppSettingsViewController
@synthesize delegate = _delegate;
//@synthesize tableView = _tableView;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize settingsReader = _settingsReader;
@synthesize settingViewKey = _settingViewKey;
@synthesize currentFirstResponder = _currentFirstResponder;
@synthesize showCreditsFooter = _showCreditsFooter;
@synthesize showDoneButton = _showDoneButton;
@synthesize settingsStore = _settingsStore;
@synthesize controllTitle = _controllTitle;
@synthesize tableView = _tableView;
#pragma mark accessors
- (IASKSettingsReader*)settingsReader {
	if (!_settingsReader)
    {
        _settingsReader = [[IASKSettingsReader alloc] initWithSettingViewKey:self.settingViewKey];
	}
	return _settingsReader;
}

- (id<IASKSettingsStore>)settingsStore {
	if (!_settingsStore) {
		_settingsStore = [[IASKSettingsStoreUserDefaults alloc] init];
	}
	return _settingsStore;
}

- (NSString*)settingViewKey {
	if ( _settingViewKey.length == 0 )
    {
		return @"Root";
	}
    else
    {
        return _settingViewKey;
    }
}

-(void)setSettingViewKey:(NSString *)viewKey
{
    [viewKey retain];
    [_settingViewKey release];
    _settingViewKey = viewKey;
    self.settingsReader = nil;
}

- (void)prepareforReuse
{
    
}



#pragma mark standard view controller methods
- (id)init
{
    if ((self = [super init])) {
        // If set to YES, will display credits for InAppSettingsKit creators
        _showCreditsFooter = NO;
        
        // If set to YES, will add a DONE button at the right of the navigation bar
        _showDoneButton = YES;
    }
    return self;
}

- (void)createGroupedTableView
{
    CGRect rect = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

-(void)loadView
{
    [super loadView];
    [self createGroupedTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewList = [[NSMutableArray alloc] init];
    [_viewList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IASKSpecifierValuesView", @"ViewName",nil]];
    [_viewList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IASKAppSettingsView", @"ViewName",nil]];

}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tableView = nil;
	[_viewList release], _viewList = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{	
    //self.navigationController.delegate = self;
//    if (_showDoneButton) {
//        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
//                                                                                    target:self 
//                                                                                    action:@selector(dismiss:)];
//        self.navigationItem.rightBarButtonItem = buttonItem;
//        [buttonItem release];
//    } 
    self.title = self.controllTitle;
	if (self.currentIndexPath) {
		if (animated) {
			[_tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			[_tableView deselectRowAtIndexPath:self.currentIndexPath animated:YES];
		}
		self.currentIndexPath = nil;
	}
	
	[super viewWillAppear:animated];
}

- (CGSize)contentSizeForViewInPopover {
    return [[self view] sizeThatFits:CGSizeMake(self.view.width, 2000)];
}

- (void)viewDidAppear:(BOOL)animated {
    //self.navigationItem.rightBarButtonItem = nil;
	[_tableView flashScrollIndicators];
	[super viewDidAppear:animated];
	NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
	IASK_IF_IOS4_OR_GREATER([dc addObserver:self selector:@selector(reload) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];);
	[dc addObserver:self selector:@selector(_keyboardWillShow:)
               name:UIKeyboardWillShowNotification
            object:nil];
	[dc addObserver:self selector:@selector(_keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];		
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	if ([self.currentFirstResponder canResignFirstResponder]) {
//		[self.currentFirstResponder resignFirstResponder];
//	}
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidDisappear:(BOOL)animated {
	NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
	IASK_IF_IOS4_OR_GREATER([dc removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];);
	IASK_IF_IOS4_OR_GREATER([dc removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];);
	[dc removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
	[dc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
	[super viewDidDisappear:animated];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return YES;
//}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (![viewController isKindOfClass:[IASKAppSettingsViewController class]] && ![viewController isKindOfClass:[IASKSpecifierValuesViewController class]]) {
		[self dismiss:nil];
	}
}

- (void)dealloc {
    [_viewList release], _viewList = nil;
    [_currentIndexPath release], _currentIndexPath = nil;
	[_settingViewKey release], _settingViewKey = nil;
	[_currentFirstResponder release], _currentFirstResponder = nil;
	[_settingsReader release], _settingsReader = nil;
    [_settingsStore release], _settingsStore = nil;
	[_tableView release], _tableView = nil;
	[_controllTitle release];
	_delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Actions

- (IBAction)dismiss:(id)sender {
	if ([self.currentFirstResponder canResignFirstResponder]) {
		[self.currentFirstResponder resignFirstResponder];
	}
	
	[self.settingsStore synchronize];
	//self.navigationController.delegate = nil;
	
	if (self.delegate && [self.delegate conformsToProtocol:@protocol(IASKSettingsDelegate)]) {
		[self.delegate settingsViewControllerDidEnd:self];
	}
}

- (void)toggledValue:(id)sender {
    IASKSwitch *toggle    = (IASKSwitch*)sender;
    IASKSettingsData *data = [_settingsReader settingDataForKey:[toggle key]];
    //IASKSpecifier *spec   = [_settingsReader specifierForKey:[toggle key]];
    
    if ([toggle isOn]) {
        if ([data trueValue] != nil) {
            [self.settingsStore setObject:[data trueValue] forKey:[toggle key]];
        }
        else {
            [self.settingsStore setBool:YES forKey:[toggle key]]; 
        }
    }
    else {
        if ([data falseValue] != nil) {
            [self.settingsStore setObject:[data falseValue] forKey:[toggle key]];
        }
        else {
            [self.settingsStore setBool:NO forKey:[toggle key]]; 
        }
    }
    [self didToggledValue:sender key:[toggle key]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged
                                                        object:[toggle key]
                                                      userInfo:[NSDictionary dictionaryWithObject:[self.settingsStore objectForKey:[toggle key]]
                                                                                           forKey:[toggle key]]];
}

- (void)didToggledValue:(id)sender key:(NSString*)key
{
    
}
#pragma mark-
#pragma mark Cell Button Action

- (void)cellButtonTap:(NSString*) buttonTappedKey
{
}

- (void)didCellButtonTap:(NSString*) buttonTappedKey cell:(UITableViewCell*)cell
{
     [self cellButtonTap:buttonTappedKey];
}

#pragma mark -
#pragma mark UITableView Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.settingsReader numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingsReader numberOfRowsForSection:section];
}

- (CGFloat)cellHeightForSettingData:(IASKSettingsData *)settingData
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   //  IASKSpecifier *specifier  = [self.settingsReader specifierForIndexPath:indexPath];
     IASKSettingsData *settingData = [self.settingsReader settingDataForIndexpath:indexPath];
    NSInteger height = [self cellHeightForSettingData:settingData];
    if ( 0 < height )
    {
        return height;
    }
    else
    {
        if (settingData.type == IASKSettingTypeCustomView) {
            if ([self.delegate respondsToSelector:@selector(tableView:heightForSettingData:)]) {
                return [self.delegate tableView:_tableView heightForSettingData:settingData];
            } else {
                return 0;
            }
        }
        return tableView.rowHeight;
    }
}

- (NSString *)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *header = [self.settingsReader titleForSection:section];
	if (0 == header.length) {
		return nil;
	}
	return header;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *key  = [self.settingsReader keyForSection:section];
	if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderForKey:)]) {
		return [self.delegate tableView:_tableView viewForHeaderForKey:key];
	} else {
		return nil;
	}
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *key  = [self.settingsReader keyForSection:section];
	if ([self tableView:tableView viewForHeaderInSection:section] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderForKey:)]) {
		CGFloat result;
		if ((result = [self.delegate tableView:tableView heightForHeaderForKey:key])) {
			return result;
		}
		
	}
	NSString *title;
	if ((title = [self tableView:tableView titleForHeaderInSection:section])) {
		CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] 
						constrainedToSize:CGSizeMake(tableView.frame.size.width - 2*kIASKHorizontalPaddingGroupTitles, INFINITY)
							lineBreakMode:UILineBreakModeWordWrap];
		return size.height+kIASKVerticalPaddingGroupTitles;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *footerText = [self.settingsReader footerTextForSection:section];
	if (_showCreditsFooter && (section == [self.settingsReader numberOfSections]-1)) {
		// show credits since this is the last section
		if ((footerText == nil) || ([footerText length] == 0)) {
			// show the credits on their own
			return kIASKCredits;
		} else {
			// show the credits below the app's FooterText
			return [NSString stringWithFormat:@"%@\n\n%@", footerText, kIASKCredits];
		}
	} else {
		if ([footerText length] == 0) {
			return nil;
		}
		return [self.settingsReader footerTextForSection:section];
	}
}

- (UITableViewCellStyle)cellStyleForSettingData:(IASKSettingsData*)specifier defaultStyle:(UITableViewCellStyle)defaultStyle
{
    if ( specifier.cellStyle != UITableViewCellStyleDefault ) 
    {
        return specifier.cellStyle;
    }
    else
    {
        return defaultStyle;
    }
}

- (void)willConstructCellForData:(IASKSettingsData *)settingData atIndexPath:(NSIndexPath *)indexPath 
{
    
}

- (NSString *)identifierForSettingsData:(IASKSettingsData *)settingData atIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"cellForType%d-%d",settingData.type,settingData.cellStyle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IASKSettingsData *settingData = [self.settingsReader settingDataForIndexpath:indexPath];
    //IASKSpecifier *specifier  = [self.settingsReader specifierForIndexPath:indexPath];
    [self willConstructCellForData:settingData atIndexPath:indexPath];
    NSString *key           = settingData.key;
    NSString *identifier = [self identifierForSettingsData:settingData atIndexPath:indexPath];
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
      
    switch (settingData.type)
    {
        case IASKSettingTypeSwitch:
        {
            if (!cell) 
            {
                cell = [[[IASKPSToggleSwitchSpecifierViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleSubtitle]
                        reuseIdentifier:identifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = [settingData title];
            if ( settingData.subTitle.length > 0 )
            {
                cell.detailTextLabel.text = settingData.subTitle;                
            }
            else
            {
                cell.detailTextLabel.text = nil; 
            }
            id currentValue = [self.settingsStore objectForKey:key];
            BOOL toggleState;
            if (currentValue) {
                if ([currentValue isEqual:[settingData trueValue]]) {
                    toggleState = YES;
                } else if ([currentValue isEqual:[settingData falseValue]]) {
                    toggleState = NO;
                } else {
                    toggleState = [currentValue boolValue];
                }
            } else {
                toggleState = [[settingData defaultValue] boolValue];
            }

            [[(IASKPSToggleSwitchSpecifierViewCell*)cell toggle] setOn:toggleState];
            [[(IASKPSToggleSwitchSpecifierViewCell*)cell toggle] addTarget:self action:@selector(toggledValue:) forControlEvents:UIControlEventValueChanged];
            [[(IASKPSToggleSwitchSpecifierViewCell*)cell toggle] setKey:key];
        }
            break;
    case IASKSettingTypeMultiValue:
        {
                if (!cell) 
                {
                    cell = [[[IASKPSTitleValueSpecifierViewCell alloc] initWithStyle:
                             [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleValue1]
                            reuseIdentifier:identifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                [[cell textLabel] setText:[settingData title]];
                [[cell detailTextLabel] setText:[[settingData titleForCurrentValue:[self.settingsStore objectForKey:key] != nil ? 
                                                  [self.settingsStore objectForKey:key] : [settingData defaultValue]] description]];
        }
            break;
        case IASKSettingTypeTitleValue:
        {
                if (!cell) 
                {
                    cell = [[[IASKPSTitleValueSpecifierViewCell alloc] initWithStyle:
                                                                     [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleValue1]
                                                                     reuseIdentifier:identifier] autorelease];
                    //cell.accessoryType = UITableViewCellAccessoryNone;
                }
               cell.accessoryType = settingData.accessoryType;
                cell.textLabel.text = [settingData title];
                id value = [self.settingsStore objectForKey:key] ? : [settingData defaultValue];
                NSString *stringValue;
                if ([settingData multipleValues] || [settingData multipleTitles]) {
                    stringValue = [settingData titleForCurrentValue:value];
                } else {
                    stringValue = [value description];
                }
                
                cell.detailTextLabel.text = stringValue;
            cell.detailTextLabel.textAlignment = settingData.valueTextAlignment;
                //[cell setUserInteractionEnabled:NO];
            }
            break;
        case IASKSettingTypeChildPane:
        {
            if (!cell)
            {
                cell = [[[IASKPSTitleValueSpecifierViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleSubtitle]
                          reuseIdentifier:identifier] autorelease];                
            }
            if ( settingData.accessoryType != UITableViewCellAccessoryNone )
            {
                cell.accessoryType = settingData.accessoryType;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [settingData title];
            cell.detailTextLabel.text = nil;
            if ([settingData.defaultValue isKindOfClass:[NSString class]])
            {
                NSString *detail = settingData.defaultValue;
                if (detail.length > 0)
                {
                    cell.detailTextLabel.text = detail;
                }
            }
        }
            break;
        case IASKSettingTypeCustomView:
        {
            if ( cell == nil )
            {
                if ([self.delegate respondsToSelector:@selector(tableView:cellForSettingData:)])
                {
                    return [self.delegate tableView:_tableView cellForSettingData:settingData];
                }
            }
            else
            {
                return cell;
            }            
        }
            break;
        case IASKSettingTypeTextField:
        {
            if (!cell) 
            {
                cell = [[[IASKPSTextFieldSpecifierViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleDefault]
                         reuseIdentifier:identifier] autorelease];
                ((IASKPSTextFieldSpecifierViewCell*)cell).textField.textAlignment = UITextAlignmentLeft;
                ((IASKPSTextFieldSpecifierViewCell*)cell).textField.returnKeyType = UIReturnKeyDone;
                ((IASKPSTextFieldSpecifierViewCell*)cell).accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = [settingData title];
            
            NSString *textValue = [self.settingsStore objectForKey:key] != nil ? [self.settingsStore objectForKey:key] : [settingData defaultValue];
            if ( textValue!=nil )
            {
                if (![textValue isMemberOfClass:[NSString class]]) {
                    textValue = [NSString stringWithFormat:@"%@", textValue];
                }
            }         
            
            IASKTextField *textField = [(IASKPSTextFieldSpecifierViewCell*)cell textField];
            [textField setText:textValue];
            if ( settingData.placeHolder.length > 0 )
            {
                textField.placeholder = settingData.placeHolder;
            }
            [textField setKey:key];
            [textField setDelegate:self];
            [textField addTarget:self action:@selector(_textChanged:) forControlEvents:UIControlEventEditingChanged];
            [textField setSecureTextEntry:[[settingData isSecure] boolValue]];
            [textField setKeyboardType:[settingData keyboardType]];
            [textField setAutocapitalizationType:[settingData autoCapitalizationType]];
            if([settingData isSecure]){
                [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            } else {
                [textField setAutocorrectionType:[settingData autoCorrectionType]];
            }
            [cell setNeedsLayout];
        }
            break;
        case IASKSettingTypeOpenUrl:
        {
            if (!cell) 
            {
                cell = [[[IASKPSTitleValueSpecifierViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleValue1]
                          reuseIdentifier:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = [settingData title];
            cell.detailTextLabel.text = [[settingData defaultValue] description];
        }
            break;
        case IASKSettingTypeButton:
        {
            if (!cell)
            {
                cell = [[[IASKUITableViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleValue1]
                          reuseIdentifier:identifier] autorelease];
            }
            cell.accessoryType = settingData.accessoryType;
            if ( settingData.displayValue )
            {
                cell.detailTextLabel.text = nil;
                id value = [self.settingsStore objectForKey:key] ? : [settingData defaultValue];
                if (value)
                {
                    NSString *stringValue;
                    if ([settingData multipleValues] || [settingData multipleTitles]) {
                        stringValue = [settingData titleForCurrentValue:value];
                    } else {
                        stringValue = [value description];
                    }
                    cell.detailTextLabel.text = stringValue;
                } 
            }   
            if ( settingData.valueTextAlignment == UITextAlignmentLeft )
            {
                cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
            }
            else
            {
                cell.detailTextLabel.textAlignment = UITextAlignmentRight;
            }
            if ( settingData.textAlignment == UITextAlignmentCenter )
            {
                UIButton *button = (UIButton *)[cell viewWithTag:0xBBB000];
                if ( button == nil )
                {
                    button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.tag = 0xBBB000;
                    button.backgroundColor = [UIColor clearColor];
                    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                    button.titleLabel.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell addSubview:button];
                    button.userInteractionEnabled = NO;
                }                
                [button setTitle:[settingData title] forState:UIControlStateNormal];               
                [button sizeToFit];
                button.center = CGPointMake(cell.width/2, cell.height/2);
                cell.textLabel.text =@"";
            }
            else
            {
                [[cell viewWithTag:0xBBB000] removeFromSuperview];
                cell.textLabel.text = [settingData title];
            }
        }             
            break;
        case IASKSettingTypeGroup:
        {
            break;
        }
        case IASKSettingTypeRadio:
        {            
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleValue1]
                                                   reuseIdentifier:identifier] autorelease];
                
            }
            id value = [self.settingsStore objectForKey:key];
            BOOL equal = NO;
            if ( [value isKindOfClass:[NSString class]] && [settingData.defaultValue isKindOfClass:[NSString class]])
            {
                equal = [settingData.defaultValue isEqualToString:value];
            }
            else
            {
                equal = [settingData.defaultValue isEqual:value];
            }
            cell.accessoryType = equal?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            [[cell textLabel] setText:[settingData title]];
        }
        break;
        default:
        {
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:
                         [self cellStyleForSettingData:settingData defaultStyle:UITableViewCellStyleValue1]
                        reuseIdentifier:identifier] autorelease];

            }
            [[cell textLabel] setText:[settingData title]];
        }
            break;


    }
    if ( settingData.icon )
    {
        cell.imageView.image = settingData.icon;
        if ( settingData.whiteIcon )
        {
            cell.imageView.highlightedImage = [settingData.icon imageWithColor:[UIColor whiteColor]];
        }
    }
    else
    {
        if ( settingData.iconName.length > 0 )
        {
            cell.imageView.image = [UIImage imageNamed:settingData.iconName];
            if ( settingData.whiteIcon )
            {
                //cell.imageView.highlightedImage = [MiniUIImage imageNamed:settingData.iconName white:YES];
            }
        } 
        else
        {
            cell.imageView.image = nil;
            cell.imageView.highlightedImage = nil;
        }
    }
    cell.textLabel.numberOfLines = 1;
    if ([cell.textLabel.text sizeWithFont:cell.textLabel.font].width > tableView.width*0.7)
    { 
        cell.textLabel.numberOfLines = 0;
    }
    [self correctTableViewCell:cell cellForSettingData:settingData];    
    [cell setNeedsDisplay];
    return cell;
}

- (void)correctTableViewCell:(UITableViewCell*)tableViewCell cellForSettingData:(IASKSettingsData*)specifier
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IASKSettingsData *data = [self.settingsReader settingDataForIndexpath:indexPath];
    if (data.type == IASKSettingTypeGroup)
    {
        return nil;
    }
    else 
    {
		return indexPath;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IASKSettingsData *settingData = [self.settingsReader settingDataForIndexpath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (settingData.type)
    {
        case IASKSettingTypeSwitch:
        {

        }
            break;
        case IASKSettingTypeRadio:
        {
            IASKSettingsData *settingData = [self.settingsReader settingDataForIndexpath:indexPath];
            NSString *key           = settingData.key;
            [self.settingsStore setObject:[settingData defaultValue] forKey:key];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [self didToggledValue:[self.tableView cellForRowAtIndexPath:indexPath] key:key];
            return;
        }
        case IASKSettingTypeMultiValue:
        {
            IASKSpecifierValuesViewController *targetViewController = [[_viewList objectAtIndex:kIASKSpecifierValuesViewControllerIndex] objectForKey:@"viewController"];
            
            if (targetViewController == nil) {
                // the view controller has not been created yet, create it and set it to our viewList array
                // create a new dictionary with the new view controller
                NSMutableDictionary *newItemDict = [NSMutableDictionary dictionaryWithCapacity:3];
                [newItemDict addEntriesFromDictionary: [_viewList objectAtIndex:kIASKSpecifierValuesViewControllerIndex]];	// copy the title and explain strings
                
                targetViewController = [[IASKSpecifierValuesViewController alloc] init];
                // add the new view controller to the dictionary and then to the 'viewList' array
                [newItemDict setObject:targetViewController forKey:@"viewController"];
                [_viewList replaceObjectAtIndex:kIASKSpecifierValuesViewControllerIndex withObject:newItemDict];
                [targetViewController release];
                
                // load the view controll back in to push it
                targetViewController = [[_viewList objectAtIndex:kIASKSpecifierValuesViewControllerIndex] objectForKey:@"viewController"];
            }
            self.currentIndexPath = indexPath;
            targetViewController.currentData = settingData;
            //[targetViewController setCurrentSpecifier:specifier];
            targetViewController.settingsReader = self.settingsReader;
            targetViewController.settingsStore = self.settingsStore;
            [[self navigationController] pushViewController:targetViewController animated:YES];
        }
            break;
        case IASKSettingTypeTextField:
        {
            IASKPSTextFieldSpecifierViewCell *textFieldCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            [textFieldCell.textField becomeFirstResponder];
        }
            break;
        case IASKSettingTypeChildPane:
        {
            Class vcClass = [settingData viewControllerClass];
            if (vcClass) 
            {
                SEL initSelector = [settingData viewControllerSelector];
                if (!initSelector) {
                    initSelector = @selector(init);
                }
                UIViewController  *vc = [vcClass alloc];
                [vc performSelector:initSelector withObject:[settingData file] withObject:[settingData key]];
                if ([vc respondsToSelector:@selector(setDelegate:)])
                {
                    [vc performSelector:@selector(setDelegate:) withObject:self.delegate];
                }
                if ([vc respondsToSelector:@selector(setSettingsStore:)]) 
                {
                    [vc performSelector:@selector(setSettingsStore:) withObject:self.settingsStore];
                }
                self.navigationController.delegate = nil;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
                return;
            }
            
            if (nil == [settingData file]) {
                //[tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }        
            
            IASKAppSettingsViewController *targetViewController = [[_viewList objectAtIndex:kIASKSpecifierChildViewControllerIndex] objectForKey:@"viewController"];
            
            if (targetViewController == nil) {
                // the view controller has not been created yet, create it and set it to our viewList array
                // create a new dictionary with the new view controller
                NSMutableDictionary *newItemDict = [NSMutableDictionary dictionaryWithCapacity:3];
                [newItemDict addEntriesFromDictionary: [_viewList objectAtIndex:kIASKSpecifierChildViewControllerIndex]];	// copy the title and explain strings
                
                targetViewController = [[[self class] alloc] init];
                targetViewController.showDoneButton = NO;
                targetViewController.settingsStore = self.settingsStore; 
                targetViewController.delegate = self.delegate;
                
                // add the new view controller to the dictionary and then to the 'viewList' array
                [newItemDict setObject:targetViewController forKey:@"viewController"];
                [_viewList replaceObjectAtIndex:kIASKSpecifierChildViewControllerIndex withObject:newItemDict];
                [targetViewController release];
                
                // load the view controll back in to push it
                targetViewController = [[_viewList objectAtIndex:kIASKSpecifierChildViewControllerIndex] objectForKey:@"viewController"];
            }
            self.currentIndexPath = indexPath;
            targetViewController.settingViewKey = settingData.file;
            targetViewController.controllTitle = settingData.title;
            targetViewController.showCreditsFooter = NO;
            [targetViewController prepareforReuse];
            [[self navigationController] pushViewController:targetViewController animated:YES];
        }
            break;
        case IASKSettingTypeOpenUrl:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:settingData.file]];    
        }
        break;
        case IASKSettingTypeCustomView:
        {
            if ( [settingData.file hasPrefix:@"http"]) 
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:settingData.file]]; 
            }
            else
            {
                [self didCellButtonTap:[settingData key] cell:[tableView cellForRowAtIndexPath:indexPath]];
            }
        }
            break;
        case IASKSettingTypeButton:
        case IASKSettingTypeTitleValue:
        {
            [self didCellButtonTap:[settingData key] cell:[tableView cellForRowAtIndexPath:indexPath]];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate Functions

- (void)_textChanged:(id)sender {
    IASKTextField *text = (IASKTextField*)sender;
    [_settingsStore setObject:[text text] forKey:[text key]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged
                                                        object:[text key]
                                                      userInfo:[NSDictionary dictionaryWithObject:[text text]
                                                                                           forKey:[text key]]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[textField setTextAlignment:UITextAlignmentLeft];
	self.currentFirstResponder = textField;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.currentFirstResponder = textField;
	if ([_tableView indexPathsForVisibleRows].count) {
		_topmostRowBeforeKeyboardWasShown = (NSIndexPath*)[[_tableView indexPathsForVisibleRows] objectAtIndex:0];
	} else {
		// this should never happen
		_topmostRowBeforeKeyboardWasShown = [NSIndexPath indexPathForRow:0 inSection:0];
		[textField resignFirstResponder];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	self.currentFirstResponder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
	return YES;
}

#pragma mark Keyboard Management
- (void)_keyboardWillShow:(NSNotification*)notification {
    if ( !self.isVisible )
    {
        return;
    }
	if (self.navigationController.topViewController == self) {
		NSDictionary *userInfo = [notification userInfo];
        // we don't use SDK constants here to be universally compatible with all SDKs ≥ 3.0
		NSValue *keyboardFrameValue = [userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
		if (!keyboardFrameValue) {
			keyboardFrameValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
		}
		
		// Reduce the tableView height by the part of the keyboard that actually covers the tableView
		CGRect windowRect = [[UIApplication sharedApplication] keyWindow].bounds;
		if (UIInterfaceOrientationLandscapeLeft == self.interfaceOrientation ||UIInterfaceOrientationLandscapeRight == self.interfaceOrientation ) {
			windowRect = IASKCGRectSwap(windowRect);
		}
		CGRect viewRectAbsolute = [_tableView convertRect:_tableView.bounds toView:[[UIApplication sharedApplication] keyWindow]];
		if (UIInterfaceOrientationLandscapeLeft == self.interfaceOrientation ||UIInterfaceOrientationLandscapeRight == self.interfaceOrientation ) {
			viewRectAbsolute = IASKCGRectSwap(viewRectAbsolute);
		}
		CGRect frame = _tableView.frame;
		frame.size.height -= [keyboardFrameValue CGRectValue].size.height - CGRectGetMaxY(windowRect) + CGRectGetMaxY(viewRectAbsolute);

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
		[UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
		_tableView.frame = frame;
		[UIView commitAnimations];
		
		UITableViewCell *textFieldCell = (id)((UITextField *)self.currentFirstResponder).superview.superview;
		NSIndexPath *textFieldIndexPath = [_tableView indexPathForCell:textFieldCell];

		// iOS 3 sends hide and show notifications right after each other
		// when switching between textFields, so cancel -scrollToOldPosition requests
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[_tableView scrollToRowAtIndexPath:textFieldIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
}


- (void) scrollToOldPosition {
  [_tableView scrollToRowAtIndexPath:_topmostRowBeforeKeyboardWasShown atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)_keyboardWillHide:(NSNotification*)notification {
    if ( !self.isVisible )
    {
        return;
    }
	if (self.navigationController.topViewController == self) {
		NSDictionary *userInfo = [notification userInfo];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
		[UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
		_tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
		[UIView commitAnimations];
		
		//[self performSelector:@selector(scrollToOldPosition) withObject:nil afterDelay:0.1];
	}
}	

#pragma mark Notifications

- (void)synchronizeSettings {
    [_settingsStore synchronize];
}

- (void)reload {
	// wait 0.5 sec until UI is available after applicationWillEnterForeground
	[_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark CGRect Utility function
CGRect IASKCGRectSwap(CGRect rect) {
	CGRect newRect;
	newRect.origin.x = rect.origin.y;
	newRect.origin.y = rect.origin.x;
	newRect.size.width = rect.size.height;
	newRect.size.height = rect.size.width;
	return newRect;
}
#pragma mark -
#pragma mark CGRect ComposeFriendDelegate
- (void)composeFriendSelected:(NSArray*)selectedPeople
{
    
}
@end
