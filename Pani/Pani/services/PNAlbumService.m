//
//  PNAlbumService.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumService.h"
#import "PNAlbum.h"
#import "PNCard.h"
#import "PNCoreDataManager.h"

@implementation PNAlbumService

+ (void)initializeDatabase
{
	[self deleteAllAlbums];
	NSDictionary *album1Attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Indonesia", @"title", @1, @"identifier", @24, @"cardsCount", nil];

	PNAlbum *album1 = (PNAlbum *)[[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNAlbum" attributesDictionary:album1Attributes];
	[album1 addRandomCard];
	[album1 addRandomCard];
	[album1 addRandomCard];

    NSDictionary *album2Attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Peru", @"title", @2, @"identifier", @19, @"cardsCount", nil];
    
	PNAlbum *album2 = (PNAlbum *)[[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNAlbum" attributesDictionary:album2Attributes];
	[album2 addRandomCard];
	[album2 addRandomCard];
	[album2 addRandomCard];

	[[PNCoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
		 NSLog(@"Saved");
	 }];
}

+ (void)upgradeDatabaseFromVersion:(NSString *)applicationVersion
{
}

+ (NSArray *)getAlbums
{
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
	NSArray *sortDescriptorArray = [NSArray arrayWithObject:sortDescriptor];

	NSFetchedResultsController *albumsFetchedResultsController = [[PNCoreDataManager sharedManager] fetchEntitiesWithClassName:@"PNAlbum" sortDescriptors:sortDescriptorArray sectionNameKeyPath:nil predicate:nil];

	return [albumsFetchedResultsController fetchedObjects];
}

+ (void)deleteAllAlbums
{
	NSArray *albumsArray = [self getAlbums];

	for (PNAlbum *album in albumsArray)
	{
		[[PNCoreDataManager sharedManager] deleteEntity:album];
	}
}

@end
