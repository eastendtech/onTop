//
//  BrowserController.m
//  iSFW
//
//  Created by Michael Colson on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowserController.h"


@implementation BrowserController


//-----------------------------Browser Delegates------------------------------//
- (void)webViewDidFinishLoad:(UIWebView *)wv
{
	[spinner stopAnimating];
	if (isFS)
		spinner.backgroundColor =  [UIColor clearColor]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
	
	//Get the title of the page to put in the label using JS:
	NSString *ptitle = [browser stringByEvaluatingJavaScriptFromString:@"document.title;"];
	[pageTitle setText:ptitle];
	NSString *loc  = [browser stringByEvaluatingJavaScriptFromString:@"document.URL;"];
	[urlField setText:loc];

	
	[refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
	[refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateHighlighted];
    
	if ([browser canGoBack])
	{
	   //[backBtn setImage:[UIImage imageNamed:@"bk.png"]]; BUGFIX: NOT NEEDED
	   [backBtn setEnabled:YES];
	}
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	spinner.hidden = NO;
	[spinner startAnimating];
	if (isFS)
		spinner.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	
	[refreshBtn setImage:[UIImage imageNamed:@"XBtn.png"] forState:UIControlStateNormal];
	[refreshBtn setImage:[UIImage imageNamed:@"XBtn.png"] forState:UIControlStateHighlighted];

	
	return YES;
}

//TODO: Implement Error Checking.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[spinner stopAnimating];
	if (isFS)
		spinner.backgroundColor =  [UIColor clearColor];
	
	[refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
	[refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateHighlighted];
		
	if ([error code] != -999)
	{
	  UIAlertView *errorAlert = [ [UIAlertView alloc] initWithTitle:@"Error Loading Page" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	  [refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
	  [refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateHighlighted];
	  [errorAlert show];
	}
}

//------------------------------End Delegate---------------------------------//

//-------------------------------Refresh Button----------------//
-(void)hitRefresh
{
	if ([browser isLoading])
	{
		[browser stopLoading];
		[spinner stopAnimating];
		if (isFS)
			spinner.backgroundColor =  [UIColor clearColor];
		[refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
		[refreshBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateHighlighted];

	}
	else
	{
		[browser reload];
	}
}

//-----------------------End Refresh Button-------------------//

//Back action for browser navigation
-(IBAction)hitBack
{
	[browser goBack];
	
	if (![browser canGoBack])
	{
		//[backBtn setImage:[UIImage imageNamed:@"bkg.png"]]; BUGFIX: NOT NEEDED
		[backBtn setEnabled:FALSE];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[browser setDelegate:self];
	
	[urlField setDelegate:self];
	[searchField setDelegate:self]; //BUGFIX: Forgot to do this.
	
	spinner.hidesWhenStopped = YES;
	[refreshBtn addTarget:self action:@selector(hitRefresh) forControlEvents:UIControlEventTouchDown];
	isBrowser = YES; //Browser is startup by default
	isFS = NO;
	
	/*
	adView = [[TapjoyConnect requestTapjoyConnectWithDelegate:nil] 
			  showAdBox:1 rect:CGRectMake(0, 0, 320, 50)]; 
	[roller addSubview:adView];
    [roller bringSubviewToFront:adView];
	 */
	
	
}

//--------------------------------Text Delegates-----------------------//

//TODO: Make the search box grow in size when clicked and include a cancel button
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[editView resignFirstResponder];
	[doneBar setHidden:YES];
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	/*
	if (textField == urlField)
	{
		//Main URL Loading code:
		//1. Test if string has a protocol: (TODO: Add Exception Handling)
		NSString *url = textField.text;
		if ([url length] > 0 )
		{
		  NSRange r = [url rangeOfString:@"://"];
		  if (r.location == NSNotFound)
		  {
			url = [NSString stringWithFormat:@"http://%@",url];
		  }
		
		NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[browser loadRequest:req];
		}
	}
	*/
	if (textField == urlField)
	{
		//Main URL Loading code:
		//1. Test if string has a protocol: (TODO: Add Exception Handling)
		NSString *url = textField.text;
		if ([url length] > 0 )
		{
			if ([url hasPrefix:@"javascript:"])
			{
				url = [url substringFromIndex:11];
				NSLog(@"url: %@",url);
				NSString * res = [browser stringByEvaluatingJavaScriptFromString:url];
			}
			else
			{	
				NSRange r = [url rangeOfString:@"://"];
				if (r.location == NSNotFound)
				{
					url = [NSString stringWithFormat:@"http://%@",url];
				}
				
				NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
				[browser loadRequest:req];
			}
		}
	}
	
	else
	{
		NSString *query = textField.text;
		//[roller setSearchString:query];
		query = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		NSString *url = [NSString stringWithFormat:@"http://www.google.com/?q=%@",query];
		NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[browser loadRequest:req];
		//[urlField setText:url];
		
	}
	
	[textField resignFirstResponder];
	return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)tV
{
	//TODO: Check it.
	CGFloat frameHeight = (isFS) ? 165 : 97;
	//if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
	//	frameHeight -= 3;
	
	//CGFloat frameWidth  = ([self interfaceOrientation] == UIInterfaceOrientationPortrait) ? 320 : 480;
	
	if (!isBrowser)
		frameHeight += 60;	
	
	/*
	if ([self interfaceOrientation] != UIInterfaceOrientationPortrait)
	{
		[navBar setHidden:YES];
	}
	*/
	[doneBar setHidden:NO];
	[self.view bringSubviewToFront:doneBar];
	//[tV scrollRangeToVisible:NSMakeRange([tV.text length], 0)];
	[editView setFrame:CGRectMake(0, 49, 320, frameHeight)];	
	
	return YES;
}

-(IBAction)hitKBDone
{
	CGFloat frameHeight,frameWidth;
	/*
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
	{
		frameHeight = (isFS) ? 436 : 316;
		frameWidth  = 320;
	}
	else
	{
		frameHeight = (isFS) ? 276 : 216;//156; //216
		frameWidth = 480;
	}
	
	if (!isBrowser)
	{
		frameHeight += 60;
	}
	*/
	
	[editView resignFirstResponder];
	[editView setFrame:CGRectMake(0, 49, 320, (isFS) ? 436 : 316)];
    [doneBar setHidden:YES];
	

	
}

- (BOOL)textViewShouldEndEditing:(UITextView *)tV
{
		
	return YES;
	
}

//--------------------------------End Text Delegates------------------//
//TODO: Make it where leaving editing stops ad rotation.
//Edit button delegate:
-(IBAction)hitEdit
{
	//editView.hidden =  !(editView.hidden) ?  NO : YES;
	overlayView.hidden = (overlayView.hidden) ? NO : YES;
	if (!overlayView.hidden)
	{
		[editView becomeFirstResponder];
		[roller startTimer]; 
		//adView = [[TapjoyConnect requestTapjoyConnectWithDelegate:nil] 
				 // showAdBox:1 rect:CGRectMake(0, 0, 320, 50)]; 
		//[roller addSubview:adView];
		
		
				
		//[self.view.window makeFirstResponder:editView];
	  /*
	  if ([self interfaceOrientation] != UIInterfaceOrientationPortrait)
	  {
		[navBar setHidden:YES];
	  }
	   */
	}
	else
	{
		[roller stopTimer];
		[adView removeFromSuperview];

	}
		
}

//end edit button delegate:

//Full screen button:
-(IBAction)hitFS
{
	CGRect r = navBar.frame;
	CGRect r2 = bottomBar.frame;
	r.origin.y = (r.origin.y == 0) ? -80 : 0;
	
			
	isFS ^= 1; //(r2.origin.y < 481) ? NO : YES;
    //if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
	//{
		r2.origin.y = (isFS) ? 481 : 418;
	//}
	//else
	    //r2.origin.y = (isFS) ? 321 : 265;
	
		
	[UIView beginAnimations:nil	context:0];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.4
	];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	CGRect f = overlayView.frame;
	if (isFS)
	{
		//BUGFIX: Overlay view is now higher & taller b/c of no status bar
		[ [UIApplication sharedApplication] setStatusBarHidden:YES animated:YES  ];
		f.origin.y = -20;
		f.size.height=480;
		//[self.view bringSubviewToFront:fsBtn];
		[overlayView setFrame:f];
		
		//if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		[editView setFrame:CGRectMake(0, 49, 320, 436)];
		//else
		   //[editView setFrame:CGRectMake(0, 49, 480, 276)];
	}
	else
	{
		[ [UIApplication sharedApplication] setStatusBarHidden:NO animated:YES  ];
        
		//BUGFIX: Height & Location adjustment for photo mode when there is no URL bar.
		if (isBrowser)
		{
		  f.origin.y = 60;
		  f.size.height=356;
		  //if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)	
		     [editView setFrame:CGRectMake(0, 49, 320, 318)];
		  //else
			 //[editView setFrame:CGRectMake(0,49,480,156)];
	
		}
		else 
		{
			f.origin.y = 0;
			f.size.height=416; //(height + 60)
			//if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
			  [editView setFrame:CGRectMake(0, 49, 320, 378)]; //(height+60)
			//else
			  //[editView setFrame:CGRectMake(0, 49, 480, 218)]; //(height+60)
	
		}

		[overlayView setFrame:f];
	}
	
	[navBar setFrame:r];
	[bottomBar setFrame:r2];
	fsBtn.backgroundColor = (!isFS) ? [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] : [UIColor clearColor];

	[UIView commitAnimations];
	[self.view bringSubviewToFront:fsBtn];
    [self.view bringSubviewToFront:bottomBar];
	
}
//End full screen button;

//browse button
-(IBAction)hitBrowse
{
	//Animate in the browser:
	if (!isBrowser)
	{
		[self.view addSubview:browser];
		CATransition *applicationLoadViewIn = [CATransition animation];
		[applicationLoadViewIn setDuration:0.5];
		[applicationLoadViewIn setType:kCATransitionPush];
		[applicationLoadViewIn setSubtype:kCATransitionFromRight];
		[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
		[[self.view layer] addAnimation:applicationLoadViewIn forKey:kCATransitionPush];
		
		if (scroller)
		{
		  [scroller removeFromSuperview];
		  [scroller release];
		  scroller = nil;	
		}
		isBrowser = YES;
		[self.view bringSubviewToFront:bottomBar];
		[self.view bringSubviewToFront:fsBtn];
		[self.view bringSubviewToFront:navBar];
		[self.view bringSubviewToFront:overlayView];
		[self.view bringSubviewToFront:spinner];
        
		//Downsize the overlay view (NEW)
        CGRect f = overlayView.frame;
		f.origin.y = 60;
		
		//TODO: Set height
		f.size.height=356;
		//CGFloat frameWidth = ([self interfaceOrientation] == UIInterfaceOrientationPortrait) ? 320 : 480;
		
		[editView setFrame:CGRectMake(0, 49, 320, 318)];
		[overlayView setFrame:f];
	}
}

//Photo button:
-(IBAction)hitPhoto
{
	//Do the photo chooser:
	//if (isBrowser)
	//{
		if (!imageChooser)
		{
			imageChooser = [ [UIImagePickerController alloc] init];
			imageChooser.delegate = self;
			imageChooser.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		[self presentModalViewController:imageChooser animated:YES];
		isBrowser = NO;
	//}
}

//--------------------------------------------Photo Chooser Delegate--------------------------------------//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
   
	[picker dismissModalViewControllerAnimated:YES];
    CGRect frame; //= CGRectMake(0,-20,320,500);
	//if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		frame = CGRectMake(0,-20,320,480);
	//else
		//frame = CGRectMake(0,-20,480,340);
	
	
   //Setup the photo scroller view & animate it in properly:
   if(scroller)
   {
	   //[scroller release];
	   [scroller removeFromSuperview];
	   [scroller release];
	   scroller = nil;	
   }
   scroller = [[PhotoScroller alloc] initWithFrame:frame];
   [scroller setImageToShow:image];
   [image release];	
	
	[self.view addSubview:scroller];
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.5];
	[applicationLoadViewIn setType:kCATransitionPush];
	[applicationLoadViewIn setSubtype:kCATransitionFromLeft];
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];	
	[browser removeFromSuperview];
	[self.view bringSubviewToFront:bottomBar];
	[self.view bringSubviewToFront:fsBtn];
	[self.view bringSubviewToFront:overlayView];

	//Size the new overlay view (NEW):
	CGRect f = overlayView.frame;
	f.origin.y = 0;
	
	//TODO: Adjust for landscape
	f.size.height=416; //(height + 60)
	//CGFloat frameWidth = ([self interfaceOrientation] == UIInterfaceOrientationPortrait) ? 320 : 480;
	[editView setFrame:CGRectMake(0, 49, 320, 378)]; //(height+60)
	[overlayView setFrame:f];
	
	[imageChooser release];
	imageChooser = nil;
	
}

//-------------------------------------------End Photo Chooser Delegate----------------------------------//


-(IBAction)hitMail
{
	
	emailSheet = [ [UIActionSheet alloc] init] 	;
	

	
	[emailSheet addButtonWithTitle:@"Email Notes"];
	if (isBrowser)
	{
		[emailSheet addButtonWithTitle:@"Email Link"];
		[emailSheet addButtonWithTitle:@"Open in Safari"];
	}
	[emailSheet addButtonWithTitle:@"Cancel"];
	[emailSheet setCancelButtonIndex: (isBrowser) ?  3 : 1];
	[emailSheet setDelegate:self];
	
	[emailSheet showInView:self.view];
	
}


//-----------------------------------Action Sheet Delegate------------------------------//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[actionSheet release];
	switch (buttonIndex) 
	{
		case 0:
		{
			NSString *mailto = [NSString stringWithFormat:@"mailto:?body=%@", [[editView text] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailto] ];
		}
		break;
		case 1:
		{
			if (isBrowser)
			{
				NSString *mailto = @"mailto:?body=%0d%0a%3Ca%20href%3D%22"; //, [[browser stringByEvaluatingJavaScriptFromString:@"document.URL;"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
				NSString *location = [[browser stringByEvaluatingJavaScriptFromString:@"document.URL;"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				mailto = [mailto stringByAppendingString:location];
				mailto = [mailto stringByAppendingFormat:@"%@%@%@",@"%22%3E",location,@"%3C/a%3E%0d%0a"]; //@"%22%3EClick%20To%20Hear%20It!%3C/a%3E%0d%0a"];
				
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailto] ];

			}
		}
		break;
		
		case 2:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[browser stringByEvaluatingJavaScriptFromString:@"document.URL;"] ]];
		break;
		
	}
	
	
}
//-----------------------------------End Action Sheet Delegate-------------------------//
//URL Loading Code:

//--End URL Code.

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



- (void)dealloc {
    [super dealloc];
}


//NEW: This function will resize the new views and will always size with fullscreen in mind
//NOTE: The "big" flag means landscape when set.
/*
-(void)resizeBrowser:(BOOL)big;
{
	
	if (big)
	{
	  
	  CGRect f = browser.frame;
	  
	  //f.size.width = 480;
	  //f.size.height=320;	
	  //f.origin.y = -20;
	  //f.size.height=216;			
	 //[browser setFrame:f];
	   
	f = navBar.frame;
	f.size.width=480;
	
	[navBar setFrame:f];
	
	f = pageTitle.frame; 	
	f.size.width=480;
	
	[pageTitle setFrame:f];	
	
	f = searchField.frame;
	f.size.width = 240;
	[searchField setFrame:f];
	
	if (isFS)
		bottomBar.hidden = YES;
	else
		bottomBar.hidden = NO;
		
	  f= bottomBar.frame;
	  f.origin.y = 265;
	  //f.size.height = 42;
	  f.size.width = 429;
	  [bottomBar setFrame:f];
	
		
	f= fsBtn.frame;
	f.origin.y = 265;
	f.origin.x = 431;
		
	//f.size.height = 42;
	//f.size.width = 49;
	[fsBtn setFrame:f];	
	
	//Done bar
	f = doneBar.frame;
	f.origin.y=97;
	f.size.width=480;	
	[doneBar setFrame:f];
		
	//Overlay view:
	f = overlayView.frame;
	if (isFS)
	{
	   f.origin.y = -20;
	   f.size.height = 340;
	}
	else
	{
		f.origin.y = 0;
		f.size.height = 260;
	}
	f.size.width=480;
	[overlayView setFrame:f];
	
	if (isFS)	
	[editView setFrame:CGRectMake(0, 49, 480, 218)];	
	else
	[editView setFrame:CGRectMake(0, 49, 480, 218)];		
		
	if (!overlayView.hidden)
		[navBar setHidden: YES];
		
		if (scroller)
		{
			f = CGRectMake(0,-20,480,320);
			[scroller setFrame:f];
		}	
	}
	else
	{
		
		CGRect f = browser.frame;
		
		
		//f.size.width = 320;
		//f.size.height=480;
		
		//f.origin.y = -20;
		//[browser setFrame:f];
		
		
		f = navBar.frame;
		f.size.width=320;
		[navBar  setFrame:f];
				
		f = pageTitle.frame; 	
		f.size.width=320;
		
		[pageTitle  setFrame:f];
	
		f = searchField.frame;
		f.size.width = 77;
		[searchField setFrame:f];
		
		if (isFS)
			bottomBar.hidden = YES;
		else
			bottomBar.hidden = NO;
			
		  f= bottomBar.frame;
		  f.origin.y = 418;
		  f.size.width = 269;
		  [bottomBar setFrame:f];
		
		f= fsBtn.frame;
		f.origin.y = 418;
		f.origin.x = 271;
		
		//f.size.height = 42;
		//f.size.width = 49;
		[fsBtn setFrame:f];	
		
		//Done bar
		f = doneBar.frame;
		f.origin.y=205;
		f.size.width=320;	
		[doneBar setFrame:f];
		
		if(!isFS && ![editView isFirstResponder])
		  [editView setFrame:CGRectMake(0, 49, 320, 316)];
		else if (isFS && ![editView isFirstResponder])
		  [editView setFrame:CGRectMake(0, 49, 320, 436)];	
				
		//Overlay view:
		f = overlayView.frame;
		if (isFS)
		{
			f.origin.y = -20;
			f.size.height = 500;
		}
		else
		{
			f.origin.y = 60;
			f.size.height = 357;
		}
		f.size.width=480;
		[overlayView setFrame: f];
		[navBar setHidden:NO];

		if (scroller)
		{
			f = CGRectMake(0,-20,320,480);
			[scroller setFrame:f];
			//[scroller invalidate];
		}
		
		
	}
	
}
*/
//-----------------------------------------Functions for setting and retrieving state----------------------//

-(void)setEditText:(NSString *)text
{
	editView.text = text;
}

-(void)loadURL: (NSString *)url
{
	[urlField setText:url];
	[browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(NSString *)editText 
{
	return [editView text];
}

-(NSString *)currentURL
{
	return [browser stringByEvaluatingJavaScriptFromString:@"document.URL;"];
}


@end
