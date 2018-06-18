//
//  SliderView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/19/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "SliderView.h"
#import "ViewController.h"
#import "MainView.h"
#import "DefinesAndHeaders.h"


@interface SliderView ()<SWRevealViewControllerDelegate>
{
    NSArray *menu;
    UIImage *img;
    UIImageView *imageView;

    
}
@end

@implementation SliderView

- (void)viewDidLoad {
    [super viewDidLoad];
    menu = @[@"one", @"two", @"three",@"jeet",@"five",@"seven",@"eight",@"six"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    tableView.backgroundColor = [UIColor whiteColor];
//    tableView.separatorColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        headerView.backgroundColor = [UIColor whiteColor];
    
       img = [[UIImage alloc] init];

    
       if ([NSUserDefaults  objectForKey:@"url"] != nil){
        NSData *profileData = [[NSData alloc] initWithData:[NSUserDefaults  objectForKey:@"url"]];
        img = [[UIImage alloc] initWithData:profileData];
       }else{
           
         
           img = [UIImage imageNamed:@"user_profile.png"];
       }
    
        imageView = [[UIImageView alloc] initWithImage:img];
        imageView.frame = CGRectMake(10,10,40,40);
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.masksToBounds=YES;
//        imageView.layer.borderWidth=2;
//        imageView.layer.borderColor = [UIColor redColor].CGColor;
        [headerView addSubview:imageView];
    
        UILabel * namelabel = [[UILabel alloc]init];
        namelabel.frame = CGRectMake(60,10,190, 20);
        namelabel.textAlignment = NSTextAlignmentLeft;
        namelabel.font = [UIFont fontWithName:@"Futura" size:14];
        namelabel.numberOfLines = 1;
        namelabel.text = [NSUserDefaults objectForKey:@"name"] ;
        namelabel.adjustsFontSizeToFitWidth = YES;
        [headerView addSubview:namelabel];
    
        UILabel * maillabel = [[UILabel alloc]init];
        maillabel.frame = CGRectMake(60,30,190, 20);
        maillabel.textAlignment = NSTextAlignmentLeft;
        maillabel.font = [UIFont fontWithName:@"Futura" size:13];
        maillabel.numberOfLines = 0;
        maillabel.text = [NSUserDefaults objectForKey:@"email"];
        maillabel.adjustsFontSizeToFitWidth = YES;
    
       UILabel * linelabel = [[UILabel alloc]init];
      linelabel.frame = CGRectMake(0,59,self.view.frame.size.width, 1);
      linelabel.backgroundColor = [UIColor lightGrayColor];
      [headerView addSubview:linelabel];

    
        [headerView addSubview:maillabel];
    return headerView;
}
-(void)logout:(id)sender
{
    [NSUserDefaults removeObjectForKey:@"userID"];
    [NSUserDefaults removeObjectForKey:@"url"];
    [NSUserDefaults removeObjectForKey:@"cardID"];
    [NSUserDefaults removeObjectForKey:@"name"];
    [NSUserDefaults removeObjectForKey:@"phone"];
    [NSUserDefaults removeObjectForKey:@"email"];
    [NSUserDefaults removeObjectForKey:@"YES"];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    [linkedIn logout];

    [self performSegueWithIdentifier:@"logout" sender:self];
}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row ==0)
//    {
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//        UIStoryboard *mainstory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SWRevealViewController *home = [mainstory instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
//        nav.navigationBarHidden = YES;
//        app.window.rootViewController = nil;
//        app.window.rootViewController = nav;
//    }
//    else if (indexPath.row ==1)
//    {
//    }
//    else if (indexPath.row ==2)
//    {
//    }
//    else if (indexPath.row ==3)
//    {
//        NSLog(@"logout");
//        ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        [self presentViewController:controller animated:YES completion:NULL];
//    }
//}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"logout"]) {
        
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self logout:self];
        }];
        
        UIAlertAction *NOAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //            homeVC *spec = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
            //            [self presentViewController:spec animated:NO completion:nil];
        }];
        
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Are you sure you want to logout from BiznessEcard.?"];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:18.0]
                      range:NSMakeRange(24, 8)];
        [actionSheet setValue:hogan forKey:@"attributedTitle"];
        
        [actionSheet addAction:YesAction];
        [actionSheet addAction:NOAction];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        return NO;
    }
//    else if ([identifier isEqualToString:@"main"])
//    {
//                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//                UIStoryboard *mainstory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                SWRevealViewController *home = [mainstory instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
//                nav.navigationBarHidden = YES;
//                app.window.rootViewController = nil;
//                app.window.rootViewController = nav;
//    }
    return YES;
}


@end
