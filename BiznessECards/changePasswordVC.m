//
//  changePasswordVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "changePasswordVC.h"
#import "DefinesAndHeaders.h"

@interface changePasswordVC ()

@end

@implementation changePasswordVC

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    [super viewDidLoad];
    _changepwdButton.layer.cornerRadius=5;
     _view1.layer.cornerRadius=10;
    // Do any additional setup after loading the view.
  
}
- (IBAction)changepwdBTN:(id)sender
{
    if (_oldtextfld.text.length<=0)
    {
        [GlobleClass alert:@"Please enter your current password"];
    }
    else if (_NewTxtFld.text.length<=0)
    {
        [GlobleClass alert:@"Please enter your new password"];
    }
    else if (_RePassfld.text.length<=0)
    {
        [GlobleClass alert:@"Please enter your re-password"];
    }
    else if (_NewTxtFld.text.length<6)
    {
        [GlobleClass alert:@"Password should be minimum 6 charecter long."];
    }
    else if ([_oldtextfld.text isEqual:_NewTxtFld.text])
    {
        [GlobleClass alert:@"Same Password as previous!"];
        _RePassfld.text = nil;
        _NewTxtFld.text = nil;
        [_NewTxtFld becomeFirstResponder];
        
    }
    else if (![_NewTxtFld.text isEqual:_RePassfld.text])
    {
        [GlobleClass alert:@"Password Doesn't Match"];
        _RePassfld.text = nil;
        _NewTxtFld.text = nil;
        [_NewTxtFld becomeFirstResponder];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"please wait"];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        NetworkStatus status=[reach currentReachabilityStatus];
        NSString *url=[NSString stringWithFormat:@"%@changePassword/",BaseUrl];
        NSLog(@"Url %@",url);
        
        if (status) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request addRequestHeader:@"Accept" value:@"application/json"];
            [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
            [request setPostValue:_oldtextfld.text forKey:@"oldpassword"];
            [request setPostValue:_NewTxtFld.text forKey:@"newpassword"];
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
        if ([[dic objectForKey:@"responsecode"] boolValue])
        {
            [GlobleClass alertWithMassage:[dic valueForKey:@"responseMessage"] Title:@"Alert!"];
             [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [GlobleClass alertWithMassage:[dic valueForKey:@"responseMessage"] Title:@"Alert!"];
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
- (IBAction)cancelBTN:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
