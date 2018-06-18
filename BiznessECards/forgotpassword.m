//
//  forgotpassword.m
//  BiznessECards
//
//  Created by Tarun Pal on 6/3/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "forgotpassword.h"
#import "DefinesAndHeaders.h"

@interface forgotpassword ()

@end

@implementation forgotpassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    _emaitxtfld.layer.cornerRadius=20.0f;
    _emaitxtfld.layer.masksToBounds=YES;
    _emaitxtfld.layer.borderColor=[[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _emaitxtfld.layer.borderWidth= 2.0f;
    
    [GlobleClass AddPadding:_emaitxtfld andNeededright:YES andNeededLeft:YES];
    
    _btn.layer.cornerRadius=20.0f;
    _btn.layer.masksToBounds=YES;
    
    _view1.layer.cornerRadius=5.0f;
    _view1.layer.masksToBounds=YES;
//    _view1.layer.borderColor=[[UIColor redColor]CGColor];
//    _view1.layer.borderWidth= 2.0f;
    
    [_btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}
-(void)submit
{
    //[self dismissViewControllerAnimated:YES completion:nil];
           [SVProgressHUD showWithStatus:@"please wait"];
    
                Reachability *reach=[Reachability reachabilityForInternetConnection];
                NetworkStatus status=[reach currentReachabilityStatus];
                NSString *url=[NSString stringWithFormat:@"%@forgotPassword/",BaseUrl];
                NSLog(@"Url %@",url);
    
                if (status) {
    
                    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
                    [request setDelegate:self];
                    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8;"];
                    [request setRequestMethod:@"POST"];
                    [request setPostValue:_emaitxtfld.text forKey:@"email"];
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
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [GlobleClass alertWithMassage :[dic objectForKey:@"responseMessage"] Title:@"Alert!"];

    }
    else
    {
        [GlobleClass alertWithMassage :@"server problem , please try again" Title:@"Alert!"];
    }
    
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}
- (IBAction)dismissBTN:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
