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
#import "PNGamificationManager.h"

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
	self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-0.png", self.album.identifier]];
	if (self.album)
	{
		self.title = self.album.title;
	}
}

- (void)addCardToAlbum:(NSNumber *)beaconMinor
{
    [self.album addCardWithIdentifier:beaconMinor];
    if ([self.album isComplete])
    {
        BOOL newAlbumAdded = [[PNGamificationManager sharedManager] albumCompleted:self.album.identifier];
        NSString *alertMessage = @"You finished the last album! Some new albums will come with an application update.";
        if (newAlbumAdded)
        {
            alertMessage = @"You finished an album! A new one has just been added.";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - iBeacon management

- (void)monitorIBeacons
{
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
	self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[self.album.identifier intValue] identifier:@"Pani-Region"];
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
        [self addCardToAlbum:beacon.minor];
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
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%d.png", self.album.identifier, (int)indexPath.row]];
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
        PNCard *card = [self.album getCardWithIdentifier:@(indexPath.row)];
		nextController.card = card;
	}
}

@end
