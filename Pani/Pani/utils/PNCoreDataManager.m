//
//  PNCoreDataHelper.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNCoreDataManager.h"

@interface PNCoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation PNCoreDataManager

#pragma mark - Singleton

static PNCoreDataManager * coreDataManager;

+ (PNCoreDataManager *)sharedManager
{
	if (!coreDataManager)
	{
		static dispatch_once_t onceToken;

		dispatch_once(&onceToken, ^{
						  coreDataManager = [[PNCoreDataManager alloc] init];
					  });
	}
	return coreDataManager;
}

#pragma mark - setup

- (id)init
{
	self = [super init];

	if (self)
	{
		[self setupManagedObjectContext];
	}

	return self;
}

- (void)setupManagedObjectContext
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *documentDirectoryURL = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask][0];
	NSURL *persistentURL = [documentDirectoryURL URLByAppendingPathComponent:@"Pani.sqlite"];
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Pani" withExtension:@"momd"];

	self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

	NSError *error = nil;
	NSPersistentStore *persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																					   configuration:nil
																								 URL:persistentURL
																							 options:nil
																							   error:&error];
	if (persistentStore)
	{
		self.managedObjectContext = [[NSManagedObjectContext alloc] init];
		self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	else
	{
		NSLog(@"ERROR: %@", error.description);
	}
}

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock
{
	NSError *saveError = nil;

	savedBlock([self.managedObjectContext save:&saveError], saveError);
}

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
										   sortDescriptors:(NSArray *)sortDescriptors
										sectionNameKeyPath:(NSString *)sectionNameKeypath
												 predicate:(NSPredicate *)predicate

{
	NSFetchedResultsController *fetchedResultsController;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:self.managedObjectContext];

	fetchRequest.entity = entity;
	fetchRequest.sortDescriptors = sortDescriptors;
	fetchRequest.predicate = predicate;
	fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																   managedObjectContext:self.managedObjectContext
																	 sectionNameKeyPath:sectionNameKeypath
																			  cacheName:nil];

	NSError *error = nil;
	BOOL success = [fetchedResultsController performFetch:&error];
	if (!success)
	{
		NSLog(@"fetchManagedObjectsWithClassName ERROR: %@ ", error.description);
	}
	return fetchedResultsController;
}

- (id)createEntityWithClassName:(NSString *)className
		   attributesDictionary:(NSDictionary *)attributesDictionary
{
	NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:self.managedObjectContext];

	[attributesDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
		 [entity setValue:obj forKey:key];
	 }];

	return entity;
}

- (void)deleteEntity:(NSManagedObject *)entity
{
	[self.managedObjectContext deleteObject:entity];
}

- (BOOL)uniqueAttributeForClassName:(NSString *)className attributeName:(NSString *)attributeName attributeValue:(id)attributeValue
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@ ", attributeName, attributeValue];
	NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
	NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className
																			sortDescriptors:sortDescriptors
																		 sectionNameKeyPath:nil
																				  predicate:predicate];

	return fetchedResultsController.fetchedObjects.count == 0;
}

@end
