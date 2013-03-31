//
//  LYAppDelegate.m
//  bh
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LYAppDelegate.h"

@implementation LYAppDelegate

@synthesize window = _window;


-(void)DealWithNotification:(UILocalNotification *) apNotification
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void)DealWithNotification2:(NSDictionary*) apNotification
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |    UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (localNotif)
    {
        [self DealWithNotification:localNotif];
        // Parse your string to dictionary
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark notification
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
#ifdef DEBUG
    NSLog(@"%@",[NSString stringWithFormat:@"Error in registration. Error: %@", err]);
#endif
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef DEBUG
    NSLog(@"devToken=%@",deviceToken);
#endif

}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
#ifdef DEBUG
	NSLog(@"Received notification: %@", userInfo);
#endif
	[self DealWithNotification2:userInfo];
}

@end
