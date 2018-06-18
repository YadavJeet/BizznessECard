//
//  PaymentView.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/28/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.

#import "PaymentView.h"
#import "DefinesAndHeaders.h"
#import <PassKit/PassKit.h>
#import "MainView.h"
#import "PaymentViewController.h"

@interface PaymentView ()<PayPalPaymentDelegate,PKPaymentAuthorizationViewControllerDelegate,PaymentViewControllerDelegate>
{
    __weak IBOutlet UILabel *after_disLbl;
    NSArray *package_list ;
    int Coupane_code;
    int PACKAGE_ID;
    int payment_by;
    int amount;
    int package_id;
    int tamplate_amount;
    int net_amount;
    int walletamount;
    int card_count;
    int coupan_amount;
    int wallettotal;
    int Coupanetotal;
    
    Singleton* singleton;
}
@property(nonatomic,strong)PayPalConfiguration *payPalConfig;
@property(nonatomic, readonly) NSDate *transactionDate;

@end

@implementation PaymentView
@synthesize btn3,btn4,btn2,btn1;

- (void)viewDidLoad
{
    
    
    _applyBTN.userInteractionEnabled = YES;
    singleton = [Singleton createInstance];
    NSLog(@"Card cost: %@",singleton.card_cost);
    
    walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
    _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
    
    _descount_amount.text =@"$0";
    coupan_amount =0;
    
    if (!((singleton.card_cost)==nil))
    {
        _templet_cost.text = [NSString stringWithFormat:@"$%@",singleton.card_cost] ;
        tamplate_amount = [singleton.card_cost intValue] ;
    }else
    {
        _templet_cost.text = @"$0";
        tamplate_amount =0;
    }
    
    [super viewDidLoad];
    [self selectBTN];
    [self paypalmetod];
    [self getPriceDetailService];
    self.title = @"Make Payment";
    
    
    // Conditionally show Apple Pay button based on device availability
     _appleButton = [_appleButton initWithPaymentButtonType:PKPaymentButtonTypeInStore paymentButtonStyle:PKPaymentButtonStyleBlack];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (singleton.offername!=0) {
        _coupanFld.text = singleton.offername;
    }
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
}
- (IBAction)backBTN:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)selectBTN
{
    btn1.tag=1;
    [btn1 setBackgroundImage: [UIImage imageNamed:@"OvalSelected"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn2.tag=2;
    [btn2 setBackgroundImage: [UIImage imageNamed:@"OvalSelected"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn3.tag=3;
    [btn3 setBackgroundImage: [UIImage imageNamed:@"OvalSelected"] forState:UIControlStateSelected];
    [btn3 addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn4.tag=4;
    [btn4 setBackgroundImage: [UIImage imageNamed:@"OvalSelected"] forState:UIControlStateSelected];
    [btn4 addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)btnclicked:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            if ([btn1 isSelected]==YES) {
                [btn1 setSelected:NO];
            }
            else
            {
                amount = [[package_list valueForKey:@"price"][0] intValue];
                package_id = [[package_list valueForKey:@"id"][0] intValue];
                card_count = [[package_list valueForKey:@"card_count"][0] intValue];
                
                [btn1 setSelected:YES];
                [btn2 setSelected:NO];
                [btn4 setSelected:NO];
                [btn3 setSelected:NO];
            }
            break;
        case 2:
            if ([btn2 isSelected]==YES) {
                [btn2 setSelected:NO];
            }
            else
            {
                package_id = [[package_list valueForKey:@"id"][1] intValue];
                amount = [[package_list valueForKey:@"price"][1] intValue];
                card_count = [[package_list valueForKey:@"card_count"][1] intValue];
                [btn2 setSelected:YES];
                [btn1 setSelected:NO];
                [btn4 setSelected:NO];
                [btn3 setSelected:NO];
            }
            break;
        case 3:
            if ([btn3 isSelected]==YES) {
                [btn3 setSelected:NO];
            }
            else
            { package_id = [[package_list valueForKey:@"id"][2] intValue];
                amount = [[package_list valueForKey:@"price"][2] intValue];
                card_count = [[package_list valueForKey:@"card_count"][2] intValue];
                [btn3 setSelected:YES];
                [btn2 setSelected:NO];
                [btn1 setSelected:NO];
                [btn4 setSelected:NO];
            }
            break;
        case 4:
            if ([btn4 isSelected]==YES) {
                [btn4 setSelected:NO];
            }
            else
            {
                package_id = [[package_list valueForKey:@"id"][3] intValue];
                amount = [[package_list valueForKey:@"price"][3] intValue];
                card_count = [[package_list valueForKey:@"card_count"][3] intValue];
                [btn4 setSelected:YES];
                [btn2 setSelected:NO];
                [btn1 setSelected:NO];
                [btn3 setSelected:NO];
            }
            break;
            
        default:
            break;
    }
    
    
    _card_cost.text = [NSString stringWithFormat:@"$%d",amount];
    int amount_total = amount+tamplate_amount;
    _total_amount.text = [NSString stringWithFormat:@"$%d",amount_total];
    _net_payble_amount.text = [NSString stringWithFormat:@"$%d",amount_total-coupan_amount];
    
    
    if (amount_total<=coupan_amount)
    {
        int total = amount_total-(amount_total-5);
        Coupanetotal= amount_total-total;
        after_disLbl.text = [NSString stringWithFormat:@"$%d",total];
        [GlobleClass alert:[NSString stringWithFormat:@"Maximum discount that can be applied $%d",(amount_total-5)]];
        net_amount = total;
        _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
        
    }else{
        
        int after_dis_total = amount_total-coupan_amount;
        Coupanetotal= 0;
        after_disLbl.text = [NSString stringWithFormat:@"$%d",after_dis_total];
        net_amount = after_dis_total;
        _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
        
    }
    
    if (net_amount <=5)
    {
        NSLog(@"jeetu");
        wallettotal = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
        walletamount= 0;
    }
    else if (walletamount>=net_amount)
    {
        _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
        walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
        wallettotal = walletamount-(net_amount-5);
        walletamount= walletamount-wallettotal;
        
        [GlobleClass alert:[NSString stringWithFormat:@"Maximum wallet amount that can be applied $%d",walletamount]];
        
        NSLog(@"walletamount : %d",wallettotal);
        net_amount=5;
        _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
        
    }
    else
    {
        _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
        walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
        net_amount= net_amount-walletamount;
        _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
    }
    
    
}

-(void)paypalmetod
{
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = @"PayPal";
    
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    NSLog(@"Paypal : %@",[PayPalMobile libraryVersion]);
    
}



- (IBAction)paypal_amount:(id)sender
{
    if (([btn1 isSelected] || [btn2 isSelected] || [btn3 isSelected] || [btn4 isSelected]) == NO )
    {
        [GlobleClass alertWithMassage:@"Please select card package" Title:@"Alert!"];
    }
    else
    {
        PayPalItem *item1;
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        
        item1 = [PayPalItem itemWithName:@"Card Payment"  withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",net_amount]] withCurrency:@"USD" withSku:@"Sku-fund"];
        payment.shortDescription = @"Your Card Payment";
        
        NSArray *items = @[item1];
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
        
        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
        
        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
        
        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
        
        NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        
        
        payment.amount = total;
        payment.currencyCode = @"USD";
        
        payment.items = items;
        payment.paymentDetails = paymentDetails;
        
        if (!payment.processable)
        {
            [GlobleClass alert:@"Payment Not Processable"];
        }
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
        
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}
-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Payment Cancel!!");
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment{
    NSLog(@"Payment Complete");
    
    NSDate* datetime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateTimeInIsoFormatForZuluTimeZone = [dateFormatter stringFromDate:datetime];
    [self serviceCall:dateTimeInIsoFormatForZuluTimeZone Type:@"Paypal"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)serviceCall: (NSString*)date Type:(NSString*)type
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    
    NSString *url=[NSString stringWithFormat:@"%@savePayment/",BaseUrl];
    NSLog(@"Url %@",url);
    payment_by = 1;
    
    if (status) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"]forKey:@"userid"];
        [request setPostValue:_coupanFld.text forKey:@"referral_code"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:[NSString stringWithFormat:@"%d",net_amount] forKey:@"amount"];
        [request setPostValue:singleton.savecard_id forKey:@"savedcard_id"];
        [request setPostValue:date forKey:@"pmt_date"];
        [request setPostValue:@"iPhone" forKey:@"device"];
        [request setPostValue:type forKey:@"mode"];
        [request setPostValue:[NSString stringWithFormat:@"%d",Coupanetotal] forKey:@"discount_amount"];
        [request setPostValue:[NSString stringWithFormat:@"%d",walletamount] forKey:@"wallet_amount"];
        [request setPostValue:[NSString stringWithFormat:@"%d",card_count] forKey:@"card_count"];
        [request setPostValue:[NSString stringWithFormat:@"%d",amount] forKey:@"package_price"];
        [request setPostValue:[NSString stringWithFormat:@"%d",package_id] forKey:@"packageid"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
        
        
        
    }
}
-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"Response:  %@", dic);
    if (payment_by ==1)
    {
        singleton.card_cost =0;
        singleton.pricing_id =0;
        [NSUserDefaults setObject:[NSString stringWithFormat:@"%d",wallettotal] forKey:@"walletamount"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        [self.navigationController pushViewController:ivc animated:NO];
        [GlobleClass alertWithMassage:@"Payment completed" Title:@"Alert!"];
        payment_by =0;
    }
    else if (PACKAGE_ID==1)
    {
        package_list = [dic objectForKey:@"package_list"];
        _cardLbl1.text = [NSString stringWithFormat:@"        %@ Card's at $%@",[package_list valueForKey:@"card_count"][0],[package_list valueForKey:@"price"][0]];
        _cardLbl2.text = [NSString stringWithFormat:@"        %@ Card's at $%@",[package_list valueForKey:@"card_count"][1],[package_list valueForKey:@"price"][1]];
        _cardLbl3.text = [NSString stringWithFormat:@"        %@ Card's at $%@",[package_list valueForKey:@"card_count"][2],[package_list valueForKey:@"price"][2]];
        _cardLbl4.text = [NSString stringWithFormat:@"        %@ Card's at $%@",[package_list valueForKey:@"card_count"][3],[package_list valueForKey:@"price"][3]];
        NSString *pricing = [[NSString alloc]init];
        for (int i=0; i<package_list.count; i++)
        {
            pricing = [package_list valueForKey:@"id"][i];
            if (pricing == singleton.pricing_id)
            {
                if ([singleton.pricing_id isEqualToString:@"6"])
                {
                    [btn1 setSelected:YES];
                    amount = [[package_list valueForKey:@"price"][0] intValue];
                    package_id = [[package_list valueForKey:@"id"][0] intValue];
                    card_count = [[package_list valueForKey:@"card_count"][0] intValue];
                }
                if ([singleton.pricing_id isEqualToString:@"5"])
                {
                    [btn2 setSelected:YES];;
                    amount = [[package_list valueForKey:@"price"][1] intValue];
                    package_id = [[package_list valueForKey:@"id"][1] intValue];
                    card_count = [[package_list valueForKey:@"card_count"][1] intValue];
                }
                if ([singleton.pricing_id isEqualToString:@"7"])
                {
                    [btn3 setSelected:YES];
                    amount = [[package_list valueForKey:@"price"][2] intValue];
                    package_id = [[package_list valueForKey:@"id"][2] intValue];
                    card_count = [[package_list valueForKey:@"card_count"][2] intValue];
                }
                if ([singleton.pricing_id isEqualToString:@"8"])
                {
                    [btn4 setSelected:YES];
                    amount = [[package_list valueForKey:@"price"][3] intValue];
                    package_id = [[package_list valueForKey:@"id"][3] intValue];
                    card_count = [[package_list valueForKey:@"card_count"][3] intValue];
                }
                
                _card_cost.text = [NSString stringWithFormat:@"$%d",amount];
                int amount_total = amount+tamplate_amount;
                _total_amount.text = [NSString stringWithFormat:@"$%d",amount_total];
                _net_payble_amount.text = [NSString stringWithFormat:@"$%d",amount_total-coupan_amount];
                net_amount = amount_total;
                
                if (walletamount>=net_amount)
                {
                    _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
                    walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
                    wallettotal = walletamount-(net_amount-5);
                    walletamount= walletamount-wallettotal;
                    NSLog(@"walletamount : %d",wallettotal);
                    net_amount=5;
                    _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
                    
                }else
                {
                    _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
                    walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
                    net_amount= net_amount-walletamount;
                    _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
                }
            }
            
        }
        PACKAGE_ID = 0;
        
    }
    else if (Coupane_code==1)
    {
        if ([[dic objectForKey:@"responsecode"] boolValue])
        {
            _descount_amount.text =[NSString stringWithFormat:@"$%@",[dic valueForKey:@"discountamount"]];
            coupan_amount = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"discountamount"]]intValue];
            _coupanFld.userInteractionEnabled= NO;
            _applyBTN.userInteractionEnabled = NO;
            [_applyBTN setBackgroundColor:[UIColor greenColor]];
            int amount_total = amount+tamplate_amount;
            if (amount_total<=coupan_amount)
            {
                int total = amount_total-(amount_total-5);
                Coupanetotal= amount_total-total;
                after_disLbl.text = [NSString stringWithFormat:@"$%d",total];
                [GlobleClass alert:[NSString stringWithFormat:@"Maximum discount that can be applied $%d",Coupanetotal]];
                net_amount = total;
                _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
                
            }
            else
            {
                int amount_total = amount+tamplate_amount;
                int total = amount_total-coupan_amount;
                Coupanetotal = 0;
                after_disLbl.text = [NSString stringWithFormat:@"$%d",total];
                net_amount = total;
                _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
                
            }
            
            if (net_amount <=5)
            {
                NSLog(@"jeetu");
                wallettotal = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
                walletamount= 0;
            }
            else if (walletamount>=net_amount)
            {
                _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
                walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
                wallettotal = walletamount-(net_amount-5);
                walletamount= walletamount-wallettotal;
                
                [GlobleClass alert:[NSString stringWithFormat:@"Maximum wallet amount that can be applied $%d",walletamount]];
                NSLog(@"walletamount : %d",wallettotal);
                net_amount=5;
                _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
                
            }else
            {
                _tax_amount.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
                walletamount = [[NSString stringWithFormat:@"%@",[NSUserDefaults objectForKey:@"walletamount"]]intValue];
                net_amount= net_amount-walletamount;
                _net_payble_amount.text = [NSString stringWithFormat:@"$%d",net_amount];
            }
        }
        else
        {
            [GlobleClass alertWithMassage:@"Incorrect Code, please try again." Title:@"Alert!"];
        }
        Coupane_code=0;
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

-(void)getPriceDetailService
{
    PACKAGE_ID = 1;
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@/package/",BaseUrl];
    NSLog(@"Url %@",url);
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
}

- (IBAction)offerBTN:(id)sender
{
    _coupanFld.userInteractionEnabled= YES;
    _applyBTN.userInteractionEnabled = YES;
    [_applyBTN setBackgroundColor:[UIColor redColor]];
    [self performSegueWithIdentifier:@"offer" sender:self];
}

- (IBAction)Coupan_applyBTN:(id)sender
{
    singleton.offername = nil;
    
    if (_coupanFld.text.length<=0)
    {
        [GlobleClass alertWithMassage:@"Please enter promo code" Title:@"Alert!"];
    }
    else if (btn1.isSelected == NO && btn2.isSelected ==NO && btn3.isSelected ==NO && btn4.isSelected ==NO)
    {
        [GlobleClass alert:@"Please select pricing of card after applye your Coupan code"];
    }
    else
    {
        
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        NetworkStatus status=[reach currentReachabilityStatus];
        
        NSString *url=[NSString stringWithFormat:@"%@discountAmount/",BaseUrl];
        
        NSLog(@"Url %@",url);
        if (status) {
            Coupane_code = 1;
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setPostValue:@"qwerty" forKey:@"api_user_name"];
            [request setPostValue:@"qwerty" forKey:@"api_key"];
            [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
            [request setPostValue:_coupanFld.text forKey:@"couponcode"];
            [request setDidFinishSelector:@selector(uploadRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startAsynchronous];
        }
    }
    
}

- (IBAction)applepay_amount:(id)sender
{
    if (([btn1 isSelected] || [btn2 isSelected] || [btn3 isSelected] || [btn4 isSelected]) == NO )
    {
        [GlobleClass alertWithMassage:@"Please select card package" Title:@"Alert!"];
    }
    else{
        
        if([PKPaymentAuthorizationViewController canMakePayments])
        {
            NSLog(@"PKPayment can make payments");
        }
        
//        UIButton *btnApplePay = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhiteOutline];
//        [btnApplePay setFrame:CGRectMake(0, 0, self.Apple_payBTN.frame.size.width, self.Apple_payBTN.frame.size.height)];
//        [self.Apple_payBTN addSubview:btnApplePay];
        
//        UIButton *btnApplePay = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhiteOutline];
//        [btnApplePay setFrame:CGRectMake(10, 10, 294, 50)];
//        [self.view.superview bringSubviewToFront:btnApplePay];
//        [self.view addSubview:btnApplePay];
        
        PKPaymentRequest *payment = [[PKPaymentRequest alloc] init];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"BiznessEcard Payment" amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",net_amount]]];
        
        payment.paymentSummaryItems = @[total];
        payment.countryCode = @"US";
        payment.currencyCode = @"USD";
        payment.merchantIdentifier = @"merchant.com.BiznessEcards.us";
        
        payment.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
        
        payment.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa,PKPaymentNetworkMasterCard,PKPaymentNetworkAmex];
        
        NSLog(@"payment: %@", payment);
        PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:payment];
        vc.delegate = self;
        if (vc !=nil)
        {
            [self presentViewController:vc animated:YES completion:NULL];
        }else
        {
            [GlobleClass alert:@"Please configure a valid credit/debit card (US/UK based card only)."];
        }
        
    }
    
}

#pragma mark - Payment delegate

//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
//    NSLog(@"didSelectPaymentMethod");
//    completion(@[]);
//}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    NSLog(@"didSelectShippingContact");
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    NSLog(@"didSelectShippingMethod");
}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"paymentAuthorizationViewControllerWillAuthorizePayment");
    
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    NSLog(@"Payment successful!: %@, %@", payment.token, payment.token.transactionIdentifier);
    
    completion(PKPaymentAuthorizationStatusSuccess);
    
    
    NSDate* datetime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateTimeInIsoFormatForZuluTimeZone = [dateFormatter stringFromDate:datetime];
    
    
    [self serviceCall:dateTimeInIsoFormatForZuluTimeZone Type:@"Apple Pay"];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"finish");
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - PaymentViewControllerDelegate Methods

#pragma mark - IBAction Methods
- (IBAction)btnStripeTapped:(id)sender
{
    if (([btn1 isSelected] || [btn2 isSelected] || [btn3 isSelected] || [btn4 isSelected]) == NO )
    {
        [GlobleClass alertWithMassage:@"Please select card package" Title:@"Alert!"];
    }
    else{
        PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
        paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",net_amount]];
        paymentViewController.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
        
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - Other Methods


- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (error) {
            [self showDialougeWithTitle:@"Error" andMessage:[error localizedDescription]];
        } else {
            
            NSDate* datetime = [NSDate date];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString* dateTimeInIsoFormatForZuluTimeZone = [dateFormatter stringFromDate:datetime];
            
            
            [self serviceCall:dateTimeInIsoFormatForZuluTimeZone Type:@"Stripe Pay"];
            
            //            [self showDialougeWithTitle:@"Success" andMessage:@"Payment Successfully Created."];
            
        }
    }];
}
- (void)showDialougeWithTitle:(NSString *)strTitle andMessage:(NSString *)strMessage
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

//- (UIButton *)applePayButton {
//    UIButton *button;
//    if ([PKPaymentButton class]) { // Available in iOS 8.3+
//        button = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleBlack];
//    } else {
//        // Create and return your own apple pay button
//    }
//    [button addTarget:self action:@selector(tappedApplePay) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
@end
