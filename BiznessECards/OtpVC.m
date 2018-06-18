//
//  OtpVC.m
//  BiznessECards
//
//  Created by Tarun Pal on 6/10/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "OtpVC.h"
#import "DefinesAndHeaders.h"

@interface OtpVC ()

@end

@implementation OtpVC
- (IBAction)BackBTN:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    _otptxtfld.layer.cornerRadius=20.0f;
    _otptxtfld.layer.masksToBounds=YES;
    _otptxtfld.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _otptxtfld.layer.borderWidth= 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resendBTN:(id)sender
{
    [SVProgressHUD showWithStatus:@"please wait"];
    
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    NSString *url=[NSString stringWithFormat:@"%@resendOTP/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"id"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setDidFinishSelector:@selector(uploadRequestFinished1:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
}

- (IBAction)verifyBTN:(id)sender
{
    if (_otptxtfld.text.length<=0)
    {
        [GlobleClass alert:@"Please enter 6 digit OTP code "];
    }else
    {
        [SVProgressHUD showWithStatus:@"please wait"];

            Reachability *reach=[Reachability reachabilityForInternetConnection];
            NetworkStatus status=[reach currentReachabilityStatus];
            NSString *url=[NSString stringWithFormat:@"%@otp/",BaseUrl];
            NSLog(@"Url %@",url);
            
            if (status) {
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
                [request setDelegate:self];
                [request setRequestMethod:@"POST"];
                [request setPostValue:_otptxtfld.text forKey:@"otp"];
                [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
                [request setPostValue:@"qwerty" forKey:@"api_user_name"];
                [request setPostValue:@"qwerty" forKey:@"api_key"];
                [request setDidFinishSelector:@selector(uploadRequestFinished:)];
                [request setDidFailSelector:@selector(uploadRequestFailed:)];
                [request startAsynchronous];
            }
        }
}

-(void)uploadRequestFinished1:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
    [GlobleClass alertWithMassage:@"OTP has been sent successfully on your email ID. Please check" Title:@"Alert!"];
    }
}
 -(void)uploadRequestFinished:(ASIHTTPRequest *)request
    {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
        NSLog(@"data %@", dic);
        if ([[dic objectForKey:@"responsecode"] boolValue])
        {
            [NSUserDefaults setObject:[dic objectForKey:@"email"] forKey:@"email"];
            [NSUserDefaults setObject:[dic objectForKey:@"name"] forKey:@"name"];
            [NSUserDefaults setObject:[dic objectForKey:@"phone"] forKey:@"phone"];
            
            [NSUserDefaults setObject:[dic objectForKey:@"pending_balance"] forKey:@"walletamount"];
            
            [NSUserDefaults setObject:@"YES" forKey:@"YES"];
            
            [self performSegueWithIdentifier:@"otp" sender:self];
        }
        else
        {
            [GlobleClass alertWithMassage :@"OTP does not match , please try again" Title:@"Alert!"];
        }
        
    }
    
 - (void)uploadRequestFailed:(ASIHTTPRequest *)request {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
        NSLog(@"====%@",dic);
  }
@end
