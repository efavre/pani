//
//  PNCardiViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNCardViewController.h"
#import "PNConstants.h"

@interface PNCardViewController ()
@property (strong, nonatomic) NSDictionary *beaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation PNCardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self displayCard];
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)displayCard
{
	UIImage *cardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%@.png", self.card.album.identifier, self.card.identifier]];

	self.imageView.image = cardImage;
}

#pragma mark - User interactions

- (IBAction)shareCard:(id)sender
{
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];

	self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[self.card.album.identifier intValue] minor:[self.card.identifier intValue] identifier:@"Card-Region"];
	self.beaconData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
	self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (IBAction)stopSharingCard:(id)sender
{
	[self.peripheralManager stopAdvertising];
	self.statusLabel.text = @"";
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
	if (peripheral.state == CBPeripheralManagerStatePoweredOn)
	{
		[self.peripheralManager startAdvertising:self.beaconData];
		self.statusLabel.text = @"Sharing...";
	}
	else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
	{
		[self.peripheralManager stopAdvertising];
		self.statusLabel.text = @"Bluetooth inactive";
	}
	else if (peripheral.state == CBPeripheralManagerStateUnsupported)
	{
		self.statusLabel.text = @"Not supported by device";
	}
}

@end
