//
//  InviteVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/13/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "InviteVC.h"
#import "DefinesAndHeaders.h"

@interface InviteVC ()
@property (weak, nonatomic) IBOutlet UILabel *CopunLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuopanHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coupanWidth;

@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Invite Friends & Earn";
    if (IS_IPHONE_5)
    {
        _coupanWidth.constant = 138;
        _cuopanHeight.constant = 44;
    }
    else if (IS_IPHONE_6P)
    {
        _cuopanHeight.constant = 88;
    }
   
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@genRefralCode/",BaseUrl];
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

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    if ([[dic objectForKey:@" responsecode"] boolValue])
    {
        _CopunLbl.text = [dic objectForKey:@"referralcode"];
         share = [[NSString alloc]initWithFormat:@"Haven't tried BiznessEcard yet? Design your digital Business Card now using the most simplified app and share it with your contacts. \n \n Use my Coupon Code:- %@ to avail attractive discount. \n Download the app now: https://goo.gl/abG9QB",[dic objectForKey:@"referralcode"]];
        [NSUserDefaults setObject:[dic objectForKey:@"referralcode"] forKey:@"referralcode"];
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    
    
    NSLog(@"====%@",dic);
}

- (IBAction)InviteFrndBTN:(id)sender
{
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[share] applicationActivities:nil];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBTN:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
