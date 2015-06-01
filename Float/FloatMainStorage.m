//
//  FloatMainStorage.m
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "FloatMainStorage.h"

@interface FloatMainStorage ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation FloatMainStorage

FloatMainStorage *sharedMainStorage = nil;

+ (FloatMainStorage *)sharedMainStorage
{
    if (sharedMainStorage == nil) {
        sharedMainStorage = [[FloatMainStorage alloc] init];
    }
    return sharedMainStorage;
}

- (id)init {
    self = [super init];
    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Float" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSURL *documentPath = [[[NSFileManager defaultManager] URLsForDirectory:
                                NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storeURL = [documentPath URLByAppendingPathComponent:@"Float"];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:
              nil URL:storeURL options:options error:&error]) {
            
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:nil];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return self;
}


-(void)peopleWithEmail:(NSArray*)email withPeopleID:(NSArray*)people_id {
    
    NSManagedObjectContext *tmpContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:
                                          NSPrivateQueueConcurrencyType];
    [tmpContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    NSError *saveError = nil;
    
    NSEntityDescription *drinkDescriptor = [NSEntityDescription entityForName:
                                            @"Person" inManagedObjectContext:tmpContext];
    PeoplesObject *currentType = [[PeoplesObject alloc]initWithEntity:
                                  drinkDescriptor insertIntoManagedObjectContext:tmpContext];
    
    
    currentType.email = email;
    currentType.people_id = people_id;
    
    if (![tmpContext save:&saveError]) {
        NSLog(@"%@", [saveError description]);
    }

}

-(void)withPeopleID:(NSArray*)people_id withTasks:(NSArray *)tasks withHours:(NSArray *)hours_pd withPersonID:(NSString *)person_id {
    
    NSManagedObjectContext *tmpContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:
                                          NSPrivateQueueConcurrencyType];
    [tmpContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    NSError *saveError = nil;
    
    NSEntityDescription *taskDescr = [NSEntityDescription entityForName:
                                      @"Tasks" inManagedObjectContext:tmpContext];
    TasksObject *currentType = [[TasksObject alloc]initWithEntity:
                                taskDescr insertIntoManagedObjectContext:tmpContext];
    
    
    currentType.tasks = tasks;
    currentType.people_id = people_id;
    currentType.hours_pd = hours_pd;
    currentType.person_id = person_id;
    
    if (![tmpContext save:&saveError]) {
        NSLog(@"%@", [saveError description]);
    }

}

-(void)savePeopleIDDefaults:(NSString *)people_id {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ltst.float"];
    [sharedDefaults setObject:people_id forKey:@"people_id"];
    [sharedDefaults synchronize];
}

-(void)saveEmailDefaults:(NSString *)email {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ltst.float"];
    [sharedDefaults setObject:email forKey:@"userEmail"];
    [sharedDefaults synchronize];
}

-(TasksObjectObject *)returnWithPeoplId:(NSArray *)people_id withTasks:(NSArray *)tasks withHours:(NSArray *)hours_pd {
    
    NSError *saveError = nil;
    
    NSEntityDescription *task = [NSEntityDescription entityForName:
                                 @"Tasks" inManagedObjectContext:_managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:task];
    
    NSArray *resultArray = [_managedObjectContext executeFetchRequest:request error:&saveError];
    
    if([resultArray count] > 0) {
        TasksObject *spec = [resultArray firstObject];
        TasksObjectObject *specObj = [[TasksObjectObject alloc] initWithPeopleID:
                                      spec.people_id withTasks:
                                      spec.tasks withHours:
                                      spec.hours_pd withPersonID:
                                      spec.person_id];
        
        return specObj;
    }
    return nil;

}

-(PeoplesObjectObject*)returnWithPeoplId:(NSArray*)people_id withEmail:(NSArray *)email {
    NSError *saveError = nil;
    
    NSEntityDescription *person = [NSEntityDescription entityForName:
                                   @"Person" inManagedObjectContext:_managedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:person];
    
    NSArray *resultArray = [_managedObjectContext executeFetchRequest:request error:&saveError];
    
    if([resultArray count] > 0) {
        PeoplesObject *peop = [resultArray firstObject];
        PeoplesObjectObject *peopObj = [[PeoplesObjectObject alloc] initWithEmail:
                                        peop.email withPeopleID:peop.people_id];
        
        return peopObj;
    }
    return nil;
}

-(NSString *)returnPeopleIDDefaults {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ltst.float"];
    NSString *peopleID = [sharedDefaults valueForKey:@"people_id"];
    
    return peopleID;
}

-(NSString *)returnEmailDefaults {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ltst.float"];
    NSString *email = [sharedDefaults objectForKey:@"userEmail"];
    
    return email;
}

@end
