//
//  PNAlbum.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbum.h"


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

@end
