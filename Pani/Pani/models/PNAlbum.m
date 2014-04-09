//
//  PNAlbum.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNAlbum.h"

@implementation PNAlbum

+(PNAlbum *) albumWithIdentifier:(NSNumber *)identifier andTitle:(NSString *)title
{
    PNAlbum *album = [[PNAlbum alloc] init];
    album.identifier = identifier;
    album.title = title;
    return album;
}

@end
