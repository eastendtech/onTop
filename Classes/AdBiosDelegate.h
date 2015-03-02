//AdBiosDelegateProtocol - This class defines the protocol used to communicate ad events to
//clients of the AdBios AdView.
//-----Functions-------------
// User-Interaction Functions(Optional):
// didFailToRecieveAd - Ad Failure
// didRecieveAd - Ad Loaded Successfully
// willShowAdPage - An ad browser is about to display.
// didDismissAdPage - User hit "Done" on the ad browser

//----Publisher Information functions
// -(NSString *)adBiosPublisherID; (Required) - Please enter the publisher ID of your content.

@protocol AdBiosDelegateProtocol <NSObject>

@optional
-(void)didFailToRecieveAd;
-(void)didRecieveAd;
-(void)willShowAdPage;
-(void)didDismissAdPage;
-(float)adInterval; //Refresh interval for loading new ads. Set to 0 or don't include to turn off rotation.

@required
-(NSString *)adBiosPublisherID;


@end

