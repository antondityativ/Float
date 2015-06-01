//
//  ViewController.m
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark VIEW METHODS

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ltst.float"];
    [sharedDefaults removeObjectForKey:@"people_id"];
    [sharedDefaults removeObjectForKey:@"email"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self setupBackgroundUI];
    
    self.title = @"FLOAT";
    
    [self getPeoples];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SETUP UI

-(void)setupUI {
    
//Scroll View
    self.SV = [[UIScrollView alloc] initWithFrame:
               CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.SV setUserInteractionEnabled:YES];
    [self.SV setScrollEnabled:YES];
    self.SV.scrollsToTop = YES;
    [self.view addSubview:self.SV];
    
//Email textField for authorization
    
    self.emailTextField = [[UITextField alloc] initWithFrame:
                           CGRectMake(navigationBarHeight, navigationBarHeight*5, screenWidth - navigationBarHeight*2,navigationBarHeight)];
    
    self.emailTextField.delegate = self;
    
    NSString *email = [[FloatMainStorage sharedMainStorage] returnEmailDefaults];
    
    if(![email isEqual:@""]) {
        self.emailTextField.text = email;
    }
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.emailTextField.textAlignment = NSTextAlignmentCenter;
    self.emailTextField.layer.cornerRadius = 8;
    [self.emailTextField setBackgroundColor:[UIColor whiteColor]];
    [self.SV addSubview:self.emailTextField];

//dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
//login button
    
    self.loginButton = [[UIButton alloc] initWithFrame:
                        CGRectMake(self.emailTextField.frame.size.width/2,self.emailTextField.frame.origin.y + self.emailTextField.frame.size.height*2,self.emailTextField.frame.size.height*2, self.emailTextField.frame.size.height*2)];
    
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor whiteColor]];
    
    self.loginButton.layer.cornerRadius = 30;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [UIColor blueColor].CGColor;
    
    [self.loginButton addTarget:
     self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.SV addSubview:self.loginButton];
}

-(void)setupBackgroundUI {
    UIView *viewOne = [[UIView alloc] initWithFrame:
                       CGRectMake(0, 0, screenWidth/2, screenHeight/2)];
    [viewOne setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:viewOne];
    UIView *viewTwo = [[UIView alloc] initWithFrame:
                       CGRectMake(viewOne.frame.size.width, 0, screenWidth, screenHeight/2)];
    [self.view addSubview:viewTwo];
    [viewTwo setBackgroundColor:[UIColor orangeColor]];
    UIView *viewThree = [[UIView alloc] initWithFrame:
                         CGRectMake(0, viewOne.frame.size.height, screenWidth/2, screenHeight)];
    [self.view addSubview:viewThree];
    [viewThree setBackgroundColor:[UIColor greenColor]];
    UIView *viewFour = [[UIView alloc] initWithFrame:
                        CGRectMake(viewTwo.frame.origin.x, viewThree.frame.origin.y, screenWidth/2, screenHeight/2)];
    [viewFour setBackgroundColor:[UIColor magentaColor]];
    [self.view addSubview:viewFour];
}

#pragma mark GET PEOPLES

-(void)getPeoples {
    self.activ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                  UIActivityIndicatorViewStyleGray];
    self.activ.center = CGPointMake(screenWidth/2, screenHeight/2);
    [self.view addSubview:self.activ];
    [self.activ startAnimating];
    [[API sharedAPI] getPeoples:^(NSArray *responseGetPeoples, NSError *errorGetPeoples) {
        if(errorGetPeoples) {
            self.peoples = [[FloatMainStorage sharedMainStorage] returnWithPeoplId:
                            self.peoples.people_id withEmail:self.peoples.email];
        }
        else {
            self.peoples = [[PeoplesObjectObject alloc] initWithEmail:
                            [[responseGetPeoples valueForKey:@"people"]valueForKey:@"email"] withPeopleID:[[responseGetPeoples valueForKey:@"people"]valueForKey:@"people_id"]];
        }
        [self.activ stopAnimating];
        [self.activ setHidesWhenStopped:YES];
        
        [self setupUI];
    }];
}

#pragma mark TEXTFIELD METHODS

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField) {
        self.emailTextField.text = @"";
        [self.loginButton setEnabled:YES];
        [self.loginButton setBackgroundColor:
         [UIColor colorWithRed:58/255. green:190/255. blue:239/255. alpha:1.0]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (![self NSStringIsValidEmail:self.emailTextField.text]) {
        if (self.emailTextField.text.length > 0 || self.emailTextField.text == nil) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Неправильно введен email" message:@"Введите email в формате xxxx@xxxx.ru" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ок", nil];
//            [alert show];
        }
        self.emailTextField.text = @"Email";
    }
    if ([self NSStringIsValidEmail:self.emailTextField.text]) {
        self.emailTextField.text = [self.emailTextField.text lowercaseString];
    }
    
    [[FloatMainStorage sharedMainStorage] saveEmailDefaults:self.emailTextField.text];
}

#pragma mark ACTIONS

-(void)clickLogin {
    for(int index = 0; index < 32; index ++) {
        if(![self.emailTextField.text isEqual:@""]) {
            if([self.emailTextField.text isEqualToString:[self.peoples.email objectAtIndex:index]]) {
                
                self.people_id = [self.peoples.people_id objectAtIndex:index];
                
                [[FloatMainStorage sharedMainStorage] savePeopleIDDefaults:self.people_id];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
                }];
            }
        }
    }
}

- (void)keyboardWasShown:(NSNotification *)notification {
    self.keyboardSize = [[[notification userInfo] objectForKey:
                          UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.SV setContentSize:
     CGSizeMake(screenWidth, screenHeight + self.keyboardSize.height)];
}

-(void)dismissKeyboard {
    
    [self.emailTextField resignFirstResponder];
    [self.SV setContentSize:CGSizeMake(screenWidth, screenHeight)];
}


@end
