//
//  onTopAppDelegate.h
//  onTop
//
//  Created by Michael Colson on 5/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class onTopViewController;

@interface onTopAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    onTopViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet onTopViewController *viewController;

@end

