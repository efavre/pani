//
//  PNMasterViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumsListViewController.h"
#import "PNAlbumContentViewController.h"

@interface PNAlbumsListViewController () {
    NSMutableArray *_objects;
}
@end

@implementation PNAlbumsListViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (PNAlbumContentViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self populateAlbums];
    [self configureView];
    [self.tableView reloadData];
}

- (void)configureView
{
    self.title = @"Albums";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1-0.png"]];
}

#pragma mark - Albums management

- (void)populateAlbums
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:@"Indonesia" atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSString *albumName = [_objects objectAtIndex:[indexPath row]];
        self.detailViewController.albumName = albumName;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlbum"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *albumName = _objects[indexPath.row];
        [[segue destinationViewController] setAlbumName:albumName];
    }
}

@end
