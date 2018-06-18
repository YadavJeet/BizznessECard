//
//  PreviewView.m
//  BiznessECards
//  Created by Tarun Pal on 5/20/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "PreviewView.h"
#import "DefinesAndHeaders.h"
#import <MessageUI/MessageUI.h> 

@interface PreviewView ()<MFMailComposeViewControllerDelegate>
{
    Singleton * singleton;
}
@end

@implementation PreviewView

- (void)viewDidLoad
{
    NSLog(@"data %@",_deatil);
    if ([_check isEqualToString:@"1"])
    {
        self.title = @"View Detail's";
        [_F_imageview sd_setImageWithURL:[NSURL URLWithString:[_deatil valueForKey:@"frontview"]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        [_B_imageview sd_setImageWithURL:[NSURL URLWithString:[_deatil valueForKey:@"backview"]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        _cardLbl.text = [NSString stringWithFormat:@"Name: %@",[_deatil valueForKey:@"name"]];
        _dateLbl.text = [NSString stringWithFormat:@"Designation: %@",[_deatil valueForKey:@"designation"]];
        _priceLbl.text = [NSString stringWithFormat:@"Company: %@",[_deatil valueForKey:@"company"]];
        
       [_phoneButton setTitle:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"phone"]] forState: UIControlStateNormal];
        
        [_emailButton setTitle:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"emailid"]] forState: UIControlStateNormal];
        [_facebookButton setTitle:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"facebook"]] forState: UIControlStateNormal];
        
        [_linkedinButton setTitle:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"linkedin"]] forState: UIControlStateNormal];
        
        [_twetterButton setTitle:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"twitter"]] forState: UIControlStateNormal];
        
        [_webButton setTitle:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"website"]] forState: UIControlStateNormal];
        
        [_phoneButton addTarget:self action:@selector(phoneDieler) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_emailButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
        
         [_facebookButton addTarget:self action:@selector(facebookurl) forControlEvents:UIControlEventTouchUpInside];
        
         [_linkedinButton addTarget:self action:@selector(linkedinurl) forControlEvents:UIControlEventTouchUpInside];
        
         [_twetterButton addTarget:self action:@selector(twetterurl) forControlEvents:UIControlEventTouchUpInside];
        
         [_webButton addTarget:self action:@selector(weburl) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
    self.title = @"Preview";
    [_F_imageview sd_setImageWithURL:[NSURL URLWithString:[_deatil valueForKey:@"frontview"]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [_B_imageview sd_setImageWithURL:[NSURL URLWithString:[_deatil valueForKey:@"backview"]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    _cardLbl.text = [NSString stringWithFormat:@"Total Card: %@",[_deatil valueForKey:@"cardcount"]];
     _priceLbl.text = [NSString stringWithFormat:@"Price: $%@",[_deatil valueForKey:@"packageprice"]];
        
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"dd-MM-yyyy";
//        NSDate *string = [formatter dateFromString:[NSString stringWithFormat:@"%@",[_deatil valueForKey:@"transactiondate"]]];
//        formatter.dateFormat = @"MM-dd-yyyy";
        
        _dateLbl.text = [NSString stringWithFormat:@"Transaction Date : %@",[_deatil valueForKey:@"transactiondate"]];
        
        _phoneButton.userInteractionEnabled = NO;
        _emailButton.userInteractionEnabled = NO;
        _webButton.userInteractionEnabled = NO;
        _facebookButton.userInteractionEnabled = NO;
        _linkedinButton.userInteractionEnabled = NO;
        _twetterButton.userInteractionEnabled = NO;
        _phntxt.hidden=YES;
        _webtxt.hidden=YES;
    }
    
     [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{

}
-(void)phoneDieler
{if (_phoneButton.titleLabel.text.length>0)
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneButton.titleLabel.text]]];
}
}

- (IBAction)backBTN:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)facebookurl
{
    if (_facebookButton.titleLabel.text.length>0) {

    NSString *pURL = @"https://www.facebook.com";
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
    }
}
-(void)linkedinurl
{
     if (_linkedinButton.titleLabel.text.length>0) {
    NSString *pURL = @"https://www.linkedin.com";
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
     }
}
-(void)twetterurl
{
    if (_twetterButton.titleLabel.text.length>0) {
    
    NSString *pURL = @"https://twitter.com/search?q=%23login&lang=en";
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
    }
}
-(void)weburl
{
    if (_webButton.titleLabel.text.length>0) {

    NSString *pURL = [NSString stringWithFormat:@"https://%@",_webButton.titleLabel.text];
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
    }
}

@end
