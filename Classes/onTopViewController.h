//
//  onTopViewController.h
//  onTop
//
//  Created by Michael Colson on 5/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserController.h"

@interface onTopViewController : UIViewController {

	BrowserController *bc;
}

-(void)setURL:(NSString *)browseIt;
-(void)setNote:(NSString *)note;
-(NSString *)getURL;
-(NSString *)getNote;

@end

