//
//  ZoomingScrollView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "MWZoomingScrollView.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"

@interface MWZoomingScrollViewIndicatorView : UIView
@property (nonatomic,readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic,readonly) UILabel *label;
@property (nonatomic)bool hidesWhenStopped;
@end

@implementation  MWZoomingScrollViewIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 30, self.width, 22)];
        _indicatorView.center = CGPointMake(self.width/2, 10+ _indicatorView.height/2);
        _label.top = _indicatorView.bottom;
        _label.backgroundColor = [UIColor clearColor];
        _label.text = @"加载中...";
        _label.textAlignment = UITextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:12];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_indicatorView];
        [self addSubview:_label];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)startAnimating
{
    [_indicatorView startAnimating];    
    self.hidden = NO;
}

- (void)stopAnimating
{
    [_indicatorView stopAnimating];
    self.hidden = YES;
}

- (void)setHidesWhenStopped:(bool)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;
    _indicatorView.hidesWhenStopped = hidesWhenStopped;
}

@end

// Declare private methods of browser
@interface MWPhotoBrowser ()
- (UIImage *)imageForPhoto:(id<MWPhoto>)photo;
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
@end

// Private methods and properties
@interface MWZoomingScrollView ()
@property (nonatomic, assign) MWPhotoBrowser *photoBrowser;
@property (nonatomic, assign) MWZoomingScrollViewIndicatorView *spinner;
- (void)handleSingleTap:(CGPoint)touchPoint;
- (void)handleDoubleTap:(CGPoint)touchPoint;
@end

@implementation MWZoomingScrollView

@synthesize photoBrowser = _photoBrowser, photo = _photo, captionView = _captionView;

- (id)initWithPhotoBrowser:(MWPhotoBrowser *)browser {
    if ((self = [super init])) {
        
        // Delegate
        self.photoBrowser = browser;
        
		// Tap view for background
		_tapView = [[MWTapDetectingView alloc] initWithFrame:self.bounds];
		_tapView.tapDelegate = self;
		_tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_tapView.backgroundColor = browser.backgroundColor;
		[self addSubview:_tapView];
		
		// Image view
		_photoImageView = [[MWTapDetectingImageView alloc] initWithFrame:CGRectZero];
		_photoImageView.tapDelegate = self;
		_photoImageView.contentMode = UIViewContentModeCenter;
		_photoImageView.backgroundColor = browser.backgroundColor;
		[self addSubview:_photoImageView];
		
		// Spinner
        Class clazz = [browser scrollViewIndicatorViewClass];
        if ( clazz != nil )
        {
            _spinner = [[clazz alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        }
        else
        {
            _spinner = [[MWZoomingScrollViewIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        }
		_spinner.hidesWhenStopped = YES;
		_spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:_spinner];
        _spinner.hidden = YES;
		
		// Setup
		self.backgroundColor = browser.backgroundColor;
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}


- (void)dealloc {
	[_tapView release];
	[_photoImageView release];
	[_spinner release];
    [_photo release];
	[super dealloc];
}

- (void)setPhoto:(id<MWPhoto>)photo {
    _photoImageView.image = nil; // Release image
    if (_photo != photo) {
        [_photo release];
        _photo = [photo retain];
    }
    [self displayImage];
}

- (void)prepareForReuse {
    self.photo = nil;
    [_captionView removeFromSuperview];
    self.captionView = nil;
}

- (void)setLoadingTitle:(NSString *)loadingTitle
{
    self.spinner.label.text = loadingTitle;
}

#pragma mark - Image

// Get and display image
- (void)displayImage {
	if (_photo && _photoImageView.image == nil) {
		
		// Reset
		self.maximumZoomScale = 1;
		self.minimumZoomScale = 1;
		self.zoomScale = 1;
		self.contentSize = CGSizeMake(0, 0);
		
		// Get image from browser as it handles ordering of fetching
		UIImage *img = [self.photoBrowser imageForPhoto:_photo];
		if (img) {
			
			// Hide spinner
			[_spinner stopAnimating];
			
			// Set image
			_photoImageView.image = img;
			_photoImageView.hidden = NO;
			
			// Setup photo frame
			CGRect photoImageViewFrame;
			photoImageViewFrame.origin = CGPointZero;
			photoImageViewFrame.size = img.size;
			_photoImageView.frame = photoImageViewFrame;
			self.contentSize = photoImageViewFrame.size;

			// Set zoom to minimum zoom
			[self setMaxMinZoomScalesForCurrentBounds];
			
		} else {
			
			// Hide image view
			_photoImageView.hidden = YES;
			[_spinner startAnimating];
			
		}
		[self setNeedsLayout];
	}
}

// Image failed so just show black!
- (void)displayImageFailure {
	[_spinner stopAnimating];
}

#pragma mark - Setup

- (void)setMaxMinZoomScalesForCurrentBounds {
	
    if ( self.photo == nil )
    {
        return;
    }
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail
	if (_photoImageView.image == nil) return;
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
	
	// If image is smaller than the screen then ensure we show it at
	// min scale of 1
	if (xScale > 1 && yScale > 1) {
		minScale = 1.0;
	}
    
	// Calculate Max
	CGFloat maxScale = 2.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	
	// Set
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
	
	// Reset position
	_photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
	[self setNeedsLayout];

}

#pragma mark - Layout

- (void)layoutSubviews {
	
	// Update tap view frame
	_tapView.frame = self.bounds;
	
	// Spinner
	if (!_spinner.hidden) _spinner.center = CGPointMake(floorf(self.bounds.size.width/2.0),
													  floorf(self.bounds.size.height/2.0) );
	// Super
	[super layoutSubviews];
	
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
		_photoImageView.frame = frameToCenter;
	
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _photoImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[_photoBrowser cancelControlHiding];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
	[_photoBrowser cancelControlHiding];
    if (self.zoomScale == self.maximumZoomScale)  {
        [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_ZOOM_OUT_NOTIFICATION object:_photo];
    }
    else {
         [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_ZOOM_IN_NOTIFICATION object:_photo];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	//[_photoBrowser hideControlsAfterDelay];
}

#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
	[_photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
	
	// Cancel any single tap handling
	[NSObject cancelPreviousPerformRequestsWithTarget:_photoBrowser];
    
    if ( ![_photoBrowser reseponseDoubleClickControls] ) {
        return;
    }
	
	// Zoom
	if (self.zoomScale == self.maximumZoomScale) {
		
		// Zoom out
		[self setZoomScale:self.minimumZoomScale animated:YES];
        [_photoBrowser cancelControlHidingImmediately];
        //[[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_ZOOM_OUT_NOTIFICATION object:_photo];
		
	} else {
		
		// Zoom in
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
        [_photoBrowser hideControlsImmediately];
		//[[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_ZOOM_IN_NOTIFICATION object:_photo];
	}
	
	// Delay controls
	//[_photoBrowser hideControlsAfterDelay];
	
}

// Image View
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch { 
    [self handleSingleTap:[touch locationInView:imageView]];
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:view]];
}
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:view]];
}

@end
