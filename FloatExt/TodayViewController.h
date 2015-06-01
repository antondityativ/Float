//
//  TodayViewController.h
//  FloatExt
//
//  Created by Антон Дитятив on 28.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksObject.h"
#import "FloatMainStorage.h"
#import "API.h"
#import "ViewController.h"

@interface TodayViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) UIActivityIndicatorView *activ;

@property(strong, nonatomic) TasksObjectObject *task;

@property NSArray *projectName;
@property NSArray *hours_pd;
@property NSMutableArray *unique;
@property NSString *peopleID;

@end
