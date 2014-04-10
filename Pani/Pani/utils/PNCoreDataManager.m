//
//  PNCoreDataHelper.m
//  Pani
//
//  Created by Eric Favre on 09/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNCoreDataManager.h"
#import "PNAlbum.h"

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

#pragma mark - Database access setup

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

#pragma mark - Entities access

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
	NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className sortDescriptors:sortDescriptors sectionNameKeyPath:nil predicate:predicate];
	return fetchedResultsController.fetchedObjects.count == 0;
}

#pragma mark - DataBase initilization


+ (void)initializeDatabase
{
	[PNAlbum deleteAllAlbums];
    [self initializeAlbumWithIdentifier:@1 title:@"Indonesia" andCardsCount:@24];
    [self initializeAlbumWithIdentifier:@2 title:@"Peru" andCardsCount:@19];
    [self initializeAlbumWithIdentifier:@3 title:@"Hong Kong" andCardsCount:@22];
//    [self initializeAlbumWithIdentifier:@4 title:@"Cambodia" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@5 title:@"Vietnam" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@6 title:@"Mexico" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@7 title:@"Thailand" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@8 title:@"Chili" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@9 title:@"Bolivia" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@10 title:@"Morocco" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@11 title:@"France" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@12 title:@"Italy" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@13 title:@"China" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@14 title:@"Spain" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@15 title:@"Great Britain" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@16 title:@"Danemark" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@17 title:@"Czech Republic" andCardsCount:@24];
//    [self initializeAlbumWithIdentifier:@18 title:@"Senegal" andCardsCount:@24];
    
    [[PNCoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
        if (saved)
        {
            NSLog(@"Saved");
        }
        else
        {
            NSLog(@"ERROR : %@", [error localizedDescription]);
        }
    }];
}

+ (PNAlbum *)initializeAlbumWithIdentifier:(NSNumber *)identifier title:(NSString *)title andCardsCount:(NSNumber *)cardsCount
{
    NSDictionary *albumAttributes = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", identifier, @"identifier", cardsCount, @"cardsCount", nil];
	PNAlbum *album = (PNAlbum *)[[PNCoreDataManager sharedManager] createEntityWithClassName:@"PNAlbum" attributesDictionary:albumAttributes];
	[album addRandomCard];
	[album addRandomCard];
	[album addRandomCard];
    return album;
}

+ (void)upgradeDatabaseFromVersion:(NSString *)applicationVersion
{
    
}

@end
