//
//  YLSettingsData.m
//  YLSettings
//
//  Created by lipeiqiang on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "IASKSettingsData.h"
#import "IASKSettingsReader.h"

@implementation IASKSettingsData
@synthesize  type;
@synthesize  title;
@synthesize  subTitle;
@synthesize  footerText;
@synthesize  key;
@synthesize  file;
@synthesize  defaultValue;
@synthesize  minimumValue;
@synthesize  maximumValue;
@synthesize  trueValue;
@synthesize  falseValue;
@synthesize  isSecure;
@synthesize  keyboardType;
@synthesize  autoCapitalizationType;
@synthesize  autoCorrectionType;
@synthesize  accessoryType;
@synthesize  displayValue;
@synthesize  placeHolder;
@synthesize  textAlignment;
@synthesize valueTextAlignment;
@synthesize autoSaveDefaultValue;

@synthesize  multipleTitles;
@synthesize  multipleValues;

@synthesize iconName;
@synthesize childArray;

@synthesize IASKViewControllerClass;
@synthesize IASKViewControllerSelector;
@synthesize settingButtonClass;
@synthesize settingButtonSelector;
@synthesize whiteIcon;
@synthesize itemId;
@synthesize icon;
@synthesize cellStyle;
@synthesize userInfo;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.displayValue = YES;
        self.whiteIcon = YES;
        self.autoSaveDefaultValue = YES;
        self.valueTextAlignment = UITextAlignmentRight;
    }
    return self;
}
-(void)dealloc
{
    [placeHolder release];
    [icon release];
    [itemId release];
    [userInfo release];
    [subTitle release];
    [title release];
    [footerText release];
    [key release];
    [file release];
    [defaultValue release];
    [minimumValue release];
    [maximumValue release];
    [trueValue release];
    [falseValue release];
    [isSecure release];
    [multipleValues release];
    [multipleTitles release];
    
    [iconName release];
    [childArray release];
    [IASKViewControllerClass release];
    [IASKViewControllerSelector release];
    
    [settingButtonClass release];
    [settingButtonSelector release];
    [super dealloc];
}

- (NSString*)titleForCurrentValue:(id)currentValue {
	NSArray *values = [self multipleValues];
	NSArray *titles = [self multipleTitles];
	if (values.count != titles.count) {
		return nil;
	}
    NSInteger keyIndex = [values indexOfObject:currentValue];
	if (keyIndex == NSNotFound) {
		return nil;
	}
	@try {
        return [titles objectAtIndex:keyIndex];
	}
	@catch (NSException  *e) {}
	return nil;
}


- (Class)viewControllerClass
{
    return  NSClassFromString(self.IASKViewControllerClass);
}
- (SEL)viewControllerSelector
{
    return NSSelectorFromString(self.IASKViewControllerSelector);
}
-(Class)buttonClass {
    return NSClassFromString(self.settingButtonClass);
}

-(SEL)buttonAction {
    return NSSelectorFromString(self.settingButtonSelector);
}

- (void)setDefaultValue:(id)aDefaultValue
{
    [aDefaultValue retain];
    [defaultValue release];
    defaultValue = aDefaultValue;    
    if ( self.key.length > 0 && defaultValue != nil )
    {
        if ( autoSaveDefaultValue )
        {
            id value = [[NSUserDefaults standardUserDefaults] valueForKey:self.key];
            if ( value == nil ) 
            {
                [[NSUserDefaults standardUserDefaults] setValue:defaultValue forKey:self.key];            
            }
        }
    }    
}
@end
