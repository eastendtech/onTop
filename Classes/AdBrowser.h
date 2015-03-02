//
//  AdBrowser.h
//  AdProject
//
//  Created by Michael Colson on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBiosDelegate.h"

@interface AdBrowser : UIView {

	UIWebView *adView;
	UIToolbar *closeBar;
	UIBarButtonItem *doneItem;
	
	id<AdBiosDelegateProtocol> adDelegate;
}

-(void)visitURL:(NSString *)url;
-(void)hitDone;
-(void)setDelegate:(id<AdBiosDelegateProtocol>)del;

@end
