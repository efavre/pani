//
//  PNDetailViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumContentViewController.h"
#import "PNConstants.h"
#import "PNImageViewController.h"

#define NUMBER_OF_PICTURES_IN_ALBUM 24

@interface PNAlbumContentViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *cardsArray;
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

- (void)setAlbumName:(id)newDetailItem
{
    if (_albumName != newDetailItem)
    {
        _albumName = newDetailItem;
        [self configureView];
    }
    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1-0.png"]];
    if (self.albumName)
    {
        self.title = self.albumName;
    }
}

#pragma mark - Cards management

- (void)initializeCards
{
    int randomNumber1 = arc4random() % NUMBER_OF_PICTURES_IN_ALBUM;
    int randomNumber2 = arc4random() % NUMBER_OF_PICTURES_IN_ALBUM;
    int randomNumber3 = arc4random() % NUMBER_OF_PICTURES_IN_ALBUM;
    self.cardsArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:randomNumber1], nil];
    if (randomNumber2 != randomNumber1)
    {
        [self.cardsArray addObject:[NSNumber numberWithInt:randomNumber2]];
    }
    if (randomNumber3 != randomNumber1 && randomNumber3 != randomNumber2)
    {
        [self.cardsArray addObject:[NSNumber numberWithInt:randomNumber3]];
    }
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

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    self.title = @"Receiving...";
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    self.title = self.albumName;
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    for (CLBeacon *beacon in beacons)
    {
        [self.cardsArray addObject:beacon.minor];
        [self.albumCollectionView reloadData];
    }
}

#pragma mark - UICollectionView Datasource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PNAlbumCellView";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    if ([self.cardsArray containsObject:@(indexPath.row)])
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER_OF_PICTURES_IN_ALBUM;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cardsArray containsObject:@(indexPath.row)])
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
    if ([[segue identifier] isEqualToString:@"conditionalShowImage"]) {
        NSIndexPath *indexPath = [self.albumCollectionView indexPathForCell:sender];
        PNImageViewController *nextController = (PNImageViewController *)[segue destinationViewController];
        nextController.imageIdentifier = @(indexPath.row);
    }
}
@end