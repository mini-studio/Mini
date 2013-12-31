//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MWPhoto.h"
#import "MWPhotoProtocol.h"
#import "MWCaptionView.h"
#import "MiniViewController.h"

// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define MWLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define MWLog(x, ...)
#endif

// Delgate
@class MWPhotoBrowser;
@protocol MWPhotoBrowserDelegate <NSObject>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser;
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
@optional
- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
@end

// MWPhotoBrowser
@interface MWPhotoBrowser : MiniViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> 

// Properties
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic) BOOL displayToolBar;
// Init
- (id)initWithPhotos:(NSArray *)photosArray  __attribute__((deprecated)); // Depreciated
- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

- (void)setCurrentPageIndex:(NSInteger)index;

- (void)setDelegate:(id <MWPhotoBrowserDelegate>)delegate;

- (NSUInteger)numberOfPhotos;


- (NSInteger)currentPageIndex;

- (void)showProgressHUDWithMessage:(NSString *)message;

- (void)hideProgressHUD:(BOOL)animated;

- (void)loadAdjacentPhotosIfNecessary:(id<MWPhoto>)photo;

- (UIScrollView*)pagingScrollView;

- (UIColor *)backgroundColor;

- (Class)scrollViewIndicatorViewClass;

- (void)cancelControlHidingImmediately;
- (void)hideControlsImmediately;

- (BOOL)reseponseDoubleClickControls;

@end


