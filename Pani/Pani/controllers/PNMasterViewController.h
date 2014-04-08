//
//  PNMasterViewController.h
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PNDetailViewController;

@interface PNMasterViewController : UITableViewController

@property (strong, nonatomic) PNDetailViewController *detailViewController;

@end
