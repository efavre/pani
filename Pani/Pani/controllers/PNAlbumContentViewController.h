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

@interface PNAlbumContentViewController : UIViewController <UISplitViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) NSString *albumName;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;

- (IBAction)tapCard:(id)sender;
- (IBAction)stopGivingCard:(id)sender;

@end
