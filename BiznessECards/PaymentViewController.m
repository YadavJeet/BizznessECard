//
//  PaymentViewController.m
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Stripe/Stripe.h>
#import "ViewController.h"
#import "DefinesAndHeaders.h"
#import "PaymentViewController.h"

@interface PaymentViewController () <STPPaymentCardTextFieldDelegate>
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"BiznessEcard Payment";
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Setup save button
    NSString *title = [NSString stringWithFormat:@"Pay $%@", self.amount];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    saveButton.enabled = NO;
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Setup payment view
    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
    paymentTextField.delegate = self;
    self.paymentTextField = paymentTextField;
    [self.view addSubview:paymentTextField];
    
    // Setup Activity Indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicator;
    [self.view addSubview:activityIndicator];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 15;
    CGFloat width = CGRectGetWidth(self.view.frame) - (padding * 2);
    self.paymentTextField.frame = CGRectMake(padding, padding, width, 44);
    
    self.activityIndicator.center = self.view.center;
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.isValid;
}

- (void)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender {
    if (![self.paymentTextField isValid]) {
        return;
    }
    if (![Stripe defaultPublishableKey]) {
        NSError *error = [NSError errorWithDomain:StripeDomain code:STPInvalidRequestError userInfo:@{
        NSLocalizedDescriptionKey: @"Please specify a Stripe Publishable Key in Constant.h"
        }];
        
        [self.delegate paymentViewController:self didFinish:error];
        return;
    }
    [self.activityIndicator startAnimating];
    [[STPAPIClient sharedClient] createTokenWithCard:self.paymentTextField.cardParams  completion:^(STPToken *token, NSError *error)
     {
         NSString*tokencreate = [NSString stringWithFormat:@"%@",token];
         
         
         NSString*amount = [NSString stringWithFormat:@"%@",self.amount];
         NSInteger cents = [amount integerValue];
         NSInteger total = cents * 100 ;
          NSString*totalamount = [NSString stringWithFormat:@"%ld",(long)total];
         NSLog(@"Token:%@ Amount:%@", tokencreate,totalamount);
         
         Reachability *reach=[Reachability reachabilityForInternetConnection];
         
         NetworkStatus status=[reach currentReachabilityStatus];
         
         NSString *url=@"http://biznessecards.com/BiznessEcards/stripePay/";
         NSLog(@"Url %@",url);
         
         if (status) {
             ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
             [request setDelegate:self];
             [request setRequestMethod:@"POST"];
             [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
             [request setPostValue:@"qwerty" forKey:@"api_user_name"];
             [request setPostValue:@"qwerty" forKey:@"api_key"];
              [request setPostValue:totalamount forKey:@"amount"];
              [request setPostValue:tokencreate forKey:@"stripeToken"];
             [request setPostValue:@"card payment" forKey:@"description"];

             [request setDidFinishSelector:@selector(uploadRequestFinished:)];
             [request setDidFailSelector:@selector(uploadRequestFailed:)];
             [request startAsynchronous];
         }


     }];
}

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        [self.activityIndicator stopAnimating];
        NSError * error;
        [self.delegate paymentViewController:self didFinish:error];
        
    }else
    {
        [GlobleClass alertWithMassage:@"Please enter vaild card" Title:@"Alert!"];
        [self.activityIndicator stopAnimating];
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

@end
