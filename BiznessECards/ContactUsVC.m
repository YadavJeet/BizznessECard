//
//  ContactUsVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/8/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "ContactUsVC.h"
#import "DefinesAndHeaders.h"
#import "MainView.h"
#import <MessageUI/MessageUI.h>


@interface ContactUsVC ()<MFMailComposeViewControllerDelegate>

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fullnametxtfld.text = [NSUserDefaults objectForKey:@"name"];
    _emailTxtfld.text = [NSUserDefaults objectForKey:@"email"];
    _mobileNo.text = [NSUserDefaults objectForKey:@"phone"];
    
    [_phoneButton addTarget:self action:@selector(phoneDieler) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_emailButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:ivc animated:NO];
}

- (IBAction)submitBTN:(id)sender
{
    
    if (_mobileNo.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Mobile number field should not be blank." Title:@"Error!"];
    }
    else if (_mobileNo.text.length<10)
    {
        [GlobleClass alertWithMassage:@"Please enter Valid Mobile number" Title:@"Error!"];
    }
    else if (_message.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Message field should not be blank." Title:@"Error!"];
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
       else
    {
        [SVProgressHUD showWithStatus:@"please wait"];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        
        NetworkStatus status=[reach currentReachabilityStatus];
        
        NSString *url=[NSString stringWithFormat:@"%@contactUs/",BaseUrl];
        NSLog(@"Url %@",url);
        
        if (status) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setPostValue:_emailTxtfld.text forKey:@"email"];
            [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
            [request setPostValue:_message.text forKey:@"message"];
            [request setPostValue:_mobileNo.text forKey:@"phone"];
            [request setPostValue:_fullnametxtfld.text forKey:@"name"];
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
         [GlobleClass alertWithMassage :@"Thank you for contacting us. Our team will get back to you within 24 hours" Title:@"Alert!"];
    }
    else
    {
        [GlobleClass alertWithMassage :@"server problem , please try again." Title:@"Alert!"];
    }
    
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

-(void)phoneDieler
{if (_phoneButton.titleLabel.text.length>0)
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneButton.titleLabel.text]]];
}
}



- (void)sendEmail {
    
    if (_emailButton.titleLabel.text.length>0)
    {
        
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            [mailCont setToRecipients:[NSArray arrayWithObject:_emailButton.titleLabel.text]];
            [self presentViewController:mailCont animated:YES completion:nil];
        }else[GlobleClass alertWithMassage:@"Please integrate mail id in your mailer" Title:@"Alert!"];
        NSLog(@"click : %@",_emailButton.titleLabel.text);
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
