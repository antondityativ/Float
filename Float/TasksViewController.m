//
//  TasksViewController.m
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "TasksViewController.h"

@interface TasksViewController ()

@end

@implementation TasksViewController

#pragma mark VIEW METHODS

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *peopleID = [[FloatMainStorage sharedMainStorage] returnPeopleIDDefaults];
    
    if(peopleID == nil) {
        ViewController *loginView = [[ViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginView];
        
        [self.navigationController presentViewController:navController animated:NO completion:^{
            
        }];
    }
    else {
    
        [self getAllTasks];
    }

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //left MorphingButton on navigation bar
    
    self.leftBarButton = [[FloatRightBarButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.leftBarButton addTarget:self action:@selector(clickRightBarButton:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButton];
    self.navigationItem.leftBarButtonItem = left;
  
    //right Button on navigation bar
    
    UIImage *logoutImage = [UIImage imageNamed:@"logout_icon"];
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [logoutButton setBackgroundImage:logoutImage forState:UIControlStateNormal];
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    [logoutButton addTarget:self action:@selector(clickLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = logout;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllTasks) name:@"login" object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SETUP UI

-(void)setupTableViewTasks {
//Tasks > 0
    self.taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + 20, screenWidth, screenHeight -navigationBarHeight - 20)];
    [self.taskTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.taskTableView.delegate = self;
    self.taskTableView.dataSource = self;
    [self.taskTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.taskTableView];
}

-(void)setupSorryView {
//Tasks = 0
    self.sorryTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, navigationBarHeight*3, screenWidth, screenHeight)];
    [self.sorryTextView setText:@"Прости, чувак, но на данный момент нет проектов на твоем счету"];
    [self.sorryTextView setTextContainerInset:UIEdgeInsetsMake(0, 10, 10, 10)];
    [self.sorryTextView setTextAlignment:NSTextAlignmentCenter];
    [self.sorryTextView setEditable:NO];
    [self.view addSubview:self.sorryTextView];
}

#pragma mark TABLE VIEW METHODS

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat redLevel    = rand() / (float) RAND_MAX;
    CGFloat greenLevel  = rand() / (float) RAND_MAX;
    CGFloat blueLevel   = rand() / (float) RAND_MAX;
    
    CGFloat hue = (arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineSpacing:3];
    
    NSDictionary *attributesTitleName = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:20], NSParagraphStyleAttributeName :paragraphStyle, NSForegroundColorAttributeName:[UIColor blackColor]};
    
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",[self.unique objectAtIndex:indexPath.row],[self.hours_pd  objectAtIndex:indexPath.row]] attributes:attributesTitleName];
        CGRect paragraphRect = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX)
                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                     context:nil];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setFrame:CGRectMake(0, 0, paragraphRect.size.width, paragraphRect.size.height)];
    [cell.textLabel setAttributedText:message];
    [cell.textLabel setNumberOfLines:0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel sizeToFit];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor colorWithRed:
                              redLevel green:
                              greenLevel blue:
                              blueLevel alpha:1]];
    [cell setBackgroundColor:[UIColor colorWithHue:
                              hue saturation:
                              saturation brightness:
                              brightness alpha:1]];
   
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.unique count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.unique count] == 5) {
        return screenHeight/5 - navigationBarHeight/3.5;
    }
    else if ([self.unique count] == 1) {
        return screenHeight - navigationBarHeight;
    }
    else if ([self.unique count] == 2) {
        return screenHeight/2 - navigationBarHeight;
    }
    else if ([self.unique count] == 3) {
        return screenHeight/3 - navigationBarHeight;
    }
    else if ([self.unique count] == 4) {
        return screenHeight/4 - navigationBarHeight;
    }
    return 60;
}

#pragma mark GET TASKS


-(void)getAllTasks {
    
    self.activ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activ.center = CGPointMake(screenWidth/2, screenHeight/2);
    [self.view addSubview:self.activ];
    [self.activ startAnimating];
    
    [[API sharedAPI] getTasks:^(NSArray *responseGetTasks, NSError *errorGetTasks) {
        if(errorGetTasks) {
            self.task = [[FloatMainStorage sharedMainStorage] returnWithPeoplId:
                         self.task.people_id withTasks:
                         self.task.tasks withHours:
                         self.task.hours_pd];
        }
        else {
            NSString *peopleID = [[FloatMainStorage sharedMainStorage] returnPeopleIDDefaults];
            self.task = [[TasksObjectObject alloc] initWithPeopleID:
                         [[responseGetTasks valueForKey:@"people"] valueForKey:@"people_id"] withTasks:
                         [[responseGetTasks valueForKey:@"people"] valueForKey:@"tasks"] withHours:
                         [[[responseGetTasks valueForKey:@"people"] valueForKey:@"tasks"] valueForKey:@"hours_pd"] withPersonID:peopleID];
        }
        [self structure];
        
        if([[self.projectName valueForKey:@"person_name"] objectAtIndex:0] == nil) {
            self.title = @"Нет проектов";
        }
        else {
            self.title = [NSString stringWithFormat:@"%@",[[self.projectName valueForKey:@"person_name"] objectAtIndex:0]];
        }
        
        if([self.projectName count] > 0) {
            [self setupTableViewTasks];
        }
        else {
            [self setupSorryView];
        }
    
        [self.activ stopAnimating];
        [self.activ setHidesWhenStopped:YES];
    }];
}

-(void)structure {
    
    NSDate *dateToday =[NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [format stringFromDate:dateToday];
    
    NSDate *dateWeak =[NSDate date];
    NSDateFormatter *formatWeak = [[NSDateFormatter alloc] init];
    [formatWeak setDateFormat:@"F"];
    NSString *stringWeak = [formatWeak stringFromDate:dateWeak];
    
    if([stringWeak isEqual:@"1"]) {
        self.startWeakDay = string;
        self.endWeakDay = [NSString stringWithFormat:@"%@",[dateToday dateByAddingTimeInterval:4*86400]];
    }
    else {
        self.startWeakDay = [NSString stringWithFormat:@"%@",[dateToday dateByAddingTimeInterval:-([stringWeak integerValue] - 1)]];
    }
    
    for(int index = 0; index < [self.task.people_id count]; index++) {
        
        NSString *peopleID = [[FloatMainStorage sharedMainStorage] returnPeopleIDDefaults];
        if([peopleID isEqualToString:[NSString stringWithFormat:@"%@",[self.task.people_id objectAtIndex:index]]]) {
            
            self.projectName = [self.task.tasks objectAtIndex:index];
            self.hours_pd = [self.task.hours_pd objectAtIndex:index];
            self.start_date = [[self.task.tasks valueForKey:@"start_date"] objectAtIndex:index];
            self.end_date = [[self.task.tasks valueForKey:@"end_date"] objectAtIndex:index];
        }
    }
    
    self.unique = [NSMutableArray array];

    for (id obj in [self.projectName valueForKey:@"project_name"]) {
        if (![self.unique containsObject:obj]) {
            [self.unique addObject:obj];
        }
    }
}

#pragma mark ACTIONS

-(void)clickRightBarButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

-(void)clickLogoutButton {
    [self clear];
    
    ViewController *loginView = [[ViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginView];
    
    [self.navigationController presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)clear {
    self.projectName = nil;
    self.hours_pd = nil;
    self.start_date = nil;
    self.end_date = nil;
    self.unique = nil;
    self.task = nil;
    
    self.title = @"";
    
    [self.taskTableView removeFromSuperview];
    [self.sorryTextView removeFromSuperview];
}

@end
