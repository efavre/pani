//
//  PNDetailViewController.h
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import CoreBluetooth;

@interface PNDetailViewController : UIViewController <UISplitViewControllerDelegate, CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) NSString *albumName;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)giveCard:(id)sender;
- (IBAction)stopGivingCard:(id)sender;

@end
