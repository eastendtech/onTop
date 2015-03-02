//
//  RolloBuddy.m
//  iFarty
//
//  Created by Michael Colson on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RolloBuddy.h"


@implementation RolloBuddy
@synthesize isOnTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	rolloView = [ARRollerView requestRollerViewWithDelegate:self];
	/*
	adfonicView = [ [UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	[adfonicView loadHTMLString:@"<script src='http://adfonic.net/js/c0c767d3-b027-4510-b3d6-4237a23d782f'/>" baseURL:[NSURL urlWithString:@"http://adfonic.net/js"]];
    */
	
	[self.view addSubview:rolloView];
	[self.view bringSubviewToFront:rolloView];
	[self retain];
	//[self.view setHidden:NO];
	searchString = @"";
	missCount = 0;
}

- (void)rollerDidReceiveAd:(ARRollerView*)adWhirlView
{
	NSLog(@"Roller fetch.");
	if (!isOnTimer)
	 [self.view setHidden:NO];
}

-(NSString *)adWhirlApplicationKey
{
	//NSLog(@"Key.");
	return @"30e9205fa10b102c967e64cbcea5d127";
}

-(void)timerTick:(NSTimer *)timer;
{
	if ([rolloView adExists])
		[rolloView getNextAd];
	/*
	else
	{
		NSLog(@"Defaulting search string...");
		searchString = @"iPhone games";
	}
	*/
	//NSLog(@"tick.");
}

- (void)rollerDidFailToReceiveAd:(ARRollerView*)adWhirlView usingBackup:(BOOL)YesOrNo;
{
	NSLog(@"failed.");
	
}


-(void)startTimer
{
	if (!timer)
	{
		timer = [NSTimer  timerWithTimeInterval:30.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
		[timer retain];
		[ [NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode ];
	}
}

-(void)setSearchString:(NSString *)search
{
	searchString = [search copy];
}

- (NSString*)searchString
{
	//NSLog(@"Searching: %@",searchString);
	return searchString;
	
}


-(void)stopTimer
{
	if (timer)
	{
		[timer invalidate];
		[timer release];
		timer = nil;
	}
}


- (void)rollerReceivedRequestForDeveloperToFulfill:(ARRollerView*)adWhirlView
{
	//NSLog(@"El Custom Request");
	if (adfonicView)
		[adfonicView release];
		
	adfonicView = [ [UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	[adfonicView setDelegate:self];
	[adfonicView loadHTMLString:@"<script src='http://adfonic.net/js/10958615-0b2b-4a4a-b666-d57821482362'/>" baseURL:[NSURL  URLWithString:@"http://adfonic.net/js"]];
   
	
	[rolloView replaceBannerViewWith:adfonicView];
	
	if (!isOnTimer)
		self.view.hidden = NO;
}

//----------------------AdFonic web view delegate-------------------------------//
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //[[UIApplication sharedApplication] openURL:request.URL];
		
		AdBrowser *browser = [ [AdBrowser alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[browser setDelegate:self];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.window cache:YES];
		
		[self.view.window addSubview:browser];
		[browser visitURL:[[request URL] absoluteString]];
		
		[UIView commitAnimations];
		
		
		
		
        return false;
    }
    return true;
}


//---------------------End AdFonic web view delegate---------------------------//

/*
 
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


@end
