//
//  PNGamificationManager.h
//  Pani
//
//  Created by Eric Favre on 11/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNGamificationManager : NSObject

+ (PNGamificationManager *)sharedManager;

- (BOOL)initializeFirstAlbum;
- (BOOL)albumCompleted:(NSNumber *)albumIdentifier;

@end
