//
//  PNAlbumService.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumService.h"
#import "PNAlbum.h"
#import "PNCoreDataManager.h"

@implementation PNAlbumService

+ (void)initializeDatabase
{
	NSDictionary *albumAttributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Indonesia", @"title", @1, @"identifier", @24, @"cardsCount", nil];

	[[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNAlbum" attributesDictionary:albumAttributes];
	[[PNCoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
	 }];
}

+ (NSArray *)getAlbums
{
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
	NSArray *sortDescriptorArray = [NSArray arrayWithObject:sortDescriptor];

	[[PNCoreDataManager sharedManager] fetchEntitiesWithClassName:@"PNAlbum" sortDescriptors:sortDescriptorArray sectionNameKeyPath:nil predicate:nil];
	return [NSArray array];
}

@end
