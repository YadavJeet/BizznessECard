//
//  PaymentView.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/28/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefinesAndHeaders.h"
#import <PassKit/PassKit.h>
#import "MainView.h"
#import "PaymentViewController.h"
@import PassKit;

@interface PaymentView : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UITextField *coupanFld;
@property (weak, nonatomic) IBOutlet UILabel *card_cost;
@property (weak, nonatomic) IBOutlet UILabel *templet_cost;
@property (weak, nonatomic) IBOutlet UILabel *total_amount;
@property (weak, nonatomic) IBOutlet UILabel *descount_amount;
@property (weak, nonatomic) IBOutlet UILabel *tax_amount;
@property (weak, nonatomic) IBOutlet UILabel *net_payble_amount;
@property (weak, nonatomic) IBOutlet UIButton *Apple_payBTN;
@property (weak, nonatomic) IBOutlet UIButton *paypal_amount;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl1;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl2;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl3;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl4;
- (IBAction)Coupan_applyBTN:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *applyBTN;
@property (weak, nonatomic) IBOutlet UIButton *walletBTN;
@property (strong, nonatomic) IBOutlet PKPaymentButton *appleButton;

@end
