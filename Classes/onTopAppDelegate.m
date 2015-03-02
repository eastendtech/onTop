//
//  onTopAppDelegate.m
//  onTop
//
//  Created by Michael Colson on 5/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "onTopAppDelegate.h"
#import "onTopViewController.h"

@implementation onTopAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    
	[ [UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	NSString *applicationCode = @"9a7d2d1cade06ba9474e6b70dcd3e477";
    //NSString *mobclixCode = @"ca9c5b5f-d5e7-4c45-be0c-abf83d7a36dc";
	
	
	[Beacon initAndStartBeaconWithApplicationCode:applicationCode
								  useCoreLocation:NO useOnlyWiFi:NO];
	/*
	TapjoyConnectInterface *ti = [[TapjoyConnectInterface alloc] init]; 
    TapjoyConnect* tc = [TapjoyConnect requestTapjoyConnectWithDelegate:ti]; 
	
	[tc getAdOrder];  
    [tc preloadAds:1];
	
	*/
	// Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	
	//Check for any application saved state info:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *urlFile = [NSString stringWithFormat:@"%@/lastURL.txt",documentsDirectory ];
	NSString *noteFile = [NSString stringWithFormat:@"%@/lastNote.txt",documentsDirectory ];
	
	if ( [ [NSFileManager defaultManager] fileExistsAtPath:urlFile] )
	{
		NSString * urlString = [NSString stringWithContentsOfFile:urlFile];
		[viewController setURL:urlString];
	}
	
	if ( [ [NSFileManager defaultManager] fileExistsAtPath:noteFile] )
	{
		NSString * noteString = [NSString stringWithContentsOfFile:noteFile];
		[viewController setNote:noteString];
	}
	
}


- (void) applicationWillTerminate:(UIApplication *)application
{
	
	//[Mobclix endApplication];
	[Beacon endBeacon];
	 
	
	//Save any state infos:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *urlFile = [NSString stringWithFormat:@"%@/lastURL.txt",documentsDirectory ];
	NSString *noteFile = [NSString stringWithFormat:@"%@/lastNote.txt",documentsDirectory ];

	NSString *note = [viewController getNote];
	NSString *url = [viewController getURL];
	
	//if ([note length] > 0)
		[note writeToFile:noteFile atomically:NO];
	//if ([url length] > 0)
		[url writeToFile:urlFile atomically:NO];
	//else
	
	
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
