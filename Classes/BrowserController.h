//
//  BrowserController.h
//  iSFW
//
//  Created by Michael Colson on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScroller.h"

@interface BrowserController : UIViewController <UITextFieldDelegate> {

	IBOutlet UIWebView *browser;
	IBOutlet UIView *navBar;
	IBOutlet UIView *bottomBar;
	
	IBOutlet UITextField *urlField, *searchField;
	IBOutlet UIButton *refreshBtn;
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UILabel *pageTitle;
	
	IBOutlet UIButton *backBtn;
	IBOutlet UIButton *fsBtn;
	
	IBOutlet UITextView *editView;
	IBOutlet UIView *overlayView;
	
	IBOutlet UIToolbar *doneBar;
	IBOutlet RolloBuddy *roller;
	IBOutlet UIView *adView; //NEW: 9/9 TapJoy support
	
	BOOL isFS;
	
	//NEW: for browser or photo mode:
	BOOL isBrowser;
	UIImagePickerController *imageChooser;
	PhotoScroller *scroller;
	
	//NEW: for email a note or link
	UIActionSheet *emailSheet;
	
	
}

//-(void)resizeBrowser:(BOOL)big;
-(void)hitRefresh;

-(IBAction)hitEdit;
-(IBAction)hitBack;
-(IBAction)hitKBDone;
-(IBAction)hitPhoto;
-(IBAction)hitBrowse;
-(IBAction)hitFS;
-(IBAction)hitMail;

-(NSString *)editText;
-(NSString *)currentURL;

-(void)setEditText:(NSString *)text;
-(void)loadURL: (NSString *)url;

@end
