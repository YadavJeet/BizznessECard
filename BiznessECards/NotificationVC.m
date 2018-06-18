//
//  NotificationVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/8/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "NotificationVC.h"
#import "DefinesAndHeaders.h"

@interface NotificationVC ()
{
    NSArray*notification_list;
}
@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url=[NSString stringWithFormat:@"%@cardShareNotification/",BaseUrl];
    [self servicecall:url];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [notification_list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     templatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_noti"];;
    
    cell.notificationLBL.text = [[notification_list objectAtIndex:indexPath.row]valueForKey:@"message"];
    [cell.acceptBTN addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    cell.acceptBTN.tag=indexPath.row;
    [cell.declineBTN addTarget:self action:@selector(decline:) forControlEvents:UIControlEventTouchUpInside];
    cell.declineBTN.tag=indexPath.row;

    return cell;
}
-(void)decline:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [notification_list objectAtIndex:indexPath.row];
    [self accept_decline_service:[templateData valueForKey:@"id"] Status:@"2"];
}

-(void)accept:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [notification_list objectAtIndex:indexPath.row];
    [self accept_decline_service:[templateData valueForKey:@"id"] Status:@"1"];
}


-(void)servicecall: (NSString*)url
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    NSLog(@"Url %@",url);
    
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    if (!([dic objectForKey:@"notification"]==nil))
    {
        notification_list = [dic objectForKey:@"notification"];
        [_TV reloadData];
    }
    else if ([[dic valueForKey:@"responseMessage"]isEqualToString:@"Sorry, Record not found !!!"])
    {     notification_list = nil;
         [_TV reloadData];
    }
    else
    {
        NSString *url=[NSString stringWithFormat:@"%@cardShareNotification/",BaseUrl];
        [self servicecall:url];
    }
    
     [SVProgressHUD dismiss];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

-(void)accept_decline_service: (NSString*)new_id Status:(NSString*)status_value
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    NSString *url=[NSString stringWithFormat:@"%@cardShareStatusUpdate/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:new_id forKey:@"id"];
        [request setPostValue:status_value forKey:@"status"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
    
}
- (IBAction)backBTN:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
