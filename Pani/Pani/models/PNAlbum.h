//
//  PNAlbum.h
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class PNCard;

@interface PNAlbum : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *cardsCount;
@property (nonatomic, strong) NSSet *cards;

+ (PNAlbum *)albumWithIdentifier:(NSNumber *)identifier title:(NSString *)title andCardsCount:(NSNumber *)cardsCount;
- (BOOL)hasCard:(NSNumber *)cardIdentifier;
- (PNCard *)addRandomCard;
- (PNCard *)addCardWithIdentifier:(NSNumber *)identifier;
- (PNCard *)getCardWithIdentifier:(NSNumber *)identifier;

+ (NSArray *)getAlbums;
+ (void)deleteAllAlbums;

@end
