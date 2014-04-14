//
//  PNMasterViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumsListViewController.h"
#import "PNAlbumContentViewController.h"
#import "PNAlbum.h"
#import "PNGamificationManager.h"

@interface PNAlbumsListViewController ()
{
	NSArray *_albums;
}
@end

@implementation PNAlbumsListViewController

- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		self.clearsSelectionOnViewWillAppear = NO;
		self.preferredContentSize = CGSizeMake(320.0, 600.0);
	}
	[super awakeFromNib];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.detailViewController = (PNAlbumContentViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	[self configureView];
    [self populateAlbums];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self checkForCompletedAlbums];
}

-(void)checkForCompletedAlbums
{
    PNAlbum *lastAlbum = [_albums lastObject];
    if ([lastAlbum isComplete])
    {
        BOOL newAlbumAdded = [[PNGamificationManager sharedManager] albumCompleted:lastAlbum.identifier];
        NSString *alertMessage = @"You finished the last album! Some new albums will come with an application update.";
        if (newAlbumAdded)
        {
            alertMessage = @"You finished an album! A new one has just been added.";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)configureView
{
	self.navigationController.view.backgroundColor = [UIColor whiteColor];
	self.title = @"Albums";
}

#pragma mark - Albums management

- (void)populateAlbums
{
	_albums = [PNAlbum getAlbums];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	PNAlbum *album = _albums[indexPath.row];

	cell.textLabel.text = album.title;
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"showAlbum"])
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		PNAlbum *album = [_albums objectAtIndex:[indexPath row]];
		[[segue destinationViewController] setAlbum:album];
	}
}

#pragma mark - UIAlertVIewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self populateAlbums];
    [self.tableView reloadData];
}

@end
