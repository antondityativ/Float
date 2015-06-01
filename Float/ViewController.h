//
//  ViewController.h
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "PeoplesObject.h"
#import "TasksViewController.h"
#import "FloatMainStorage.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property(strong, nonatomic)UIScrollView *SV;

@property(strong, nonatomic) UITextField *emailTextField;
@property(strong, nonatomic) UIButton *loginButton;
@property(strong, nonatomic) UIActivityIndicatorView *activ;

@property(strong, nonatomic) PeoplesObjectObject *peoples;


@property CGSize keyboardSize;
@property NSString *people_id;


@end

