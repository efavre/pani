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
	UIImage *card = [UIImage imageNamed:[NSString stringWithFormat:@"1-%d.png", [self.cardIdentifier intValue]]];

	self.imageView.image = card;
}

#pragma mark - User interactions

- (IBAction)shareCard:(id)sender
{
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];

	self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:[self.cardIdentifier intValue] identifier:@"Pani-Region"];
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
