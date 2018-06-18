//
//  ContactUsVC.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/8/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileNo;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UITextField *fullnametxtfld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtfld;
@end
