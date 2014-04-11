//
//  PNGamificationManager.m
//  Pani
//
//  Created by Eric Favre on 11/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNGamificationManager.h"
#import "PNCoreDataManager.h"

@implementation PNGamificationManager

#pragma mark - Singleton

static PNGamificationManager * gamificationManager;

+ (PNGamificationManager *)sharedManager
{
	if (!gamificationManager)
	{
		static dispatch_once_t onceToken;

		dispatch_once(&onceToken, ^{
						  gamificationManager = [[PNGamificationManager alloc] init];
					  });
	}
	return gamificationManager;
}

- (BOOL)albumCompleted:(NSNumber *)albumIdentifier
{
    NSNumber *nextAlbumIdentifier = @([albumIdentifier intValue] + 1) ;
    NSURL *albumsFile = [[NSBundle mainBundle] URLForResource:@"albums" withExtension:@"plist"];
    NSDictionary *albumsDictionary = [NSDictionary dictionaryWithContentsOfURL:albumsFile];
    if (albumsDictionary)
    {
        NSDictionary *nextAlbum = [albumsDictionary objectForKey:[NSString stringWithFormat:@"album%@",nextAlbumIdentifier]];
        NSNumber *nextAlbumCardsCount = [nextAlbum objectForKey:@"cardsCount"];
        NSString *nextAlbumTitle = [nextAlbum objectForKey:@"title"];
        if (nextAlbumIdentifier && nextAlbumTitle && nextAlbumCardsCount)
        {
            [[PNCoreDataManager sharedManager] initializeAlbumWithIdentifier:nextAlbumIdentifier title:nextAlbumTitle andCardsCount:nextAlbumCardsCount];
            return YES;
        }
    }
    return NO;
}

@end
