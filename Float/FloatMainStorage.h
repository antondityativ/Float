//
//  FloatMainStorage.h
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PeoplesObject.h"
#import "TasksObject.h"


@interface FloatMainStorage : NSObject

+ (FloatMainStorage *)sharedMainStorage;

//SAVE

-(void) peopleWithEmail:(NSArray*)email withPeopleID:(NSArray*)people_id;
-(void)withPeopleID:(NSArray*)people_id withTasks:(NSArray *)tasks withHours:(NSArray *)hours_pd withPersonID:(NSString *)person_id;
-(void)savePeopleIDDefaults:(NSString *)people_id;
-(void)saveEmailDefaults:(NSString *)email;

//RETURN
-(PeoplesObjectObject*)returnWithPeoplId:(NSArray*)people_id withEmail:(NSArray *)email;
-(TasksObjectObject*)returnWithPeoplId:(NSArray*)people_id withTasks:(NSArray *)tasks withHours:(NSArray *)hours_pd;
-(NSString *)returnPeopleIDDefaults;
-(NSString *)returnEmailDefaults;
@end
