//
//  PNDetailViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumContentViewController.h"
#import "PNConstants.h"
#import "PNCardViewController.h"

@interface PNAlbumContentViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSSet *cardsSet;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
- (void)configureView;
@end

@implementation PNAlbumContentViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self initializeCards];
	[self monitorIBeacons];
	[self configureView];
}

#pragma mark - manage view

- (void)setAlbum:(PNAlbum *)newAlbum
{
	if (_album != newAlbum)
	{
		_album = newAlbum;
		[self configureView];
	}
	if (self.masterPopoverController != nil)
	{
		[self.masterPopoverController dismissPopoverAnimated:YES];
	}
}

- (void)configureView
{
	self.backgroundImageView.image = [UIImage imageNamed:@"1-0.png"];
	if (self.album)
	{
		self.title = self.album.title;
	}
}

#pragma mark - Cards management

- (void)initializeCards
{
//	int randomNumber1 = arc4random() % [self.album.cardsCount intValue];
//	int randomNumber2 = arc4random() % [self.album.cardsCount intValue];
//	int randomNumber3 = arc4random() % [self.album.cardsCount intValue];
//
//	self.cardsArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:randomNumber1], nil];
//	if (randomNumber2 != randomNumber1)
//	{
//		[self.cardsArray addObject:[NSNumber numberWithInt:randomNumber2]];
//	}
//	if (randomNumber3 != randomNumber1 && randomNumber3 != randomNumber2)
//	{
//		[self.cardsArray addObject:[NSNumber numberWithInt:randomNumber3]];
//	}
}

- (void)monitorIBeacons
{
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
	self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 identifier:@"Pani-Region"];
	[self.locationManager startMonitoringForRegion:self.beaconRegion];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
	self.title = @"Receiving...";
	[self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
	self.title = self.album.title;
	[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
	for (CLBeacon *beacon in beacons)
	{
//		[self.cardsArray addObject:beacon.minor];
		[self.albumCollectionView reloadData];
	}
}

#pragma mark - UICollectionView Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"PNAlbumCellView";
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];

	if ([self.album hasCard:@(indexPath.row)])
	{
		[imageView setBackgroundColor:[UIColor blackColor]];
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1-%d.png", (int)indexPath.row]];
		[imageView setImage:image];
	}
	else
	{
		[imageView setBackgroundColor:[UIColor lightGrayColor]];
		[imageView setImage:nil];
	}
	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.album.cardsCount intValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.album hasCard:@(indexPath.row)])
	{
		[self performSegueWithIdentifier:@"conditionalShowImage" sender:[collectionView cellForItemAtIndexPath:indexPath]];
	}
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
	barButtonItem.title = NSLocalizedString(@"Albums", @"Albums");
	[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
	self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
	self.masterPopoverController = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"conditionalShowImage"])
	{
		NSIndexPath *indexPath = [self.albumCollectionView indexPathForCell:sender];
		PNCardViewController *nextController = (PNCardViewController *)[segue destinationViewController];
		nextController.cardIdentifier = @(indexPath.row);
	}
}

@end
