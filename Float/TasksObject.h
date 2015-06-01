//
//  TasksObject.h
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TasksObject : NSManagedObject

@property (nonatomic, retain) NSArray * people_id;
@property (nonatomic, retain) NSArray * tasks;
@property (nonatomic, retain) NSArray *hours_pd;
@property (nonatomic, retain) NSString *person_id;

@end

@interface TasksObjectObject : NSObject

@property (strong, retain) NSArray * people_id;
@property (strong, retain) NSArray * tasks;
@property (strong, retain) NSArray *hours_pd;
@property (strong, retain) NSString *person_id;

-(instancetype)initWithPeopleID:(NSArray *)people_id withTasks:(NSArray *)tasks withHours:(NSArray *)hours_pd withPersonID:(NSString *)person_id;

@end
