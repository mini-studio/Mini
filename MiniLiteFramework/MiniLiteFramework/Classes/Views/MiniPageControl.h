
#import <Foundation/Foundation.h>

const static NSInteger  KPageControlHeight = 6;
@interface MiniPageControl : UIControl 
{
	NSInteger       _currentPage;
	NSInteger       _numberOfPages;
    UIColor         *_currentPageColor;
    UIColor         *_pageColor;
    BOOL            _hidesForSinglePage;//default is YES
}
@property(nonatomic) NSInteger numberOfPages;
@property(nonatomic) NSInteger currentPage; 
@property(nonatomic) BOOL hidesForSinglePage; 
@property(nonatomic,retain) UIColor *currentPageColor;
@property(nonatomic,retain) UIColor *pageColor;
@end
