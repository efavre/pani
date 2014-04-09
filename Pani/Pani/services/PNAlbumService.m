//
//  PNAlbumService.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbumService.h"
#import "PNAlbum.h"

@implementation PNAlbumService

+(NSArray *) getAlbums
{
    PNAlbum *album = [PNAlbum albumWithIdentifier:[NSNumber numberWithInt:1] title:@"Indonesia" andCardsCount:[NSNumber numberWithInt:24]];
    NSArray *albums = [NSArray arrayWithObjects:album,nil];
    return albums;
}

@end
