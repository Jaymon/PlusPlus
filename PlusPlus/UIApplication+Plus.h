//  Created by Jay Marcyes on 5/01/2017.
//
// based off of NetworkActivityIndicator by Matt Zanchelli
// https://github.com/mdznr/NetworkActivityIndicator


@import UIKit;


@interface UIApplication (Plus)

/**
 Tell the application that network activity has started

 when this is called the network activity indicator will be shown to provide feedback
 to the user that the network is in use. This will increment a counter, so the more
 times you call this the more you have to call stopNetworkActivity to turn the activity
 indicator off.
 */
- (void)startNetworkActivity;

/**
 Tell the application that network activity has stopped
 
 This will only hide the activity indicator if all other network activity has come
 to an end also (counter is 0)
 */
- (void)stopNetworkActivity;

/**
 If the activity indicator ever gets out of sync this will turn it off regardless
 of what the internal count contains
 */
- (void)clearNetworkActivity;

@end
