//
//  onTopViewController.m
//  onTop
//
//  Created by Michael Colson on 5/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "onTopViewController.h"

@implementation onTopViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	bc = [ [BrowserController alloc] initWithNibName:@"BrowserView" bundle:nil];
	[self.view addSubview:bc.view];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
}

/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (toInterfaceOrientation != UIInterfaceOrientationPortrait)
	{
		CGRect f = bc.view.frame;
		f.size.width = 480;
		bc.view.frame = f;
		
		[bc resizeBrowser:YES];
		
	}
	else
	{
		
		CGRect f = bc.view.frame;
		f.size.width = 320;
		f.size.height = 480;
		//if ([[UIApplication sharedApplication] isStatusBarHidden])
		//f.origin.y = 20;
		
		bc.view.frame = f;
		
		//CGRect b = [self.view frame];  ///[[UIScreen mainScreen] applicationFrame]; //[self.view frame]; //[[UIScreen mainScreen] bounds];
		//b.origin.y=20;
		//bc.view.frame = b;
		//[self.view setFrame:b];
		[bc resizeBrowser:NO];
	}
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

-(void)setURL:(NSString *)browseIt
{
	if (bc)
	[bc loadURL:browseIt];
}

-(void)setNote:(NSString *)note
{
	if (bc)
		[bc setEditText:note];
}

-(NSString *)getURL
{
	return [bc currentURL];
}

-(NSString *)getNote
{
	return [bc editText];
}



- (void)dealloc {
    [super dealloc];
}

@end
