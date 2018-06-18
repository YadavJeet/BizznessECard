//
//  SignupView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupView : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *fullnametxtfld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtfld;
@property (weak, nonatomic) IBOutlet UIButton *signinBTN;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *CreateAcBTN;

@end
