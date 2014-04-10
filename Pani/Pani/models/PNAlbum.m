//
//  PNAlbum.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbum.h"
#import "PNCoreDataManager.h"
#import "PNCard.h"

@implementation PNAlbum

@dynamic title;
@dynamic identifier;
@dynamic cardsCount;
@dynamic cards;

+ (PNAlbum *)albumWithIdentifier:(NSNumber *)identifier title:(NSString *)title andCardsCount:(NSNumber *)cardsCount
{
	PNAlbum *album = [[PNAlbum alloc] init];

	album.identifier = identifier;
	album.title = title;
	album.cardsCount = cardsCount;
	return album;
}

- (BOOL)hasCard:(NSNumber *)cardIdentifier
{
	for (PNCard *card in self.cards)
	{
		if (card.identifier == cardIdentifier)
		{
			return YES;
		}
	}
	return NO;
}

- (PNCard *)addRandomCard
{
	int randomNumber = arc4random() % [self.cardsCount intValue];
	NSDictionary *cardDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@(randomNumber), @"identifier", self, @"album", nil];
	PNCard *card = [[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNCard" attributesDictionary:cardDictionary];
	return card;
}

@end
