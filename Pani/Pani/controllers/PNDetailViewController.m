//
//  PNDetailViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNDetailViewController.h"
#import "PNConstants.h"

@interface PNDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
- (void)configureView;
@end

@implementation PNDetailViewController

#pragma mark - Managing the detail item

- (void)setAlbumName:(id)newDetailItem
{
    if (_albumName != newDetailItem) {
        _albumName = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.albumName) {
        self.detailDescriptionLabel.text = [self.albumName description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeCards];
    [self populateCardsView];
    [self monitorIBeacons];
    [self configureView];
}

#pragma mark - Cards management

- (void)initializeCards
{
    int randomNumber1 = (arc4random() % 11) +1;
    int randomNumber2 = (arc4random() % 11) +1;
    int randomNumber3 = (arc4random() % 11) +1;
    self.cards = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:randomNumber1], nil];
    if (randomNumber2 != randomNumber1)
    {
        [self.cards addObject:[NSNumber numberWithInt:randomNumber2]];
    }
    if (randomNumber3 != randomNumber1 && randomNumber3 != randomNumber2)
    {
        [self.cards addObject:[NSNumber numberWithInt:randomNumber3]];
    }
}

- (void)monitorIBeacons
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Livecode-Region"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)populateCardsView
{
    for (NSNumber *card in self.cards) {
        int tag = [card intValue];
        UIButton *button = (UIButton *)[self.view viewWithTag:tag];
        button.backgroundColor = [UIColor greenColor];
    }
}

#pragma mark - CLLocationManagerDelegate methods


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    self.statusLabel.text = @"Quelqu'un vous donne une carte !";
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    self.statusLabel.text = @"";
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    for (CLBeacon *beacon in beacons)
    {
        
        NSString *proximity = nil;
        proximity = (beacon.proximity == CLProximityImmediate ? @"immediate" : (beacon.proximity == CLProximityNear ? @"near" : (beacon.proximity == CLProximityFar ? @"far" : @"unknown")));

        [self.cards addObject:beacon.minor];
        [self populateCardsView];
    }
}

#pragma mark - User interactions

- (IBAction)giveCard:(id)sender
{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.peripheralManager stopAdvertising];
    UIButton *cardButton = (UIButton *)sender;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:cardButton.tag identifier:@"MaRegion"];
    self.beaconData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (IBAction)stopGivingCard:(id)sender {
    [self.peripheralManager stopAdvertising];
    [self monitorIBeacons];
}

#pragma mark - CBPeripheralManagerDelegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        [self.peripheralManager startAdvertising:self.beaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        NSLog(@"not supported");
    }
}



#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
