//
//  SignupView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "SignupView.h"
#import "DefinesAndHeaders.h"
#import "OtpVC.h"

@interface SignupView ()<UITextFieldDelegate>
{
    IQKeyboardReturnKeyHandler * returnKeyHandler;
    UIView *view1;
    UIView *Superview;
    UIButton *OkBTN;
     UIButton *ResendBTN;
    UITextField * OTP;
    NSString* userID;
    //UILabel * textLBL;
}
@end

@implementation SignupView
@synthesize btn1;
- (void)viewDidLoad {
    [super viewDidLoad];
    btn1.tag=1;
    [btn1 setBackgroundImage: [UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _signinBTN.layer.cornerRadius=18.0f;
    _signinBTN.layer.masksToBounds=YES;
    _signinBTN.layer.borderColor=[[UIColor redColor]CGColor];
    _signinBTN.layer.borderWidth= 2.0f;
    
    [GlobleClass AddPadding:_mobileNo andNeededright:YES andNeededLeft:YES];
    [GlobleClass AddPadding:_password andNeededright:YES andNeededLeft:YES];
    [GlobleClass AddPadding:_fullnametxtfld andNeededright:YES andNeededLeft:YES];
    [GlobleClass AddPadding:_emailTxtfld andNeededright:YES andNeededLeft:YES];
    
    _mobileNo.layer.cornerRadius=18.0f;
    _mobileNo.layer.masksToBounds=YES;
    _mobileNo.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _mobileNo.layer.borderWidth= 2.0f;
    
    _password.layer.cornerRadius=18.0f;
    _password.layer.masksToBounds=YES;
    _password.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _password.layer.borderWidth= 2.0f;
    
    _fullnametxtfld.layer.cornerRadius=18.0f;
    _fullnametxtfld.layer.masksToBounds=YES;
    _fullnametxtfld.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _fullnametxtfld.layer.borderWidth= 2.0f;
    
    _emailTxtfld.layer.cornerRadius=18.0f;
    _emailTxtfld.layer.masksToBounds=YES;
    _emailTxtfld.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _emailTxtfld.layer.borderWidth= 2.0f;
    
    _CreateAcBTN.layer.cornerRadius=18.0f;
    _CreateAcBTN.layer.masksToBounds=YES;
    _CreateAcBTN.layer.borderColor=[[UIColor redColor]CGColor];
    _CreateAcBTN.layer.borderWidth= 2.0f;
    
    [_CreateAcBTN addTarget:self action:@selector(signupBTN:) forControlEvents:UIControlEventTouchUpInside];
    

    // Do any additional setup after loading the view.
}
- (void)btnclicked:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            if ([btn1 isSelected]==YES) {
                [btn1 setSelected:NO];
            }
            else
            {
                [btn1 setSelected:YES];
            }
        default:
            break;
    }
}
- (void)signupBTN:(UIButton *)sender
{
    if (_mobileNo.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Mobile number field should not be blank." Title:@"Error!"];
    }
    else if (_mobileNo.text.length<10)
    {
        [GlobleClass alertWithMassage:@"Please enter Valid Mobile number" Title:@"Error!"];
    }
    else if (_password.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Password field should not be blank." Title:@"Error!"];
    }
    else if (_password.text.length<=5)
    {
        [GlobleClass alertWithMassage:@"Your password must be at least 6 characters" Title:@"Error!"];
    }

    else if (_fullnametxtfld.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Name field should not be blank." Title:@"Error!"];
    }
    else if (_emailTxtfld.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Email field should not be blank." Title:@"Error!"];
    }
    else if (![GlobleClass NSStringIsValidEmail:_emailTxtfld.text])
    {
        [GlobleClass alertWithMassage:@"Please enter valid email address." Title:@"Error!"];
    }
    else if (btn1.isSelected == NO)
    {
        [GlobleClass alertWithMassage:@"Please Accept the terms and conditions" Title:@"Error!"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"please wait"];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        
        NetworkStatus status=[reach currentReachabilityStatus];
        
        NSString *url=[NSString stringWithFormat:@"%@registration/",BaseUrl];
        NSLog(@"Url %@",url);
        
        if (status) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setPostValue:_emailTxtfld.text forKey:@"email"];
            [request setPostValue:_password.text forKey:@"password"];
            [request setPostValue:_mobileNo.text forKey:@"phone"];
            [request setPostValue:_fullnametxtfld.text forKey:@"full_name"];
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
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
         [NSUserDefaults setObject:[dic objectForKey:@"ID"] forKey:@"userID"];
        [self otpvc];
    }
    else
    {
        [GlobleClass alertWithMassage :@"email id Already Exits" Title:@"Alert!"];
    }
    
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)otpvc
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtpVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.definesPresentationContext = YES;
    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:ivc animated:NO completion:nil];
}

@end
