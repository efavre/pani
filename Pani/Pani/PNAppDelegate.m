//
//  PNAppDelegate.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAppDelegate.h"
#import "PNCoreDataManager.h"
#import "PNConstants.h"
#import "PNGamificationManager.h"

@implementation PNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
		UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
		splitViewController.delegate = (id)navigationController.topViewController;
	}

	[self initializeDatabase];
	return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    [[PNCoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
        if (saved)
        {
            NSLog(@"Saved");
        }
        else
        {
            NSLog(@"ERROR : %@", [error localizedDescription]);
        }
    }];
}

- (void)initializeDatabase
{
#if (TARGET_IPHONE_SIMULATOR)
    [[PNGamificationManager sharedManager] initializeFirstAlbum];
#else
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([defaults objectForKey:DATABASE_INITIALIZED_VERSION_KEY] == nil)
    {
        [[PNGamificationManager sharedManager] initializeFirstAlbum];
        [defaults setObject:applicationVersion forKey:DATABASE_INITIALIZED_VERSION_KEY];
        [defaults synchronize];
    }
    else if (![[defaults objectForKey:DATABASE_INITIALIZED_VERSION_KEY] isEqualToString:applicationVersion] )
	{
        [[PNCoreDataManager sharedManager] upgradeDatabaseFromVersion:applicationVersion];
        [defaults setObject:applicationVersion forKey:DATABASE_INITIALIZED_VERSION_KEY];
        [defaults synchronize];
	}
#endif
}

@end
