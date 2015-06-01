//
//  TodayViewController.m
//  FloatExt
//
//  Created by Антон Дитятив on 28.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

#pragma mark VIEW METHODS

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultsDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    [self getTasks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    self.preferredContentSize = CGSizeMake(0, 200);
    
    completionHandler(NCUpdateResultNewData);
}

#pragma mark TABLE VIEW METHODS

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:
                                                CellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGFloat redLevel    = rand() / (float) RAND_MAX;
    CGFloat greenLevel  = rand() / (float) RAND_MAX;
    CGFloat blueLevel   = rand() / (float) RAND_MAX;
    
    CGFloat hue = (arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:3];
    
    NSDictionary *attributesTitleName = @{NSFontAttributeName :
                                              [UIFont fontWithName:@"Helvetica" size:14], NSParagraphStyleAttributeName:
                                              paragraphStyle, NSForegroundColorAttributeName:
                                              [UIColor blackColor]};
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:
                                          [NSString stringWithFormat:@"%@ (%@)",[self.unique objectAtIndex:indexPath.row],[self.hours_pd  objectAtIndex:indexPath.row]] attributes:
                                          attributesTitleName];
    CGRect paragraphRect = [message boundingRectWithSize:
                            CGSizeMake(screenWidth - 60, CGFLOAT_MAX)
                                                 options:
                            (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                 context:
                            nil];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setFrame:CGRectMake(0, 0, paragraphRect.size.width, paragraphRect.size.height)];
    [cell.textLabel setAttributedText:message];
    [cell.textLabel setNumberOfLines:0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel sizeToFit];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    [cell setBackgroundColor:[UIColor colorWithRed:redLevel green:greenLevel blue:blueLevel alpha:0.5]];
    [cell setBackgroundColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.5]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *customURL = [NSURL URLWithString:@"iOSDevLtst://"];
    [self.extensionContext openURL:customURL completionHandler:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.unique count] > 5) {
        return 5;
    }
    return [self.unique count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return 40;
}

#pragma mark GET TASKS

-(void)getTasks {
    
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
            self.task = [[TasksObjectObject alloc] initWithPeopleID:
                         [[responseGetTasks valueForKey:@"people"] valueForKey:@"people_id"] withTasks:
                         [[responseGetTasks valueForKey:@"people"] valueForKey:@"tasks"] withHours:
                         [[[responseGetTasks valueForKey:@"people"] valueForKey:@"tasks"] valueForKey:@"hours_pd"] withPersonID:nil];
        }
        [self structure];
        
        self.title = [NSString stringWithFormat:@"%@",[[self.projectName valueForKey:@"person_name"] objectAtIndex:0]];
        
        if([self.projectName count] > 0) {
            [self setupUI];
        }
        else {
            [self setupUI2];
        }
        
        [self.activ stopAnimating];
        [self.activ setHidesWhenStopped:YES];
    }];
    
}

-(void)structure {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ltst.float"];
    for(int index = 0; index < [self.task.people_id count]; index++) {

        if([[sharedDefaults valueForKey:@"people_id"] isEqualToString:
            [NSString stringWithFormat:@"%@",[self.task.people_id objectAtIndex:index]]]) {
            
            self.projectName = [self.task.tasks objectAtIndex:index];
            self.hours_pd = [self.task.hours_pd objectAtIndex:index];
        }
    }
    
    self.unique = [NSMutableArray array];
    
    for (id obj in [self.projectName valueForKey:@"project_name"]) {
        if (![self.unique containsObject:obj]) {
            [self.unique addObject:obj];
        }
    }
}

#pragma mark SETUP UI

-(void)setupUI {
    //Tasks > 0
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)setupUI2 {
    //Tasks = 0
    UITextView *sorryTextView = [[UITextView alloc] initWithFrame:
                                 CGRectMake(0, navigationBarHeight*3, screenWidth - 60, screenHeight)];
    [sorryTextView setText:@"Прости, чувак, но на данный момент нет проектов на твоем счету"];
    [sorryTextView setTextContainerInset:UIEdgeInsetsMake(0, 10, 10, 10)];
    [sorryTextView setTextAlignment:NSTextAlignmentCenter];
    [sorryTextView setSelectable:NO];
    [sorryTextView setEditable:NO];
    [self.view addSubview:sorryTextView];
}

#pragma mark ACTIONS

-(void)userDefaultsDidChange:(NSNotification *)notification {
    [self structure];
    [self.tableView reloadData];
}


@end
