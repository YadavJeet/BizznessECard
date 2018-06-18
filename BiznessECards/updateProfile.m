//
//  updateProfile.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/15/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "updateProfile.h"
#import "DefinesAndHeaders.h"

@interface updateProfile ()
{
    Singleton *singleton;
}
@end

@implementation updateProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Update Profile";
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    _updateButton.layer.cornerRadius=5;
    _editview.layer.cornerRadius=10;
    _full_name.text =     [NSUserDefaults objectForKey:@"name"];
    _addresstexfld.text = [NSUserDefaults objectForKey:@"email"];
    _mobile_number.text = [NSUserDefaults objectForKey:@"phone"];
    
}

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        [NSUserDefaults setObject:_full_name.text forKey:@"name"];
        [NSUserDefaults setObject:_mobile_number.text forKey:@"phone"];
        [NSUserDefaults setObject:_addresstexfld.text forKey:@"email"];
        [NSUserDefaults setObject:[dic objectForKey:@"pendingbalance"] forKey:@"walletamount"];
        [GlobleClass alertWithMassage:@"Your profile Successfully update" Title:@"Alert!"];
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
         [GlobleClass alertWithMassage:@"Some error occured in edit profile" Title:@"Alert!"];
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
- (IBAction)backBTN:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BTNUpdate:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@editProfile/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:_full_name.text forKey:@"name"];
        [request setPostValue:_mobile_number.text forKey:@"mobile"];
        [request setPostValue:_addresstexfld.text forKey:@"emailid"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }

}
@end
