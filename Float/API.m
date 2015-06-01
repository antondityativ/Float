//
//  API.m
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "API.h"
#import "AFNetworking.h"

@implementation API

API *sharedAPI = nil;

+(API *)sharedAPI {
    if(sharedAPI == nil) {
        sharedAPI = [[API alloc] init];
    }
    return sharedAPI;
}

-(NSString *)getUrlAPI {
    return [NSString stringWithFormat:@"%@", baseURLAPI];
}

-(NSString *)getPingUrl {
    return [NSString stringWithFormat:@"www.apple.com"];
}

-(void)getPeoples:(getPeoplesCompletion)getPeoplesComplete {
AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
[currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@people", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getPeoplesArr = (NSArray *)responseObject;
        if(getPeoplesComplete) {
            NSArray *email = [[getPeoplesArr valueForKey:@"people"] valueForKey:@"email"];
            NSArray *people_id = [[getPeoplesArr valueForKey:@"people"] valueForKey:@"people_id"];
            
            [[FloatMainStorage sharedMainStorage] peopleWithEmail:email withPeopleID:people_id];
          getPeoplesComplete(getPeoplesArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getPeoplesComplete(nil, error);
        
    }];

}

-(void)getPerson:(getPersonCompletion)getPersonComplete {
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@people/", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getPersonArr = (NSArray *)responseObject;
        if(getPersonComplete) {
            getPersonComplete(getPersonArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getPersonComplete(nil, error);
        
    }];
}

-(void)getTasks:(getTasksCompletion)getTasksComplete {
    
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@tasks", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getTasksArr = (NSArray *)responseObject;
        if(getTasksComplete) {
            
            NSArray *people_id = [[getTasksArr valueForKey:@"people"] valueForKey:@"people_id"];
            NSArray *task = [[getTasksArr valueForKey:@"people"] valueForKey:@"tasks"];
            NSArray *hours_pd = [[[getTasksArr valueForKey:@"people"] valueForKey:@"tasks"] valueForKey:@"hours_pd"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *peopleID = [defaults valueForKey:@"people_id"];
            
            [[FloatMainStorage sharedMainStorage] withPeopleID:people_id withTasks:task withHours:hours_pd withPersonID:peopleID];
            
            getTasksComplete(getTasksArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getTasksComplete(nil, error);
        
    }];
}

-(void)getTasksForWidget:(getTasksWidgCompletion)getTasksWidgComplete {
    
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@tasks", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getTasksArr = (NSArray *)responseObject;
        if(getTasksWidgComplete) {
            
            NSArray *people_id = [[getTasksArr valueForKey:@"people"] valueForKey:@"people_id"];
            NSArray *task = [[getTasksArr valueForKey:@"people"] valueForKey:@"tasks"];
            NSArray *hours_pd = [[[getTasksArr valueForKey:@"people"] valueForKey:@"tasks"] valueForKey:@"hours_pd"];
            
            [[FloatMainStorage sharedMainStorage] withPeopleID:people_id withTasks:task withHours:hours_pd withPersonID:nil];
            
            getTasksWidgComplete(getTasksArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getTasksWidgComplete(nil, error);
        
    }];
}


-(void)getTask:(getTaskCompletion)getTaskComplete {
    
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@tasks/", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getTaskArr = (NSArray *)responseObject;
        if(getTaskComplete) {
            getTaskComplete(getTaskArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getTaskComplete(nil, error);
        
    }];

}

-(void)getProjects:(getProjectsCompletion)getProjectsComplete {
    
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@projects", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getProjectsArr = (NSArray *)responseObject;
        if(getProjectsComplete) {
            getProjectsComplete(getProjectsArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getProjectsComplete(nil, error);
        
    }];
}

-(void)getProject:(getProjectCompletion)getProjectComplete {
    
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *token = [NSString stringWithFormat:@"Bearer b612d51c9c30439383be70a2b03310672c94ea9e"];
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@projects/167654", [self getUrlAPI]];
    
    
    [currentRequestManager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *getProjectArr = (NSArray *)responseObject;
        if(getProjectComplete) {
            getProjectComplete(getProjectArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        getProjectComplete(nil, error);
        
    }];
}

@end
