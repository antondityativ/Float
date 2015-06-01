//
//  TasksViewController.h
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "TasksObject.h"
#import "FloatMainStorage.h"
#import "ViewController.h"
#import "FloatRightBarButton.h"

@interface TasksViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property(strong, nonatomic) UITableView *taskTableView;
@property(strong, nonatomic) UITextView *sorryTextView;
@property(strong, nonatomic) FloatRightBarButton *leftBarButton;

@property(strong, nonatomic) UIActivityIndicatorView *activ;

@property(strong, nonatomic) TasksObjectObject *task;

@property NSArray *projectName;
@property NSArray *hours_pd;
@property NSArray *start_date;
@property NSArray *end_date;
@property NSMutableArray *unique;
@property NSString *startWeakDay;
@property NSString *endWeakDay;

@end
