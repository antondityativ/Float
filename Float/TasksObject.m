//
//  TasksObject.m
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "TasksObject.h"

@implementation TasksObject

@dynamic people_id;
@dynamic tasks;
@dynamic hours_pd;
@dynamic person_id;

@end

@implementation TasksObjectObject

-(instancetype)initWithPeopleID:(NSArray *)people_id withTasks:(NSArray *)tasks withHours:(NSArray *)hours_pd withPersonID:(NSString *)person_id {
    
    self = [super init];
    if(self) {
        self.people_id = people_id;
        self.tasks = tasks;
        self.hours_pd = hours_pd;
        self.person_id = person_id;
    }
    return self;
}

@end
