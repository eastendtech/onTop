//
//  PhotoScroller.h
//  onTop
//
//  Created by Michael Colson on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoScroller : UIScrollView {
	
	UIImage *imageToShow;
	UIImageView *imageView;
	
}

//@property(retain) UIImage *imageToShow;

-(void)setImageToShow:(UIImage *)image;

@end
