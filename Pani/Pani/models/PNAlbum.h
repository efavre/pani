//
//  PNAlbum.h
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PNAlbum : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * cardsCount;

+(PNAlbum *) albumWithIdentifier:(NSNumber *)identifier title:(NSString *)title andCardsCount:(NSNumber *)cardsCount;

@end
