//
//  PNAlbum.h
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNAlbum : NSObject

@property(strong, nonatomic) NSNumber *identifier;
@property(strong, nonatomic) NSString *title;

+(PNAlbum *) albumWithIdentifier:(NSNumber *)identifier andTitle:(NSString *)title;

@end
