//
//  PNCoreDataHelper.h
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNCoreDataManager : NSObject

+ (PNCoreDataManager *)sharedManager;

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;
- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
										   sortDescriptors:(NSArray *)sortDescriptors
										sectionNameKeyPath:(NSString *)sectionNameKeypath
												 predicate:(NSPredicate *)predicate;

- (id)createEntityWithClassName:(NSString *)className attributesDictionary:(NSDictionary *)attributesDictionary;
- (void)deleteEntity:(NSManagedObject *)entity;
- (BOOL)uniqueAttributeForClassName:(NSString *)className attributeName:(NSString *)attributeName attributeValue:(id)attributeValue;

@end
