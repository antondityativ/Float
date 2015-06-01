//
//  API.h
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatMainStorage.h"

#define baseURLAPI @"https://api.floatschedule.com/api/v1/"

@interface API : NSObject

+(API *)sharedAPI;

typedef void (^getPeoplesCompletion)(NSArray *responseGetPeoples, NSError *errorGetPeoples);

typedef void (^getPersonCompletion)(NSArray *responseGetPerson, NSError *errorGetPerson);

typedef void (^getTasksCompletion)(NSArray *responseGetTasks, NSError *errorGetTasks);

typedef void (^getTaskCompletion)(NSArray *responseGetTask, NSError *errorGetTask);

typedef void (^getProjectsCompletion)(NSArray *responseGetProjects, NSError *errorGetProjects);

typedef void (^getProjectCompletion)(NSArray *responseGetProject, NSError *errorGetProject);

typedef void (^getTasksWidgCompletion)(NSArray *responseGetTasksWidg, NSError *errorGetTasksWidg);

-(NSString *)getPingUrl;

-(void)getPeoples:(getPeoplesCompletion)getPeoplesComplete;

-(void)getPerson:(getPersonCompletion)getPersonComplete;

-(void)getTasks:(getTasksCompletion)getTasksComplete;

-(void)getTask:(getTaskCompletion)getTaskComplete;

-(void)getProjects:(getProjectsCompletion)getProjectsComplete;

-(void)getProject:(getProjectCompletion)getProjectComplete;

-(void)getTasksForWidget:(getTasksWidgCompletion)getTasksWidgComplete;

@end
