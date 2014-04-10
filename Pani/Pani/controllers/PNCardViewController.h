//
//  PNImageViewController.h
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import CoreBluetooth;
#import "PNCard.h"

@interface PNCardViewController : UIViewController <CBPeripheralManagerDelegate>

@property (strong, nonatomic) NSNumber *cardIdentifier;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)shareCard:(id)sender;
- (IBAction)stopSharingCard:(id)sender;

@end
