//
//  PNAppDelegate.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAppDelegate.h"

@implementation PNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    return YES;
}

@end
