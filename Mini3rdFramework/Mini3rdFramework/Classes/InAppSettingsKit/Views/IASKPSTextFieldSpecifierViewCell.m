//
//  IASKPSTextFieldSpecifierViewCell.m
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

#import "IASKPSTextFieldSpecifierViewCell.h"
#import "IASKTextField.h"
#import "IASKSettingsReader.h"

@implementation IASKPSTextFieldSpecifierViewCell

@synthesize textField=_textField;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        // Initialization code
        _textField = [[IASKTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        //_textField.borderStyle = UITextBorderStyleLine;
        [self.contentView insertSubview:_textField aboveSubview:self.textLabel];
        // [self.contentView addSubview:_toggle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
	labelSize.width = MIN(labelSize.width, self.textLabel.width);
	CGRect textFieldFrame = _textField.frame;
    textFieldFrame.size.height = _textField.font.pointSize + 6;
    textFieldFrame.origin.y = (self.contentView.height - textFieldFrame.size.height)/2;
	textFieldFrame.origin.x = self.textLabel.frame.origin.x + labelSize.width + kIASKSpacing;
	if (!self.textLabel.text.length)
		textFieldFrame.origin.x = 10;
	textFieldFrame.size.width = _textField.superview.frame.size.width - textFieldFrame.origin.x  - 10;
	_textField.frame = textFieldFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
