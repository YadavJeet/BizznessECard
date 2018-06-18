//
//  MainView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "MainView.h"
#import "DefinesAndHeaders.h"
#import "MycardVC.h"

@interface MainView ()<UIScrollViewDelegate>
{
    Singleton * singleton;
    NSMutableArray *Active_countArr;
    int activevalue;
    NSArray* notific;
}
@property (weak, nonatomic) IBOutlet UIImageView *changeImage;
@end

@implementation MainView

-(void)imagechange
{
    _changeImage.image=[UIImage imageNamed:@"card.png"];
    [self performSelector:@selector(imagechange1) withObject:nil afterDelay:4.0];
}
-(void)imagechange1
{
    _changeImage.image=[UIImage imageNamed:@"card3_main.jpg"];
    [self performSelector:@selector(imagechange3) withObject:nil afterDelay:4.0];
}
-(void)imagechange3
{
    _changeImage.image=[UIImage imageNamed:@"card1_main.png"];
    [self performSelector:@selector(imagechange4) withObject:nil afterDelay:4.0];
}


-(void)imagechange4
{
    _changeImage.image=[UIImage imageNamed:@"card2_main"];
    [self performSelector:@selector(imagechange) withObject:nil afterDelay:4.0];
}


- (void)viewDidLoad {
    singleton = [Singleton createInstance];
    [super viewDidLoad];
    [self performSelector:@selector(imagechange) withObject:nil afterDelay:4.0];
    self.title = @"BiznessEcards";

    NSLog(@"userid: %@",[NSUserDefaults objectForKey:@"userID"]);
    _menuBtn.target = self.revealViewController;
    _menuBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    
   }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self GetCardservice:@"1"];
    NSNumber *value =[NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

}

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    
    if (!([dic objectForKey:@"notification"]==nil))
    {
        notific = [dic objectForKey:@"notification"];
        self.notficationBtn.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)notific.count];
        self.notficationBtn.badgeBGColor = [UIColor colorWithRed:0.88 green:1.00 blue:0.10 alpha:1.0];
         [SVProgressHUD dismiss];
    }
    else if ([[dic objectForKey:@"responseMessage"] isEqualToString:@"Sorry, Record not found !!!"])
    {
         [SVProgressHUD dismiss];
        self.notficationBtn.badgeValue =0;
        self.notficationBtn.badgeBGColor = [UIColor clearColor];
    }
    else if (activevalue ==1)
    {
        NSArray *savecardArr = [dic objectForKey:@"savedcard-list"];
        _save_count.text = [NSString stringWithFormat:@"%ld",(unsigned long)savecardArr.count];
        activevalue =0;
        NSString *url=[NSString stringWithFormat:@"%@getBizCard/",BaseUrl];
        [self servicecall:url];
    }
    else if (!([dic objectForKey:@"savedcard-list"]==nil))
    {   int total = 0;
        NSArray *activeArr = [dic objectForKey:@"savedcard-list"];
        if (activeArr.count>0) {
            
        
        NSArray *activeArr = [dic objectForKey:@"savedcard-list"];
        Active_countArr= [[NSMutableArray alloc]init];
        for (int i=0; i<=activeArr.count-1; i++)
        {
            [Active_countArr addObject:[activeArr valueForKey:@"availablecount"]];
        }
        
        for (int j=0; j<=Active_countArr.count-1; j++) {
            total = total+ [[Active_countArr objectAtIndex:j][j]intValue];
        }
            
        }
        _Active_count.text = [NSString stringWithFormat:@"%ld",(long)total];
         activevalue = 1;
        [self GetCardservice:@"2"];
    }
    else
    {
        singleton.userDetail =dic;
        NSString *url=[NSString stringWithFormat:@"%@cardShareNotification/",BaseUrl];
        [self servicecall:url];
    }
    
   
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)newCardBTN:(id)sender
{
    [self performSegueWithIdentifier:@"new" sender:self];
}

- (IBAction)offerBTN:(id)sender
{
    
}

- (IBAction)notificationBTN:(id)sender
{
    if (notific.count==0)
    {
        [GlobleClass alertWithMassage:@"Sorry,currently there are no notification available for you" Title:@"Alert!"];
        
    }else
    {
      [self performSegueWithIdentifier:@"notify" sender:self];
    }
    
}


- (IBAction)MyCardBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MycardVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MycardVC"];
    [ivc setStringvalue:@"1"];
    [self.navigationController pushViewController:ivc animated:YES];
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

-(void)GetCardservice: (NSString*)cardType
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@cardList/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:cardType forKey:@"type"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
}

@end
