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
	NSDictionary *albumAttributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Indonesia", @"title", @1, @"identifier", @24, @"cardsCount", nil];

	PNAlbum *album = (PNAlbum *)[[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNAlbum" attributesDictionary:albumAttributes];
	int randomNumber1 = arc4random() % [album.cardsCount intValue];
//	int randomNumber2 = arc4random() % [album.cardsCount intValue];
//	int randomNumber3 = arc4random() % [album.cardsCount intValue];

	NSDictionary *cardDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@(randomNumber1), @"identifier", album, @"album", nil];
	PNCard *card1 = [[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNCard" attributesDictionary:cardDictionary];
	album.cards = [NSSet setWithObjects:card1, nil];
	[[PNCoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
		 NSLog(@"Saved");
	 }];
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
