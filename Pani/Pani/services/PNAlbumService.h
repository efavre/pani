//
//  PNAlbumService.h
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNAlbumService : NSObject

+ (void)initializeDatabase;
+ (NSArray *)getAlbums;

@end
