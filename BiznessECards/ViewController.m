//
//  ViewController.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "ViewController.h"
#import "DefinesAndHeaders.h"
#import "OtpVC.h"


@interface ViewController ()<FBSDKLoginButtonDelegate>
{
    IQKeyboardReturnKeyHandler * returnKeyHandler;
    FBSDKLoginButton *loginButton;
    int facebook;
    int linkedin;
}
@end

@implementation ViewController

- (IBAction)myfacebookBTN:(id)sender {
    [self myButtonPressed1];
}

- (void)myButtonPressed1 {
    [loginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     facebook = 0;
     linkedin = 0;
    
    _SignupBTN.layer.cornerRadius=18.0f;
    _SignupBTN.layer.masksToBounds=YES;
    _SignupBTN.layer.borderColor=[[UIColor redColor]CGColor];
    _SignupBTN.layer.borderWidth= 2.0f;

    _signinBTN.layer.cornerRadius=18.0f;
    _signinBTN.layer.masksToBounds=YES;
   // _signinBTN.layer.borderColor=[[UIColor redColor]CGColor];
   // _signinBTN.layer.borderWidth= 2.0f;
    
    [GlobleClass AddPadding:_passwordTextfld andNeededright:YES andNeededLeft:YES];
    [GlobleClass AddPadding:_emailtxtfld andNeededright:YES andNeededLeft:YES];
    
    _passwordTextfld.layer.cornerRadius=18.0f;
    _passwordTextfld.layer.masksToBounds=YES;
    _passwordTextfld.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _passwordTextfld.layer.borderWidth= 2.0f;
    
    _emailtxtfld.layer.cornerRadius=18.0f;
    _emailtxtfld.layer.masksToBounds=YES;
    _emailtxtfld.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _emailtxtfld.layer.borderWidth= 2.0f;
    
    loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.hidden = YES;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =@[@"public_profile",@"email"];
    loginButton.delegate = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {
             NSLog(@"zad1 %@",result);
        }
     }];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);

        //  [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends , hometown , friendlists"}]
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email,gender,birthday,last_name,first_name,locale,hometown,cover, picture" forKey:@"fields"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {
                 NSLog(@"zad %@",result);
                 facebook =1;
                 
                 [SVProgressHUD showWithStatus:@"please wait"];
                 Reachability *reach=[Reachability reachabilityForInternetConnection];
                 NetworkStatus status=[reach currentReachabilityStatus];
                 NSString *url=[NSString stringWithFormat:@"%@facebookLogin/",BaseUrl];
                 NSLog(@"Url %@",url);
                 
                 if ([result objectForKey:@"email"]==nil)
                 {
                     [GlobleClass alert:@"Logging denied"];
                     [SVProgressHUD dismiss];
                 }
                 else{
                 
                 if (status) {
                     
                     ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
                     [request setDelegate:self];
                     [request setRequestMethod:@"POST"];
                     [request setPostValue:[result objectForKey:@"email"] forKey:@"email"];
                     [request setPostValue:[result objectForKey:@"first_name"] forKey:@"first_name"];
                     [request setPostValue:[result objectForKey:@"last_name"] forKey:@"last_name"];
                     [request setPostValue:[result objectForKey:@"name"] forKey:@"name"];
                     [request setPostValue:[result objectForKey:@"gender"] forKey:@"gender"];
                      [request setPostValue:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]] forKey:@"url"];

                     [request setPostValue:@"facebook" forKey:@"mode"];
                     [request setPostValue:@"qwerty" forKey:@"api_user_name"];
                     [request setPostValue:@"qwerty" forKey:@"api_key"];
                     [request setDidFinishSelector:@selector(uploadRequestFinished:)];
                     [request setDidFailSelector:@selector(uploadRequestFailed:)];
                     [request startAsynchronous];
                 }
                 }
             }
         }];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else
    {
        //
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
}

-(void)viewDidAppear:(BOOL)animated
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [super viewDidAppear:YES];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (IBAction)signinBTN:(id)sender
{
    if (_emailtxtfld.text.length<=0)
    {
      [GlobleClass alertWithMassage:@"Enter email/mobile " Title:@"Error!"];
    }
    else if (_passwordTextfld.text.length<=0)
    {
     [GlobleClass alertWithMassage:@"Please enter password" Title:@"Error!"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"please wait"];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        NetworkStatus status=[reach currentReachabilityStatus];
        NSString *url=[NSString stringWithFormat:@"%@login/",BaseUrl];
        NSLog(@"Url %@",url);
        
        if (status) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request addRequestHeader:@"Accept" value:@"application/json"];
            [request setPostValue:_emailtxtfld.text forKey:@"email"];
            [request setPostValue:_passwordTextfld.text forKey:@"password"];
            [request setPostValue:@"qwerty" forKey:@"api_user_name"];
            [request setPostValue:@"qwerty" forKey:@"api_key"];
            [request setDidFinishSelector:@selector(uploadRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startAsynchronous];
            
        }
    }
}

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    returnKeyHandler = nil;
    if (linkedin == 1)
    {
        if ([[dic objectForKey:@"responsecode"] boolValue])
        {
             [NSUserDefaults setObject:@"YES" forKey:@"YES"];
            [NSUserDefaults setObject:[dic objectForKey:@"ID"] forKey:@"userID"];
            [NSUserDefaults setObject:[dic objectForKey:@"pending_balance"] forKey:@"walletamount"];
            [NSUserDefaults setObject:[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"first_name"],[dic objectForKey:@"last_name"]] forKey:@"name"];
            
             [NSUserDefaults setObject:[dic objectForKey:@"email"] forKey:@"email"];
            
//             [NSUserDefaults setObject:[dic objectForKey:@"mobile"] forKey:@"phone"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:pictureURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                    [NSUserDefaults setObject:data forKey:@"url"];
                }
                else
                {
                  NSLog(@"%@",connectionError);
                }
            }];

            [self nextVC];
          
        }
    }
    else if (facebook==1)
    {
        if ([[dic objectForKey:@"responsecode"] boolValue])
        {
        [NSUserDefaults setObject:@"YES" forKey:@"YES"];
        [NSUserDefaults setObject:[dic objectForKey:@"ID"] forKey:@"userID"];
        [NSUserDefaults setObject:[dic objectForKey:@"email"] forKey:@"email"];
        [NSUserDefaults setObject:[dic objectForKey:@"name"] forKey:@"name"];
        [NSUserDefaults setObject:[dic objectForKey:@"pending_balance"] forKey:@"walletamount"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:pictureURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                   [NSUserDefaults setObject:data forKey:@"url"];
                    
                }
                else
                {
                    NSLog(@"%@",connectionError);
                }
            }];

    
        [self nextVC];
       
        }
    }
    else if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        [NSUserDefaults setObject:[dic objectForKey:@"ID"] forKey:@"userID"];
       // [GlobleClass alertWithMassage :[dic objectForKey:@"responseMessage"]Title:@"Alert!"];
        [self otpvc];
    }
    else
    {
        [GlobleClass alertWithMassage :@"Invalid Login Credentials" Title:@"Alert!"];
    }
    linkedin = 0;
    facebook = 0;
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

- (IBAction)LinkedinButtonTouchUpInside:(id)sender
{
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    if (linkedIn.isValidToken) {
        
        linkedIn.customSubPermissions = [NSString stringWithFormat:@"%@,%@", first_name, last_name];
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            
            NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@", userInfo[@"firstName"], userInfo[@"lastName"] ];
            
            NSLog(@"user Info : %@", desc);
            
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    } else {
        
        linkedIn.cancelButtonText = @"Close";
        // Or any other language But Default is Close
        
        NSArray *permissions = @[@(BasicProfile),
                                 @(EmailAddress),
                                 @(Share),
                                 @(CompanyAdmin)];
        
        linkedIn.showActivityIndicator = YES;
        
        //#warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl - And state
        
        [linkedIn requestMeWithSenderViewController:self  clientId:@"81x2ompdsbs9ss" clientSecret:@"TmMd7irRcsxL3uqh"  redirectUrl:@"http://banksousou.com/login/callback" permissions:permissions state:@"linkedin(Int(NSDate().timeIntervalSince1970))" successUserInfo:^(NSDictionary *userInfo) {
            
            [SVProgressHUD showWithStatus:@"please wait"];
            Reachability *reach=[Reachability reachabilityForInternetConnection];
            NetworkStatus status=[reach currentReachabilityStatus];
            NSString *url=[NSString stringWithFormat:@"%@linkdnLogin/",BaseUrl];
            NSLog(@"Url %@",url);
            
            if (status) {
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
                [request setDelegate:self];
                [request setRequestMethod:@"POST"];
                [request setPostValue:userInfo[@"emailAddress"] forKey:@"email"];
                [request setPostValue:userInfo[@"firstName"] forKey:@"first_name"];
                [request setPostValue:userInfo[@"lastName"] forKey:@"last_name"];
                [request setPostValue:userInfo[@"headline"] forKey:@"headline"];
                [request setPostValue:userInfo[@"industry"] forKey:@"industry"];
                [request setPostValue:userInfo[@"pictureUrl"] forKey:@"url"];
                
                [request setPostValue:@"linkedIn" forKey:@"mode"];
                [request setPostValue:@"qwerty" forKey:@"api_user_name"];
                [request setPostValue:@"qwerty" forKey:@"api_key"];
                linkedin = 1;
                [request setDidFinishSelector:@selector(uploadRequestFinished:)];
                [request setDidFailSelector:@selector(uploadRequestFailed:)];
                [request startAsynchronous];
            }
            
            LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
            [linkedIn logout];
        }
        failUserInfoBlock:^(NSError *error) {
         NSLog(@"error : %@", error.userInfo.description);
            //self.btnLogout.hidden = !linkedIn.isValidToken;
          }
         ];
    }
}

- (IBAction)forgotBTN:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtpVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"forgotpassword"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    ivc.definesPresentationContext = YES;
    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:ivc animated:YES completion:nil];
    
}

-(void)otpvc
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtpVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.definesPresentationContext = YES;
    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:ivc animated:YES completion:nil];
}

-(void)nextVC
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIStoryboard *mainstory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *home = [mainstory instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
    nav.navigationBarHidden = YES;
    app.window.rootViewController = nil;
    app.window.rootViewController = nav;
}



@end
