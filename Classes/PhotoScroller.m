//
//  PhotoScroller.m
//  onTop
//
//  Created by Michael Colson on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotoScroller.h"

//@synthesize imageToShow;

@implementation PhotoScroller

//Set the image to show and make sure that it is the scroll view's content width:
-(void)setImageToShow:(UIImage *)image
{
	if (imageToShow)
	{
		[imageToShow release];
	}
	imageToShow = [image retain];
	//CGRect frame= (CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
	[imageView setImage:imageToShow];
	
	[self setContentSize:[imageToShow size]];
	
}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
	{
		//[self setZooming:YES];	
		[self setMinimumZoomScale:1.0];
		[self setMaximumZoomScale:4.0];
	    imageView = [ [UIImageView alloc] initWithFrame:frame];	
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		
		[self addSubview:imageView];
		[self setDelegate:self];
	}
    return self;
}

//---------------------------------------Scroll View Delegate---------------------------------------//
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	//imageView.scale = scale;	
}
//--------------------------------------End Scroll View Delegate-----------------------------------//


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
	[imageToShow release];
}


@end
